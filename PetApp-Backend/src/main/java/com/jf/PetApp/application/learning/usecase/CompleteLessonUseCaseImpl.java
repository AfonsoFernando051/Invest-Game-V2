package com.jf.PetApp.application.learning.usecase;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jf.PetApp.application.common.exception.ResourceNotFoundException;
import com.jf.PetApp.application.gamification.port.AchievementRepositoryPort;
import com.jf.PetApp.application.gamification.service.LevelCalculator;
import com.jf.PetApp.application.gamification.service.StreakService;
import com.jf.PetApp.application.gamification.service.XpLedgerService;
import com.jf.PetApp.application.learning.dto.LessonCompletionResult;
import com.jf.PetApp.application.learning.port.LearningCatalogPort;
import com.jf.PetApp.application.learning.port.LessonProgressRepositoryPort;
import com.jf.PetApp.application.user.port.UserRepository;
import com.jf.PetApp.core.domain.User;
import com.jf.PetApp.core.domain.gamification.PlayerLevel;
import com.jf.PetApp.core.domain.gamification.XpEventType;
import com.jf.PetApp.core.domain.learning.LessonCatalogEntry;
import com.jf.PetApp.core.domain.learning.ModuleCatalogEntry;

/**
 * Records a lesson completion and grants its XP. Both the lesson XP and any
 * resulting module-completion bonus go through {@link XpLedgerService}, so
 * neither can ever be double-granted — replaying this call for an
 * already-completed lesson is always safe and simply reports what was
 * already earned. {@code totalXp} always includes achievement XP too (not
 * just the ledger), matching {@code GetGamificationSummaryUseCaseImpl} —
 * the client overwrites its stored XP with this total outright, so leaving
 * achievement XP out here would make completing a lesson look like it
 * erased previously-earned achievement XP.
 */
@Service
public class CompleteLessonUseCaseImpl implements CompleteLessonUseCase {

    private final UserRepository userRepository;
    private final LearningCatalogPort catalogPort;
    private final LessonProgressRepositoryPort progressRepository;
    private final XpLedgerService xpLedgerService;
    private final AchievementRepositoryPort achievementRepository;
    private final StreakService streakService;

    public CompleteLessonUseCaseImpl(
            UserRepository userRepository,
            LearningCatalogPort catalogPort,
            LessonProgressRepositoryPort progressRepository,
            XpLedgerService xpLedgerService,
            AchievementRepositoryPort achievementRepository,
            StreakService streakService) {
        this.userRepository = userRepository;
        this.catalogPort = catalogPort;
        this.progressRepository = progressRepository;
        this.xpLedgerService = xpLedgerService;
        this.achievementRepository = achievementRepository;
        this.streakService = streakService;
    }

    @Override
    @Transactional
    public LessonCompletionResult execute(String userEmail, String lessonId) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        Long userId = user.getId();

        LessonCatalogEntry lesson = catalogPort.findLesson(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Unknown lesson id: " + lessonId));

        boolean alreadyCompleted = progressRepository.isLessonCompleted(userId, lessonId);
        int xpAwarded = 0;
        if (!alreadyCompleted) {
            progressRepository.markCompleted(userId, lessonId);
            boolean granted = xpLedgerService.grantXp(userId, XpEventType.LESSON_COMPLETED, lesson.xpReward(), lessonId);
            xpAwarded = granted ? lesson.xpReward() : 0;
        }

        ModuleCatalogEntry module = catalogPort.findModule(lesson.moduleId())
                .orElseThrow(() -> new IllegalStateException("Lesson " + lessonId + " references unknown module " + lesson.moduleId()));
        List<String> moduleLessonIds = catalogPort.lessonIdsForModule(module.moduleId());
        Set<String> completedIds = progressRepository.completedLessonIds(userId);

        boolean moduleCompletedThisCall = false;
        int moduleXpAwarded = 0;
        if (completedIds.containsAll(moduleLessonIds)) {
            boolean granted = xpLedgerService.grantXp(userId, XpEventType.MODULE_COMPLETED, module.xpReward(), module.moduleId());
            if (granted) {
                moduleCompletedThisCall = true;
                moduleXpAwarded = module.xpReward();
            }
        }

        streakService.recordActivity(userId);

        int totalXp = xpLedgerService.totalXpFor(userId) + achievementRepository.totalXpFor(userId);
        PlayerLevel level = LevelCalculator.fromXp(totalXp);

        return new LessonCompletionResult(
                lessonId,
                alreadyCompleted,
                xpAwarded,
                moduleCompletedThisCall,
                moduleXpAwarded,
                totalXp,
                level.level(),
                level.xpIntoLevel(),
                level.xpForNextLevel());
    }
}
