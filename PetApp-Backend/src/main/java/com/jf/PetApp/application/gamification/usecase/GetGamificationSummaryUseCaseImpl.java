package com.jf.PetApp.application.gamification.usecase;

import org.springframework.stereotype.Service;

import com.jf.PetApp.application.gamification.dto.GamificationSummaryResult;
import com.jf.PetApp.application.gamification.service.LevelCalculator;
import com.jf.PetApp.application.gamification.service.XpLedgerService;
import com.jf.PetApp.application.user.port.UserRepository;
import com.jf.PetApp.core.domain.User;
import com.jf.PetApp.core.domain.gamification.PlayerLevel;

@Service
public class GetGamificationSummaryUseCaseImpl implements GetGamificationSummaryUseCase {

    private final UserRepository userRepository;
    private final XpLedgerService xpLedgerService;

    public GetGamificationSummaryUseCaseImpl(UserRepository userRepository, XpLedgerService xpLedgerService) {
        this.userRepository = userRepository;
        this.xpLedgerService = xpLedgerService;
    }

    @Override
    public GamificationSummaryResult execute(String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        int totalXp = xpLedgerService.totalXpFor(user.getId());
        PlayerLevel level = LevelCalculator.fromXp(totalXp);

        return new GamificationSummaryResult(totalXp, level.level(), level.xpIntoLevel(), level.xpForNextLevel());
    }
}
