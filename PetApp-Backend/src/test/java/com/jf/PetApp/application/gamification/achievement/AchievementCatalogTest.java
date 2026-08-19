package com.jf.PetApp.application.gamification.achievement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDate;
import java.util.Set;

import org.junit.jupiter.api.Test;

/**
 * DECISION-014 regression coverage: XP must never be awarded for portfolio
 * wealth, profit, or passive-income signals — only for learning/practice
 * behavior. These achievements are kept as zero-XP milestones instead.
 */
class AchievementCatalogTest {

    private static final Set<String> WEALTH_OR_PROFIT_DERIVED_CODES = Set.of(
            "positive_return", "portfolio_10k", "portfolio_50k", "first_dividend", "dividend_hunter");

    @Test
    void wealthProfitAndIncomeDerivedAchievements_GrantZeroXp() {
        for (AchievementDefinition definition : AchievementCatalog.DEFINITIONS) {
            if (WEALTH_OR_PROFIT_DERIVED_CODES.contains(definition.code())) {
                assertEquals(0, definition.xpReward(),
                        "Achievement '" + definition.code() + "' is wealth/profit/income-derived and must grant 0 XP");
            }
        }
    }

    @Test
    void everyWealthOrProfitDerivedCodeIsStillPresentInTheCatalog() {
        Set<String> catalogCodes = AchievementCatalog.DEFINITIONS.stream()
                .map(AchievementDefinition::code)
                .collect(java.util.stream.Collectors.toSet());

        assertTrue(catalogCodes.containsAll(WEALTH_OR_PROFIT_DERIVED_CODES),
                "Expected all known wealth/profit/income-derived achievement codes to still exist in the catalog");
    }

    @Test
    void maximumAttainableXp_ExcludesEveryWealthOrProfitDerivedAchievement() {
        AchievementContext maxedOutWealthContext = new AchievementContext(
                true, 1_000_000.0, 1_000_000.0, 10, 10, LocalDate.of(2000, 1, 1), 100_000.0, 100_000.0);

        int totalXp = AchievementCatalog.DEFINITIONS.stream()
                .filter(definition -> definition.qualifies().test(maxedOutWealthContext))
                .mapToInt(AchievementDefinition::xpReward)
                .sum();

        int expectedXpFromLearningAdjacentAchievementsOnly = AchievementCatalog.DEFINITIONS.stream()
                .filter(definition -> !WEALTH_OR_PROFIT_DERIVED_CODES.contains(definition.code()))
                .mapToInt(AchievementDefinition::xpReward)
                .sum();

        assertEquals(expectedXpFromLearningAdjacentAchievementsOnly, totalXp,
                "A user with maximum wealth/profit/income should never earn more XP than the non-wealth achievements alone grant");
    }
}
