# ACADEMY_ENGINE.md

# Academy — Financial Education Engine

## Status

Phase 0 slice implemented (client-only), then expanded with a **School layer, Knowledge Progress track, and a
new "Financial Life" school** by explicit user direction — see `DECISIONS.md` DECISION-018 for why this is a
deliberate departure from the Phase-0-only scope this document originally settled on. Sections marked
**Phase 3+** below are still design intent, not yet built. In `ROADMAP.md`'s staging: Phase 0 ≈ **Alpha**,
Phase 3+ ≈ **Beta or later**.

The Academy is the primary product engine under the V2 direction — see `PRODUCT_VISION.md` §4 ("Learning is
primary"). Where this document refers to "the brief," that was the original feature request that shaped this
design; `PRODUCT_VISION.md` is now the authoritative product spec this document must stay consistent with. A
second, larger brief (requesting a full 19-school academy with competency tracking and prerequisites) is
referred to below as "the 2026 brief" — see DECISION-018 for the full context.

---

## Reconciling Ambition With the Roadmap

The brief that motivated this document asked for a production-grade learning platform: a full REST API under
`/api/v1/education/*`, Flyway-backed lesson/progress tables, a CMS-ready content pipeline, offline-first sync, a
lives/hearts mechanic, and eight fully populated curriculum modules. Three existing documents constrain that brief,
the same way they already constrained `MARKET_EVENTS_ENGINE.md`:

- **ROADMAP.md** and **FEATURES.md** list "Interactive tutorials" and "Investment quizzes" under *Future Features*,
  explicitly excluded from the Alpha stage. "Learning Content" itself is `Status: Planned`, not a
  Alpha-priority feature.
- **AI_RULES.md** says new systems must not delay delivery of the current roadmap stage and to "avoid
  introducing large new systems."
- **PROJECT_CONTEXT.md** states the game must never punish the user — the Pet "will never die, degrade, or severely
  penalize" the user for a bad outcome. A hearts-lose-on-wrong-answer mechanic, taken literally, violates this.

So — same move as `MARKET_EVENTS_ENGINE.md`: this document sketches the full north-star shape, but only the **Phase
0** slice is implemented now. Everything else is explicitly deferred, not abandoned.

### What already exists that this reuses

| Concern | Already exists at |
|---|---|
| Local, permanent-unlock progress persisted client-side | [`achievements_local_repository.dart`](../petapp_mobile/lib/features/portfolio/data/repositories/achievements_local_repository.dart) |
| Fixed catalog-of-defs pattern (content as static data, not hardcoded widgets) | [`achievement_catalog.dart`](../petapp_mobile/lib/features/portfolio/domain/services/achievement_catalog.dart), [`mission_catalog.dart`](../petapp_mobile/lib/features/portfolio/domain/services/mission_catalog.dart) |
| XP → Level derivation | [`level_calculator.dart`](../petapp_mobile/lib/features/game/domain/services/level_calculator.dart) |
| Reward celebration UI moment | [`achievement_celebration_overlay.dart`](../petapp_mobile/lib/features/portfolio/presentation/widgets/achievement_celebration_overlay.dart) |
| Pet reaction on a game-progression moment | `MascotController.triggerEventAnimation` |
| Cross-controller reaction without tight coupling | `AppEventBus` |
| Closest existing "lesson content" shape | [`indicator_education_catalog.dart`](../petapp_mobile/lib/features/asset_details/domain/services/indicator_education_catalog.dart) |
| The literal entry point the brief describes | the "Treinar" button, `action_buttons.dart` (previously a stub snackbar) |

Nothing above is replaced. The Academy feature is new files under `features/academy/`, following the same
`data → domain → presentation` shape every other feature uses.

---

## 1. Vision (north star, not all built today)

Turn the app's existing "Train" stub into a real, short-lesson, gamified financial-education flow: `Home → Academy →
Module → Lesson → Micro-exercises → Result → XP/Progress → Next lesson`. Content teaches the user to *investigate*
concepts (P/L, risk, diversification, …) rather than memorize definitions or receive buy/sell advice — see
`docs/PROJECT_CONTEXT.md`'s "never misleading" principle and `docs/PRODUCT_VISION.md`'s safety boundary (§11).

### Knowledge progression roadmap

This is the target curriculum shape. Content may evolve, but the progressive philosophy — each level builds on
the last — should remain, and it must stay distinct from game level (`PRODUCT_VISION.md` §9: knowledge
progress ≠ XP-driven game level).

| Level | Theme | Example concepts |
|---|---|---|
| 1 | Foundations | Saving vs. investing, inflation, purchasing power, risk, liquidity, return, simple/compound interest, financial goals |
| 2 | Fixed Income | Interest rates, CDI, Selic, IPCA, government bonds, CDB, LCI/LCA, fixed vs. floating rates, mark-to-market |
| 3 | Variable Income | Stocks, dividends, volatility, FIIs, ETFs, market basics |
| 4 | Fundamental Analysis | Revenue, profit, margins, debt, ROE, ROIC, P/E, P/B, dividend yield, cash flow |
| 5 | Portfolio Construction | Diversification, allocation, correlation, rebalancing, risk management, horizon |
| 6 | Advanced | Valuation, DCF, macroeconomics, scenarios, company analysis, advanced strategy |

**Current:** Level 1 (Foundations) exists as the single authored module, "Fundamentos do Investidor." Levels
2–6 exist only as `contentAvailable: false` placeholder catalog entries. See `ROADMAP.md`'s Beta stage for
when Levels 2–4 are targeted.

## 2. Phase 0 (implemented now)

- One fully authored module — **"Fundamentos do Investidor"** (Investor Foundations) — 6 real lessons, 5 interactive
  steps each (~120 total XP for the module).
- Remaining six modules from the brief exist as catalog entries with `contentAvailable: false`, rendered as
  "Em breve" (coming soon) cards — so the progression system's *shape* is visible without writing content that would
  just be a wall of unvalidated text (`FEATURES.md`'s "build the smallest useful version first").
- **No lives/hearts.** A wrong answer shows the correct explanation, encouragingly, and lets the user continue —
  matching both `PROJECT_CONTEXT.md`'s no-punishment rule and the brief's own §9 ("don't make users afraid to
  invest"). A future "streak of correct answers this lesson" stat is a candidate replacement if positive
  reinforcement is wanted later — additive, never subtractive.
- **No lives means no lesson-restart/fail state either** — a lesson always ends in completion; the point is
  understanding, not gatekeeping.
- **No streak system.** A genuine daily-open streak doesn't exist anywhere in the app yet (confirmed — the
  "Sequência" stat on `RpgIntegrationCard` is actually "days since first investment," not a login streak).
  `MARKET_EVENTS_ENGINE.md` already designs the real target shape (`user_streak` table, `STREAK_MAINTAINED` event) as
  a Phase 3+ item; Academy should plug into that system once it exists rather than build a second, competing streak
  tracker.
- **No backend.** Progress is local-only (`SharedPreferences`), following the exact pattern
  `AchievementsLocalRepository` already established — consistent with the fact that XP/achievements/missions
  themselves are still 100% local today; Academy is not a weaker citizen than the systems it integrates with.
- **No practical market challenges, no paper trading.** Both are real, good ideas (brief §7, §16) but need either
  live market data wiring or a simulated-portfolio feature that doesn't exist yet. The domain model below leaves
  room for a `PracticalChallenge` concept without building it.

## 3. Domain Model (implemented)

```
AcademyModule
  id, title, description, icon, order, lessonIds, contentAvailable

Lesson
  id, moduleId, title, order, xpReward, steps: List<LessonStep>

LessonStep (sealed)
  ExplanationStep      { title, body }
  ExampleStep          { title, body }
  ChoiceQuestionStep   { framing (microExercise | apply), prompt, options, correctIndex, explanation }
  SummaryStep          { title, takeaways }
```

`ChoiceQuestionStep` covers multiple-choice, true/false (as a 2-option question) and scenario/apply questions with
one shared shape and one shared widget — the "engine" the brief asked for, sized to what six real lessons actually
need. Matching, ordering, numeric-input and chart-identification question types from the brief are real future step
types; adding one is a new `LessonStep` subclass + one new step-view widget, nothing else changes (`LessonSession`
already switches on step type generically).

Progress is derived, not stored as a separate aggregate: `AcademyProgressCalculator` computes lesson/module status
(`locked | available | completed`, `comingSoon | inProgress | completed`) from `AcademyCatalog` (static) crossed with
`Set<String> completedLessonIds` (persisted). This mirrors `MissionCatalog.evaluate()` — a pure function over a fixed
catalog and live state, not a stored derived value that can drift.

## 3b. School Layer, Knowledge Progress & "Financial Life" (implemented — DECISION-018)

Added on top of the Phase 0 domain model above, additively — no existing module/lesson id, XP value, or
content changed.

```
School
  id, title, description, icon, order, prerequisites, contentAvailable

AcademyModule (+2 fields)
  ...(unchanged)..., schoolId, prerequisites
```

- **19 schools**, matching the 2026 brief's full curriculum naming, in `AcademyCatalog.schools`. Two are real
  today: School 1 "Financial Life" (new — see below) and School 3 "Investment Fundamentals" (the pre-existing
  `investor_foundations` module, reparented under a school but otherwise byte-identical). The other 17 —
  including 6 that reuse the module ids that already existed as placeholders (`fixed_income`, `stocks`, etc.,
  each reparented to its matching school) — are `contentAvailable: false` journey nodes with no lessons, same
  "visible without shipping unwritten content" philosophy as Phase 0's module list.
- **School 1 "Financial Life" → Module 1 "Money Fundamentals"**: 10 lessons (What Is Money?, Income and
  Expenses, Needs vs. Wants, Organizing Your Money, What Is a Budget?, Building Your First Budget, Conscious
  Consumption, Financial Goals, Emergency Funds, Review), same 5-step pattern and no-punishment rules as Phase
  0's content, in `services/catalog/financial_life_catalog.dart` — new schools' content lives in its own file
  under `catalog/` rather than growing `academy_catalog.dart` further as the curriculum scales.
- **Competency/mastery** (2026 brief's term) is modeled as **per-school completion percent**
  (`KnowledgeProgressCalculator.percentForSchool`) rather than a second taxonomy — a school already is a
  competency grouping.
- **Knowledge Progress** (`KnowledgeLevel`, 10 named tiers, `KnowledgeProgressCalculator`) finally implements
  `PRODUCT_VISION.md` §9's Knowledge Progress vs. Game Level split, which was documented but never built before
  this. Derived from curriculum completion across `contentAvailable` content only — never from XP — and
  rendered as a visually separate row from Game Level on the Academy home header, never merged into one number.
- **Prerequisites** (`AcademyModule.prerequisites`/`School.prerequisites`, both lists of ids) extend
  `AcademyProgressCalculator` with a `locked` status, checked before a module/school with real content is ever
  offered as available. Additive-only by construction: nothing shipped with prerequisites today, so no
  previously-reachable content regresses to locked.
- **Pet**: two new event-triggered messages, `PetMessageCatalog.difficultyDetected` (fires once a
  learner hits `kDifficultyDetectionThreshold` recent wrong answers in one school — tracked by
  `AcademyProgressLocalRepository.recordMiss`/`resetMisses`, a lightweight per-school counter, not a mistake
  history) and `.schoolMastered` (fires when a lesson completion brings every currently-available module of its
  school to 100%). Both follow the existing `AppEvent`/`AppEventBus` pattern — no new coupling between the pet
  and Academy features.
- **No backend changes.** School/module ids and prerequisites are a client-side content-organization layer
  only; `LearningController` still only ever sees individual lesson-completion calls.

## 3c. Domain ("Escola") Layer (implemented — DECISION-019)

Added on top of the School layer above, additively — no `School`/`AcademyModule`/`Lesson` id, content, or
progress logic changed.

```
AcademyDomain
  id, title, description, icon, order, schoolIds
```

- **8 domains** (`AcademyDomainCatalog.domains`), grouping the 19 existing schools into the 2026 brief's broader
  areas: Educação Financeira, Investimentos, Análise e Valuation, Carteira e Patrimônio, Macroeconomia e
  Mercados, Tributação e Regulação, Mercados Avançados, Simulações e Prática. Every school belongs to exactly
  one domain (`academy_domain_catalog_test.dart` enforces this) — a pure regrouping of the existing School list,
  not a new content tier.
- **Status/mastery are always derived**, never stored: `AcademyProgressCalculator.domainStatus` aggregates its
  member schools' `SchoolStatus` (reusing the enum as-is — a domain's possible states are identical to a
  school's, so no new enum was introduced) and `KnowledgeProgressCalculator.percentForDomain` sums lesson
  completion across them, mirroring `schoolStatus`/`percentForSchool`'s own aggregation shape one level down.
- **UX**: `AcademyHomeScreen`'s "all 19 schools" list is replaced by 8 `AcademyDomainCard`s pushing
  `AcademyDomainDetailScreen`, which lists that domain's schools via the **existing, unmodified** `SchoolCard` →
  `SchoolDetailScreen` → `ModuleDetailScreen` → `LessonScreen` flow. Nothing below the Domain layer changed.
- **No backend changes** — same rationale as §3b: domains are a client-side navigation grouping only.
- **Out of scope this pass**: new placeholder modules for subjects not yet authored (Orçamento, Crédito e
  Dívidas, Planejamento Financeiro, ...), search/filter UI, and per-domain pet nudges — see DECISION-019's
  Rationale for why.

## 3d. Mastery, Recommendations, Review & Financial Lab (implemented — DECISION-020)

Added on top of the Domain layer above, additively — no `School`/`AcademyModule`/`Lesson` id, content, or
existing progress logic changed.

```
MasteryTier
  exploring | understanding | applying | mastering

AcademyRecommendation
  type (continueLearning | review), lesson, reasonKey, reasonParams
```

- **Real Mastery, distinct from Progress.** `AcademyController.masteryFor` (per-school completion percent) was,
  since DECISION-018, the only signal labeled "mastery" in the product — a school could read "100% mastered"
  purely from finishing every lesson, regardless of how many questions were missed along the way.
  `AcademyProgressLocalRepository.markLessonPerfect`/`loadPerfectLessonIds` now tracks, per lesson, whether
  every question was answered correctly on the first try (monotonic: a later perfect replay can improve
  Mastery, a later missed replay never regresses it). `MasteryCalculator.percentForSchool` scores each lesson
  `0.0` (not completed) / `0.55` (completed, missed something) / `1.0` (completed perfectly) and averages over
  the school's `contentAvailable` lessons — same aggregation shape as `KnowledgeProgressCalculator`, so Progress
  and Mastery are always computed over the same lesson set and stay directly comparable.
  `AcademyController.realMasteryFor`/`masteryTierFor` expose it; `MasteryBarRow`, `AcademyMasterySection`, and
  `SchoolDetailScreen` now show Progress and Mastery as two distinct rows, never merged into one number.
- **Recommendations.** `AcademyRecommendationService.recommendationsFor` returns up to two reason-annotated
  suggestions: the existing `nextLessonToContinue` (continuing) and, when a completed lesson wasn't answered
  perfectly, the oldest such lesson (review). Surfaced via `RecommendedForYouSection` — on `HomeScreen`,
  filtered to the `review` type only, since `ContinueLearningCard` already covers `continueLearning` there (the
  brief's own "one primary action per screen" principle).
- **Review.** `AcademyRecommendationService.reviewQueue` is every completed-but-not-perfect lesson in
  curriculum order; `AcademyReviewCard` ("Today's Review — N lessons, ~M min") on `AcademyHomeScreen` starts
  the oldest one via the existing `LessonScreen` — no new multi-lesson session type. Review lessons grant **no
  additional XP**: `LessonSessionController`'s existing rule ("the backend is the only source of truth for XP")
  would be violated by fabricating a client-side "+10 XP." `FEATURES.md`'s target "Revision activity +10" XP
  stays a documented backend follow-up. `reviewEstimatedMinutes` is a documented approximation (steps × ~40s),
  not a measured per-lesson duration — no such field exists yet.
- **Companion.** `PetMessageCatalog._academyNudge` prefers a review-due nudge over the plain continue nudge
  when `AcademyController.reviewQueue` is non-empty (`AcademyHomeScreen._notifyCompanionOnce` passes
  `reviewDueCount` through the existing `PetCompanionController.enterContext` call). No new `PetAnimationState`,
  no Rive work — reuses `PetAnimationState.think`.
- **Financial Lab.** `CompoundInterestCalculator` (pure, stateless) + `FinancialLabHomeScreen`/
  `CompoundInterestLabScreen` under `features/academy/presentation/screens/financial_lab/` — sliders drive a
  live `fl_chart` stacked-bar visualization (contributions vs. growth per year) and a dynamic explanatory
  sentence comparing the current result against the previous input state, satisfying the "always explain why
  the result changed" principle rather than being a bare calculator. Only Compound Interest is real; Inflation,
  Fixed Income, Diversification, and Portfolio labs are shown as `contentAvailable: false`-style placeholders,
  the exact pattern already proven for unauthored Schools. No persistence, no XP, no backend — a sandbox for
  building intuition, not a graded activity.
- **No backend changes** — same rationale as §3b/§3c: Mastery/Recommendations/Review are a client-side
  progress-interpretation layer over the existing `completedLessonIds` contract; the Financial Lab has no
  server dependency at all.
- **Out of scope this pass** (see DECISION-020): new curriculum content, a prerequisite hard-lock→soft-guidance
  UX change, new exercise types, and every other Financial Lab beyond Compound Interest.

## 4. Gamification Integration

Lesson completion persists the lesson id via `AcademyProgressLocalRepository` (identical shape to
`AchievementsLocalRepository`: a `SharedPreferences` string list, entries only ever added). Total game XP was
previously `AchievementCatalog.totalXpFor(unlockedAchievementIds)` alone; it is now
`TotalXpCalculator.compute()` = achievement XP + academy XP, in one place
(`lib/core/services/total_xp_calculator.dart`), used by both `PortfolioController._evaluateGamification()` (so a
portfolio refresh never clobbers XP earned from lessons) and `LessonSessionController` (so completing a lesson is
reflected immediately without waiting for the next portfolio load). This is the one deliberate cross-feature touch
point — Academy does not depend on `PortfolioController` or any financial aggregate, only on the same
`AchievementsLocalRepository` read `PortfolioController` already uses, so the education bounded context stays
decoupled from Portfolio/Transactions/Assets per the brief's own §17.

On lesson completion: `MascotController.evaluateEvolution(currentNetWorth, newTotalXp)` runs (same call
`PortfolioController` already makes), so a lesson can trigger a level-up or pet evolution exactly like an achievement
does, and `MascotController.triggerEventAnimation(PetAnimationState.victory)` plays the same pet reaction. No new
animation states, no new event bus events were needed — `UserLeveledUpEvent`/`PetEvolvedEvent` already fire generically
from `evaluateEvolution` regardless of caller.

## 5. UX Flow (implemented)

```
Home → "Treinar" button → AcademyHomeScreen
  → shows current level, next-lesson CTA, module list (in-progress / completed / coming soon)
  → ModuleDetailScreen (lesson list with locked/available/completed state + progress bar)
    → LessonScreen (step player: progress bar, one step at a time, Continue button)
      → on last step: inline completion state (glass card, +XP, "Continuar" / "Voltar à Academia")
```

Reused verbatim: `CosmicBackground`, `GlassCard`, `GameButton`, the `AchievementCelebrationOverlay` visual language
(sparkle burst, gold glow, `+N XP` pill) for the lesson-complete moment, `PortfolioProgressBar`'s progress-bar visual
style for module/lesson progress, and the existing `_fadeRoute` push transition used everywhere else in the app.

## 6. Folder Structure (implemented)

```
petapp_mobile/lib/features/academy/
  domain/
    entities/academy_module.dart
    entities/lesson.dart
    entities/lesson_step.dart
    entities/school.dart                          # School layer
    entities/academy_domain.dart                  # Domain layer
    entities/knowledge_level.dart                  # Knowledge Progress
    entities/mastery_tier.dart                      # Mastery
    entities/academy_recommendation.dart            # Recommendations/Review
    services/academy_catalog.dart
    services/academy_domain_catalog.dart           # Domain layer
    services/academy_progress_calculator.dart
    services/knowledge_progress_calculator.dart    # Knowledge Progress
    services/mastery_calculator.dart                # Mastery
    services/academy_recommendation_service.dart    # Recommendations/Review
    services/compound_interest_calculator.dart      # Financial Lab
    services/catalog/financial_life_catalog.dart   # School 1 content
  data/
    repositories/academy_progress_local_repository.dart
  presentation/
    controllers/academy_controller.dart
    controllers/lesson_session_controller.dart
    screens/academy_home_screen.dart
    screens/academy_domain_detail_screen.dart      # Domain layer
    screens/school_detail_screen.dart              # School layer
    screens/module_detail_screen.dart
    screens/lesson_screen.dart
    screens/financial_lab/financial_lab_home_screen.dart      # Financial Lab
    screens/financial_lab/compound_interest_lab_screen.dart   # Financial Lab
    widgets/academy_domain_card.dart               # Domain layer
    widgets/school_card.dart                       # School layer
    widgets/mastery_bar_row.dart                   # School/Mastery layer
    widgets/mastery_tier_presentation.dart          # Mastery
    widgets/recommended_for_you_section.dart        # Recommendations
    widgets/academy_review_card.dart                # Review
    widgets/financial_lab_entry_card.dart           # Financial Lab
    widgets/module_card.dart
    widgets/lesson_list_tile.dart
    widgets/academy_progress_bar.dart
    widgets/steps/explanation_step_view.dart
    widgets/steps/example_step_view.dart
    widgets/steps/choice_question_step_view.dart
    widgets/steps/summary_step_view.dart
    widgets/lesson_complete_card.dart

petapp_mobile/lib/core/services/total_xp_calculator.dart
```

No new top-level pattern; mirrors `features/portfolio/` and `features/mentor/` exactly. The School layer
follows the same `data → domain → presentation` shape, just one level higher than Module.

## 7. Phase 3+ (explicitly deferred — design intent only)

These are not built. Each needs a real trigger (more content, real usage data, or a dependency that doesn't exist
yet) before it's worth building, per `AI_RULES.md`'s "does it solve a real, measured problem" test.

- ~~Backend-authoritative progress~~ — **delivered**, ahead of this document's original sequencing: the
  backend now has a real `LearningController`/`LearningModuleJpaEntity`/`LearningLessonJpaEntity` (Flyway-backed,
  `V4__learning_gamification_schema.sql` + `V9__seed_money_fundamentals_learning_catalog.sql`), and
  `AcademyRemoteDataSource.completeLesson`/`getCompletedLessonIds` sync against it best-effort (§3b/§4). This
  section was not updated when that shipped — flagging the gap here since it was found while writing §3d, not
  something this pass's changes caused. Local-only achievements/missions have **not** made the same migration
  yet, so Academy's XP composition (`TotalXpCalculator`) still reads their local state — see `FEATURES.md`.
- **Remaining 17 schools' real content**, written and reviewed incrementally, one school/module at a time,
  validated against real user engagement with "Financial Life"/"Investment Fundamentals" first.
- **Full Question-entity metadata** (the 2026 brief's ~20 fields: sub-competency, review date, source,
  version, 10 question types beyond multiple-choice) — no real content velocity yet to justify it; the sealed
  `LessonStep` can grow one type at a time when a specific lesson actually needs it.
- **Backend School/prerequisite/competency schema** — School/module organization stays a client-side-only
  concept until learning progress itself migrates to backend-authoritative (see the item above this list).
- **Practical market challenges** (brief §7): a `PracticalChallenge` entity referencing a real ticker/ratio, reward
  wired through the same `TotalXpCalculator`, gated on the asset-details screen already having the indicator data
  (`IndicatorEducationCatalog`) — the natural next integration once Module 4 (Fundamental Analysis) has real content.
  This is the concrete implementation of "Educational Portfolio Intelligence" (`FEATURES.md`), the product's core
  differentiator per `PRODUCT_VISION.md` §10 — currently the single highest-priority Alpha-stage gap (`ROADMAP.md`).
- **Paper trading step type**: a `SimulationStep` LessonStep subclass, gated on a simulated-allocation feature that
  doesn't exist yet.
- **Streak**: plug into `MARKET_EVENTS_ENGINE.md`'s `STREAK_MAINTAINED`/`user_streak` design once that ships, rather
  than building a second streak tracker.
- **CMS / content pipeline**: only worth it once content velocity (multiple modules, frequent edits) makes hardcoded
  Dart catalogs the actual bottleneck — not before, per YAGNI.
- **Offline-first outbox sync**: only meaningful once progress is backend-authoritative; local-only progress has
  nothing to sync yet.

## 8. Edge Cases (Phase 0)

- **Answering the same question twice**: `LessonSessionController` locks in the first answer per step
  (`hasAnswered`) — no re-answering to game the "correct" state, but also no penalty for the wrong first answer.
- **Leaving mid-lesson**: nothing is persisted until the lesson's final step completes — a partially-played lesson
  simply resumes from step 1 next time, no partial-credit bookkeeping to get wrong.
- **Re-opening a completed lesson**: allowed, freely replayable for review; replaying never re-grants XP (`markCompleted`
  is a set-union, identical semantics to achievement unlocking).
- **Module with no content yet**: rendered as "coming soon" unconditionally — never gated behind a fake unlock
  condition that would mislead the user about their own progress.

## Documentation Follow-Ups

Per `AI_RULES.md` ("whenever a significant architectural decision is made, suggest updating DECISIONS.md,
FEATURES.md, ROADMAP.md"):

- `FEATURES.md`: "Learning Content" status updated to reference this document.
- `DECISIONS.md`: new entry recording the Phase-0-slice scoping decision and the no-punishment (no lives/hearts)
  decision.
- `ROADMAP.md`: the Alpha stage now references Academy Phase 0 as delivered; remaining phases referenced under Phase 3.
