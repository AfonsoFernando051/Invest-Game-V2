package com.jf.PetApp.application.learning.usecase;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jf.PetApp.application.gamification.service.LevelCalculator;
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
 * already earned.
 */
@Service
public class CompleteLessonUseCaseImpl implements CompleteLessonUseCase {

    private final UserRepository userRepository;
    private final LearningCatalogPort catalogPort;
    private final LessonProgressRepositoryPort progressRepository;
    private final XpLedgerService xpLedgerService;

    public CompleteLessonUseCaseImpl(
            UserRepository userRepository,
            LearningCatalogPort catalogPort,
            LessonProgressRepositoryPort progressRepository,
            XpLedgerService xpLedgerService) {
        this.userRepository = userRepository;
        this.catalogPort = catalogPort;
        this.progressRepository = progressRepository;
        this.xpLedgerService = xpLedgerService;
    }

    @Override
    @Transactional
    public LessonCompletionResult execute(String userEmail, String lessonId) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
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

        int totalXp = xpLedgerService.totalXpFor(userId);
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
