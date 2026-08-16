package com.jf.PetApp.application.gamification.achievement;

import java.util.List;

/**
 * The fixed, permanent achievement catalog — the authoritative, server-side
 * mirror of {@code petapp_mobile/lib/features/portfolio/domain/services/achievement_catalog.dart}.
 * Ids, XP rewards and conditions must stay identical to that file; the
 * mobile catalog keeps its own copy only for display metadata (title/
 * description/icon) and for previewing not-yet-saved portfolio changes —
 * this list is what actually grants XP.
 *
 * Per DECISION-014 (XP must never reward investment profit/wealth/portfolio
 * size), several achievements below are kept as zero-XP milestones.
 */
public final class AchievementCatalog {

    private AchievementCatalog() {
    }

    public static final List<AchievementDefinition> DEFINITIONS = List.of(
            new AchievementDefinition("first_investment", 50, AchievementContext::hasHoldings),
            new AchievementDefinition("first_dividend", 75, c -> c.monthlyPassiveIncomeEstimate() > 0),
            new AchievementDefinition("positive_return", 0, c -> c.totalGain() > 0),
            new AchievementDefinition("portfolio_10k", 0, c -> c.currentValue() >= 10_000),
            new AchievementDefinition("portfolio_50k", 0, c -> c.currentValue() >= 50_000),
            new AchievementDefinition("diversification_master", 200, c -> c.distinctTypeCount() >= 4),
            new AchievementDefinition("etf_collector", 150, c -> c.distinctFundsTickerCount() >= 3),
            new AchievementDefinition("hundred_days", 200,
                    c -> c.firstPurchaseDate() != null && c.daysSinceFirstPurchase(java.time.LocalDate.now()) >= 100),
            new AchievementDefinition("long_term_investor", 500,
                    c -> c.firstPurchaseDate() != null && c.daysSinceFirstPurchase(java.time.LocalDate.now()) >= 365),
            new AchievementDefinition("dividend_hunter", 250, c -> c.annualPassiveIncomeEstimate() >= 1_000));
}
