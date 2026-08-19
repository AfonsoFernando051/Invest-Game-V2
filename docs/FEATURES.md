# FEATURES.md

# Features

## Overview

This document describes Invest Game V2's features, ordered by product priority as defined in
`PRODUCT_VISION.md` §4: **Learning (primary) → Portfolio (secondary) → Gamification (motivation layer) →
Mentor (support layer)**, followed by supporting/account features.

Each feature includes purpose, responsibilities, business rules, and status. **Status distinguishes what is
implemented today (Current) from what the V2 direction requires (Target)** where the two differ materially.
This document should be updated whenever a feature is added or significantly changed.

---

# LEARNING (Academy)

## Purpose

Teach investing concepts through short, interactive lessons — the primary product surface. Full design in
`ACADEMY_ENGINE.md`.

## Responsibilities

- School → module → lesson → step progression, reachable from Home.
- Interactive lesson steps: explanation, example, micro-exercise, applied scenario, summary.
- Quizzes with immediate, encouraging feedback.
- Lesson/module/school completion tracking, with per-module and per-school prerequisites.
- XP awarded on completion.
- Knowledge Progress (curriculum completion, 10-tier) shown alongside — never merged with — Game Level.
- Progress (completion) and Mastery (performance) tracked and shown as two distinct numbers per school — see
  `ACADEMY_ENGINE.md` §3d.
- Personalized recommendations ("continue" / "review a weak concept") and a review queue for lessons not yet
  answered perfectly.
- A Financial Lab simulation area (Compound Interest today), separate from graded lesson content.

## Business Rules

- Content teaches users to *investigate* concepts (e.g. P/E, diversification), never to imply a buy/sell
  signal ("low P/E = good investment" is prohibited framing).
- No punitive mechanics. A wrong quiz answer shows the correct explanation and lets the user continue — no
  lost lives, no reset progress, no lesson failure state.
- Knowledge progress (curriculum completion) is tracked separately from XP/game level — see
  `PRODUCT_VISION.md` §9. Completing the curriculum is never conflated with "being an advanced investor."
- Mastery (performance) is tracked separately from Progress (completion) — a school can be 100% complete while
  only partially mastered; neither is ever conflated with the other in copy or logic (`ACADEMY_ENGINE.md` §3d).
- A prerequisite may only gate content that wasn't already reachable — no school/module already available to
  users can regress to locked (see `DECISIONS.md` DECISION-018).
- Review activity never awards fabricated client-side XP — XP stays backend-authoritative (see XP System below).

## Status

**Current:** School layer implemented (`DECISIONS.md` DECISION-018) — 19 schools shown as a journey, 2 with
real content (School 1 "Financial Life" → Module 1 "Money Fundamentals", 10 lessons; School 3 "Investment
Fundamentals" → the pre-existing "Fundamentos do Investidor" module, 6 lessons), 17 as "coming soon." Knowledge
Progress (`KnowledgeLevel`, 10 tiers) implemented, derived from curriculum completion — kept visually and
logically separate from Game Level. Mastery (performance-based, distinct from completion), personalized
Recommendations, a Review queue, and a Financial Lab (Compound Interest) are implemented — see
`ACADEMY_ENGINE.md` §3d / `DECISIONS.md` DECISION-020. Progress persists locally-first
(`SharedPreferences`), with best-effort backend sync (`AcademyRemoteDataSource`) reconciling completed-lesson
ids across devices and returning the authoritative XP/level after each completion — not yet a fully
backend-driven read model. Full design in `ACADEMY_ENGINE.md`.

**Target:** remaining 17 schools' content, full Question-entity metadata/question-bank architecture, a fully
backend-driven progress read model, revision-activity XP (`FEATURES.md`'s XP table already lists it; not yet
wired), practical challenges connected to real held assets, Mentor/Portfolio integration, and the remaining
Financial Lab simulations (Inflation, Fixed Income, Diversification, Portfolio).

---

# XP System

## Purpose

Reward learning behavior and educational practice. XP is the motivational layer, not a measure of wealth.

## Business rules

> **XP primarily rewards learning behavior and educational practice.** XP must never be awarded directly for
> wealth, amount invested, portfolio size, investment profit, or taking on financial risk — doing so would
> incentivize unhealthy financial behavior, which this product explicitly avoids (`PRODUCT_VISION.md` §11).

Target XP table:

| Action | XP |
|---|---:|
| Complete lesson | +20 |
| Complete quiz | +20 |
| Perfect quiz | +30 |
| Complete module | +100 |
| Complete learning path | +300 |
| Complete practice challenge | +50–150 |
| Daily mission | +30–100 |
| Weekly mission | +100–300 |
| Revision activity | +10 |

## Auditability (target)

XP must be derived from an auditable event log, not a single mutable field:

```text
XPEvent
  id
  userId
  eventType
  amount
  sourceId
  createdAt
```

Examples: `LESSON_COMPLETED +20`, `QUIZ_COMPLETED +30`, `MISSION_COMPLETED +100`,
`ACHIEVEMENT_UNLOCKED +250`. Total XP is derived from summing events, not read from a single `user.xp` column
that can drift from its history.

## Status

**Current — mostly aligned with the target principle above; ahead of what this section previously
described.** Lesson/module completion is backend-authoritative via an actual `xp_events` ledger table
(`XpLedgerService`, `POST /api/v1/learning/lessons/{lessonId}/complete`), idempotent per `(userId, eventType,
sourceId)`, restricted to `XpEventType.LESSON_COMPLETED`/`MODULE_COMPLETED` — this already matches the
Auditability target above for the learning path. `PetProfile.xp` (Flutter) is cache-first, not
locally-authoritative: it always defers to the backend's `GET /api/v1/gamification/summary` when reachable,
falling back to the last-known-real cached value only when offline.

Achievements are also backend-authoritative (`achievement_unlocks` table, evaluated live against real
portfolio data on every `GET /api/v1/achievements`), and their total XP is summed into the same "total XP"
the client displays alongside lesson/module XP. Per DECISION-014, `positive_return`, `portfolio_10k`, and
`portfolio_50k` were already zeroed out in an earlier pass; a follow-up pass (see DECISION-014's resolution
note in `DECISIONS.md`) closed the two that pass had missed — `first_dividend` and `dividend_hunter`, both
conditioned on estimated passive income (a wealth-derived signal) — which is now zero-XP on both the backend
`AchievementCatalog` and its Flutter display mirror, with regression tests on both sides.

**Remaining, narrower gap:** `AchievementContext` (backend) has no learning-progress fields at all — the
achievement system is structurally 100% portfolio-derived. `first_investment`, `diversification_master`,
`etf_collector`, `hundred_days`, and `long_term_investor` don't reference dollar amounts (so they don't
violate DECISION-014's letter), but they still reward *investment activity* rather than *learning activity* —
a softer version of the same anti-pattern, and an open product question rather than a bug (see `DECISIONS.md`
for how to record a decision on it).

The mission system is now server-side and backend-authoritative (see Missions' Status below) — a `MissionCompletionJpaEntity`/`mission_completions` table alongside the existing `xp_events`/`achievement_unlocks` tables,
all three summed by `TotalXpCalculator`. There is still no quiz-answer/mastery-gated XP model
(`CompleteLessonUseCaseImpl` grants lesson XP on a completion POST, not on demonstrated quiz correctness) —
that remains a real target-vs-current gap.

**Target:** unify lesson/module XP, achievement XP, and mission XP into one auditable `XPEvent`-shaped log
(today they are three separate tables summed by `TotalXpCalculator` — a step toward the target, not the full
target); re-scope the achievement system to include learning/practice conditions, not just portfolio-derived
ones.

---

# Levels

## Purpose

Represent motivational, XP-driven progression — distinct from knowledge progress (`PRODUCT_VISION.md` §9).

## Business Rules

- Levels never decrease.
- XP requirements increase progressively.
- A level is a motivational milestone, never presented as a financial certification.

Target level language (product copy, refinable):

```text
Level 1  Beginner
Level 5  Learner
Level 10 Explorer
Level 15 Investor
Level 20 Analyst
Level 30 Strategist
Level 40 Specialist
```

## Status

**Current:** `LevelCalculator.fromXp()` (`features/game/domain/services/`) computes a numeric level via a
triangular XP curve. No named tiers exist in the UI today.

**Target:** apply the named tiers above as the product-facing language for levels; underlying numeric curve
can stay.

---

# Pet System

## Purpose

A visual and emotional representation of the user's learning journey — not an XP counter and not a financial
risk indicator. See `PROJECT_CONTEXT.md`'s Pet Companion section for the full narrative framing.

## Responsibilities

- Species selection (identity/personality, chosen during onboarding).
- Evolution stages tied to level/XP progression.
- Cosmetic unlocks: accessories, outfits, environments.
- Reactions to learning milestones and (educationally-framed) portfolio events.

## Business Rules

- Pet never "dies," degrades, or is penalized for a wrong quiz answer or a portfolio drawdown.
- Pet species is never derived from, or presented as, a financial risk-tolerance assessment. The backend's
  separate `InvestorProfile` (Guardian/Tactician/Adventurer) risk classification has no code linkage to pet
  species today, and none should be added without an explicit, reviewed decision.
- Cosmetic progression never affects gameplay balance.

Potential evolution milestones (product language, refinable):

```text
Level 1  Basic companion
Level 5  Accessory
Level 10 Visual evolution
Level 15 Environment
Level 20 Major evolution
Level 30 Advanced form
```

## Status

**Current:** implemented. Species enum (`pet_specie_enum.dart`) has six values — Dog, Cat, Wolf, Fox, Bear,
Lion — though only Dog has a full 9-tier evolution art set (`pet_evolution_stage.dart`); other species share
the enum without dedicated evolution art yet.

**Target:** full evolution art for all five product-facing species (Dog, Wolf, Fox, Bear, Lion — Cat's status
in the product lineup needs a product decision, see Ambiguities below), accessory/habitat unlocks wired to
level milestones above.

### Persistent companion (global header)

Beyond the Home hero card (`LearningHeroCard`), a compact `PetCompanionHeader` avatar is present across every
major authenticated screen (Home, Carteira, Proventos, Academia, Mentor, Perfil) via `DashboardScreen`'s
shared AppBar, carrying one `PetCompanionController` for the whole session. Tapping it opens a lightweight
`PetInteractionSheet` (Learn / Portfolio / Progress); route-aware and event-driven copy appears as a dismissible
`PetSpeechBubbleOverlay`, never a full chat. See `ARCHITECTURE.md`'s Frontend Architecture section and
`features/pet/presentation/companion/` for the implementation.

---

# Missions

## Purpose

Guide users through educational objectives via short-term goals. Simplified from the full "Market Events"
brief in `MARKET_EVENTS_ENGINE.md` §11 (templates/instances/claim step/event-driven `GameplayReactionService`)
to the smallest Alpha-appropriate slice — see Status below for what was actually built and why.

## Responsibilities

- Daily missions: small educational actions (complete a lesson today; complete two lessons today).
- Weekly missions: larger educational actions (complete three lessons this week; complete a module this
  week).
- Live progress tracking against the current daily/weekly period; auto-completion and XP grant on the next
  evaluation once the target is met (no separate claim step — see Status).

## Business Rules

- Missions should reinforce learning and analysis, not encourage excessive trading activity or portfolio
  growth for its own sake.
- Rewards follow the XP System's rules above — every mission condition is a lesson/module completion count,
  never a wealth/profit/portfolio signal, from the first version (no wealth-tied mission ever existed to
  migrate away from, unlike the achievement catalog).

## Status

**Current: implemented, server-side, backend-authoritative.** `MissionCatalog` (backend,
`application/gamification/mission/`) is a fixed catalog of four learning-only mission definitions
(`daily_complete_lesson` +30 XP, `daily_complete_two_lessons` +60 XP, `weekly_complete_three_lessons` +100 XP,
`weekly_complete_module` +150 XP), each conditioned purely on counting `LESSON_COMPLETED`/`MODULE_COMPLETED`
`xp_events` rows within the mission's current period window (`MissionPeriodKeyCalculator` — ISO calendar date
for daily, ISO week for weekly). `EvaluateMissionsUseCaseImpl` re-evaluates every mission live on each
`GET /api/v1/missions` call and persists any newly-completed period instance to `mission_completions`
(idempotent on `(user_id, mission_code, period_key)`, mirroring `achievement_unlocks`'s pattern) — safe to
call as often as the client wants. Mission XP feeds into the same total XP as lesson/module and achievement
XP via `TotalXpCalculator`. On the client, `MissionsRepository`/`MissionsRemoteDataSource` fetch this
alongside achievements in `PortfolioController._evaluateGamification`, and a `MissionsSection` renders
progress-bar mission cards on the Portfolio tab, next to `AchievementsSection`.

Deliberately simplified vs. `MARKET_EVENTS_ENGINE.md` §11's full brief: missions auto-complete and grant XP
on evaluation rather than requiring a separate `POST /missions/{id}/claim` step, there's no `RewardLedgerService`/
multi-currency reward bundle, and mission definitions are a fixed in-code catalog (like achievements) rather
than server-configurable templates. Each of these can be added later without a breaking change if a real need
emerges — none was speculative-built now (see `AI_RULES.md`'s Avoid-overengineering guidance).

**Target:** review-activity and practice-challenge mission conditions once those systems exist; consider a
claim step if silent auto-grant proves to feel anticlimactic in practice.

---

# Achievements

## Purpose

Reward important learning and engagement milestones.

## Business Rules

- Achievements are permanent once unlocked.
- Achievement XP follows the XP System's learning-first rule going forward.

## Status

**Current:** backend-authoritative (`AchievementCatalog`/`achievement_unlocks`, evaluated live against real
portfolio data via `EvaluateAchievementsUseCaseImpl`), not local/static as previously described here. The
Flutter `achievement_catalog.dart` is a display-only mirror (title/description/icon, plus a preview XP total
for the unlock-celebration overlay and pre-save onboarding preview) — the backend catalog is what actually
persists unlocks and grants XP. Per DECISION-014, all portfolio-value/profit/passive-income-derived
achievements (`positive_return`, `portfolio_10k`, `portfolio_50k`, `first_dividend`, `dividend_hunter`) are
zero-XP milestones on both sides, with regression tests covering it. See the XP System's Status section above
for the narrower open question around investment-activity-based (non-wealth) achievements.

**Target:** unify achievement XP into the same auditable event log as lesson/module XP (see XP System's
Status above); re-scope the condition set to include learning/practice achievements, not just portfolio ones.

---

# Portfolio

## Purpose

A practical learning environment and investment tracker — not a trading terminal.
(`PRODUCT_VISION.md` §4, secondary layer.)

## Responsibilities

- Record and track holdings and transactions.
- Show allocation, performance, and dividends.
- Connect concepts learned in the Academy to real, held assets ("Educational Portfolio Intelligence" —
  `ACADEMY_ENGINE.md`, `MARKET_EVENTS_ENGINE.md`).

## Business Rules

- **The product does not execute financial orders.** Users track or simulate holdings; there is no buy/sell
  execution.
- Historical transactions are immutable.
- Portfolio value reflects tracked/simulated market data, not real trade execution.

## Status

**Current:** implemented as tracking/simulation. Backend `InvestmentController` exposes
`/configure`, `/quote/{ticker}`, `/search`, `/summary`, `/allocation`, `/history`, `/dividends`,
`/asset-details/{ticker}` — no buy/sell endpoints exist anywhere in the codebase. This already matches the
target "no execution" principle; the old Pet-Invest-App-era "Buy Assets"/"Sell Assets" features below were
aspirational and are being retired from the roadmap, not implemented.

---

# Dividend Radar

## Purpose

Show users real, confirmed dividend/JCP/yield payments for assets they actually hold, inspired by
Investidor10's dividend calendar — see `MARKET_EVENTS_ENGINE.md`'s "the number never lies" principle.

## Responsibilities

- Fetch confirmed corporate-action history (Brapi `/api/v2/stocks/dividends`) for held tickers.
- Split into upcoming (announced) and history (paid), scaled by quantity held at the relevant date.
- Surface inside the existing "Proventos" tab, above the yield-based estimate.

## Business Rules

- Never fabricate a payment — a ticker with nothing confirmed contributes nothing.
- A historical event only counts if the user held the position on or before its data-com date.

## Status

Implemented (Phase 0 slice of `MARKET_EVENTS_ENGINE.md` — no XP/mission/notification wiring yet).

---

# Educational Portfolio Intelligence

## Purpose

Connect lesson content to the user's real tracked portfolio — one of the product's core differentiators
(`PRODUCT_VISION.md` §10).

## Responsibilities

- Surface contextual educational callbacks on the asset-details and portfolio screens after a related lesson
  is completed (e.g. "you just learned about P/E — here's how it looks on this asset").
- Frame dividend/allocation events as learning opportunities, not trading cues.

## Business Rules

- Never framed as a buy/sell recommendation.
- Only triggers after the relevant lesson has actually been completed by the user.

## Status

**Target, not implemented.** Academy and Portfolio are intentionally decoupled today
(`ACADEMY_ENGINE.md` §4) — this is the highest-priority Alpha-stage gap. See `ROADMAP.md`.

---

# AI Mentor

## Purpose

A contextual financial education tutor, not an autonomous adviser. Full behavioral contract in
`AI_MENTOR.md`.

## Responsibilities

- Explain concepts, answer questions, adapt to the learner's level.
- Clarify lesson content, provide examples, ask practice questions.
- Explain portfolio metrics educationally.

## Business Rules

- Never recommends buying/selling a specific security, predicts prices, or promises returns.
- Never claims to be a licensed financial adviser.
- Receives only the educational context necessary for the task (see `AI_MENTOR.md`), not arbitrary user data.

## Status

Implemented (Phase 1). Backend `POST /api/mentor/chat`, Gemini-backed, grounded in the user's real
portfolio/pet context. See `AI_MENTOR.md` for what shipped and what's deferred.

---

# Authentication

## Purpose

Allow users to securely access the application.

## Responsibilities

User registration, login, logout, session validation, JWT authentication.

## Business Rules

Email must be unique; passwords securely hashed; protected resources require authentication.

## Status

Implemented.

---

# User Profile

## Purpose

Represent the learner's identity and progress summary.

## Responsibilities

Avatar, username, XP/level, learning statistics, progress overview.

## Status

Implemented.

---

# Market Data

## Purpose

Provide the asset data backing the Portfolio and Academy's practical challenges.

## Business Rules

- Market data must be sourced from the external provider (Brapi), never fabricated (`MARKET_EVENTS_ENGINE.md`
  "the number never lies" principle).
- Users cannot modify market information.

## Status

Implemented — quote, search, history, dividends via Brapi adapter.

---

# Notifications

## Purpose

Keep users informed of learning-relevant events without excessive noise.

## Business Rules

Notifications should provide value; avoid excessive frequency; respect quiet hours.

## Status

Planned — design intent in `MARKET_EVENTS_ENGINE.md` §10.

---

# Settings

## Purpose

Allow users to personalize theme, notification preferences, and account settings.

## Status

Implemented (theme, account); notification preference toggles exist in UI but are not yet backed by a
notification system.

---

# Deprecated / reconsidered concepts

The following concepts existed in the previous product direction's `FEATURES.md` and are **no longer part of
the V2 roadmap** as previously framed. They are recorded here, not silently deleted, per this documentation
pass's "do not delete information, reclassify it" rule.

- **Ranking / leaderboards.** Previously "Priority: Medium." Under the learning-first direction, competitive
  ranking is not a validated retention driver and is not part of Alpha or Beta. May be reconsidered in V1 as
  a social feature, gated on user demand (`ROADMAP.md`).
- **Buy/Sell execution ("Buy Assets"/"Sell Assets" features).** Previously "Planned." The product does not
  execute financial orders (`PRODUCT_VISION.md` §11) — this was never implemented and is retired from the
  roadmap rather than deferred.
- **Wealth/profit-driven XP.** Previously implicit in the "Experience System" description ("Investing" listed
  as an XP source). Explicitly disallowed under the new XP System rules above; the current implementation
  still does this and is tracked as a required fix (see XP System status).
- **Avatar/Inventory as separate features.** Folded into the Pet System — cosmetic unlocks are pet-scoped
  rather than a generic avatar/inventory system, matching the pet-centric motivation layer.

---

# Guiding principle

Every feature should contribute to at least one of: learning, practice, progression, or motivation — without
encouraging unhealthy financial behavior. If a feature does not, reconsider whether it belongs in the product.
See `PRODUCT_VISION.md` §12.
