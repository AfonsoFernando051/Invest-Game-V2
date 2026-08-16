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

- Learning path → module → lesson → step progression, reachable from Home.
- Interactive lesson steps: explanation, example, micro-exercise, applied scenario, summary.
- Quizzes with immediate, encouraging feedback.
- Lesson/module completion tracking.
- XP awarded on completion.

## Business Rules

- Content teaches users to *investigate* concepts (e.g. P/E, diversification), never to imply a buy/sell
  signal ("low P/E = good investment" is prohibited framing).
- No punitive mechanics. A wrong quiz answer shows the correct explanation and lets the user continue — no
  lost lives, no reset progress, no lesson failure state.
- Knowledge progress (curriculum completion) is tracked separately from XP/game level — see
  `PRODUCT_VISION.md` §9. Completing the curriculum is never conflated with "being an advanced investor."

## Status

**Current:** Phase 0 slice implemented, client-only. One fully authored learning path/module ("Fundamentos do
Investidor," 6 lessons), remaining curriculum shown as "coming soon." Progress persisted locally
(`SharedPreferences`), not backend-authoritative.

**Target:** full knowledge roadmap (see `ACADEMY_ENGINE.md`'s Level 1–6 curriculum), backend-authoritative
progress, practical challenges connected to real held assets.

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

**Current — contradicts the target principle above.** `PetProfile.xp` (Flutter,
`features/pet/data/models/`) is a single mutable field, stored locally via `SharedPreferences`, with no
backend representation at all (no `xp` column exists anywhere in the Spring Boot domain/entities). Worse,
`mission_catalog.dart` and `achievement_catalog.dart` (both under `features/portfolio/domain/services/`)
directly award XP for **portfolio value thresholds** (e.g. mission `portfolio_10k`/`portfolio_50k`: 150/400
XP) and **profit** (achievement `positive_return`: 100 XP for `summary.totalGain > 0`). This is the single
most important gap between the current implementation and the V2 product principle and should be the first
gamification item addressed once the codebase evolves past this documentation pass — see `DECISIONS.md`.

**Target:** backend-authoritative `XPEvent` log; catalog entries re-scoped so only learning/practice/mission
actions grant XP; wealth- and profit-based rewards removed or reframed as non-XP acknowledgements (e.g. a
timeline note, not a reward).

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

---

# Missions

## Purpose

Guide users through educational objectives via short-term goals. Full design intent in
`MARKET_EVENTS_ENGINE.md` §11.

## Responsibilities

- Daily missions: small educational actions (complete a lesson, answer a quiz, review a concept).
- Weekly missions: larger educational actions (complete a module, complete a practical challenge).
- Progress tracking and reward claim.

## Business Rules

- Missions should reinforce learning and analysis, not encourage excessive trading activity or portfolio
  growth for its own sake.
- Rewards follow the XP System's rules above — no wealth-based mission rewards going forward.

## Status

**Current:** `mission_catalog.dart` is a local, static catalog evaluated client-side against portfolio state.
As noted under XP System, several current missions reward portfolio-value milestones directly — a target-vs-
current contradiction, not a design intent.

**Target:** server-side mission templates (`missions`/`user_missions` tables per `MARKET_EVENTS_ENGINE.md`
§6), instances re-scoped toward learning/practice actions.

---

# Achievements

## Purpose

Reward important learning and engagement milestones.

## Business Rules

- Achievements are permanent once unlocked.
- Achievement XP follows the XP System's learning-first rule going forward.

## Status

**Current:** `achievement_catalog.dart`, local static catalog with local unlock persistence
(`achievements_local_repository.dart`). Includes at least one profit-based achievement (`positive_return`) —
see XP System gap above.

**Target:** unlock state migrates server-side first (`MARKET_EVENTS_ENGINE.md` §6 calls this "the single
highest-value, lowest-risk first migration"); catalog definitions can remain client-side static data.

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
target "no execution" principle; the old MVP-era "Buy Assets"/"Sell Assets" features below were aspirational
and are being retired from the roadmap, not implemented.

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
(`ACADEMY_ENGINE.md` §4) — this is the highest-priority MVP V2 gap. See `ROADMAP.md`.

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
  ranking is not a validated retention driver and is not part of MVP V2 or Beta. May be reconsidered in V1 as
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
