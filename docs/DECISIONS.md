# DECISIONS.md

# Architectural & Product Decisions

## Purpose

This document records important technical and product decisions made throughout the project's development.

Each decision includes:

- Context
- Decision
- Rationale
- Consequences

The objective is to preserve historical knowledge and avoid repeatedly discussing decisions that have already been made.

---

# DECISION-001

## Title

Flutter as the Mobile Framework

### Status

Accepted

### Context

The project requires a cross-platform mobile application with a modern UI, strong community support, and long-term maintainability.

### Decision

Flutter is the official frontend framework.

### Rationale

Flutter provides:

- Excellent performance
- Native compilation
- Strong UI capabilities
- Cross-platform development
- Large ecosystem
- Long-term maintainability

Changing the frontend framework is not planned.

### Consequences

All mobile development should follow Flutter best practices.

---

# DECISION-002

## Title

Spring Boot as the Backend

### Status

Accepted

### Context

The application requires authentication, business rules, APIs, and database integration.

### Decision

Spring Boot is the official backend framework.

### Rationale

Spring Boot offers:

- Mature ecosystem
- Strong security support
- Excellent REST capabilities
- Scalability
- Maintainability

The current architecture fully satisfies MVP requirements.

### Consequences

Backend development should continue using Spring Boot.

---

# DECISION-003

## Title

Traditional Backend Instead of Serverless

### Status

Accepted

### Context

AWS Lambda and serverless architectures were evaluated.

### Decision

Do not migrate the backend to AWS Lambda during MVP development.

### Rationale

Current requirements do not justify additional complexity.

A traditional backend provides:

- Easier debugging
- Simpler architecture
- Faster development
- Lower maintenance cost

### Future

Lambda may be introduced later for asynchronous workloads only.

Examples:

- Scheduled jobs
- Notifications
- Reports
- Ranking calculations

Core business logic should remain inside Spring Boot.

---

# DECISION-004

## Title

MVP First

### Status

Accepted

### Context

Many projects fail because they spend excessive time redesigning or rebuilding instead of shipping.

### Decision

Complete the MVP before introducing major improvements.

### Rationale

A working product generates feedback.

Feedback generates better decisions.

Unreleased software generates assumptions.

### Consequences

Prioritize completing existing functionality.

Avoid feature creep.

---

# DECISION-005

## Title

Preserve the Current Visual Identity

### Status

Accepted

### Context

The application's visual identity has evolved into a consistent futuristic space theme.

### Decision

Do not redesign the interface unless explicitly requested.

### Rationale

The current design successfully communicates:

- Gamification
- Progress
- Premium quality
- Exploration

Future work should focus on refinement rather than redesign.

### Consequences

Improvements should target:

- Better spacing
- Better hierarchy
- Better animations
- Better accessibility

Not a completely different visual style.

---

# DECISION-006

## Title

Gamification as a Core Product Principle

### Status

Accepted

### Context

The product aims to teach investing through engagement.

### Decision

Gamification is a core system, not an optional feature.

### Rationale

Progression systems increase motivation and long-term retention.

Examples include:

- XP
- Levels
- Missions
- Achievements
- Rewards
- Pet progression

### Consequences

Every major feature should reinforce user progression whenever appropriate.

### Refined by

DECISION-012 narrows this: gamification is a core system, but it is the **motivation layer** supporting
learning, not a pillar equal to it — see `PRODUCT_VISION.md` §4. Rankings/leaderboards, listed as an example
here originally, are now a deprecated concept (`FEATURES.md`).

---

# DECISION-007

## Title

The Application Is Not a Banking App

### Status

Accepted

### Context

Many financial applications follow traditional banking interfaces.

### Decision

The application should not resemble a bank or brokerage.

### Rationale

The application is an educational platform.

The interface should feel approachable, enjoyable, and game-inspired.

### Consequences

Avoid:

- Corporate dashboards
- Banking aesthetics
- Enterprise UI patterns

Favor:

- Exploration
- Progress
- Rewards
- Premium game-inspired design

---

# DECISION-008

## Title

Incremental Refactoring

### Status

Accepted

### Context

Large rewrites frequently introduce regressions and delay delivery.

### Decision

Improve the project incrementally.

### Rationale

Small improvements are:

- Safer
- Easier to review
- Easier to test
- Easier to maintain

### Consequences

Avoid rewriting working modules.

Improve code while implementing new features.

---

# DECISION-009

## Title

Reusable Components

### Status

Accepted

### Context

The UI will continue growing throughout development.

### Decision

Prioritize reusable UI components.

### Rationale

Reusable components improve:

- Consistency
- Development speed
- Maintainability

### Consequences

Before creating a new widget, verify whether an existing component can be reused or extended.

---

# DECISION-010

## Title

Technology Should Support the Product

### Status

Accepted

### Context

New technologies appear continuously.

### Decision

Technology changes should only occur when they solve a real problem.

### Rationale

Changing frameworks or architectures simply because they are newer creates unnecessary maintenance costs.

### Consequences

Avoid replacing stable technologies without measurable benefits.

---

# DECISION-011

## Title

Academy (Financial Education) — Phase 0 Scope, Client-Only, No Punitive Mechanics

### Status

Accepted

### Context

A brief requested a full production Academy: backend REST API + Flyway tables, offline-first sync, CMS-ready
content, eight fully populated curriculum modules, and a Duolingo-style lives/hearts mechanic. This exceeds
DECISION-004 (MVP First) and ROADMAP.md, which lists "Interactive tutorials" and "Investment quizzes" as
post-MVP. Separately, a lives/hearts mechanic conflicts with PROJECT_CONTEXT.md's explicit rule that the game must
never punish the user.

### Decision

Ship a client-only Phase 0 slice: one fully authored module reachable from the existing "Treinar" button, local
XP/progress persistence following the same pattern as `AchievementsLocalRepository`, and no lives/hearts or other
punitive mechanic — wrong answers get encouraging feedback and the user continues. The full north-star design
(backend-authoritative progress, remaining curriculum, practical market challenges, paper trading) is documented in
`ACADEMY_ENGINE.md` as explicit future phases, not built now.

### Rationale

Mirrors the precedent already set by `MARKET_EVENTS_ENGINE.md` for the same tension. A real, working slice that
reuses existing patterns (catalog-of-defs content, local persistence, the achievement celebration UI) delivers value
now without the multi-week, cross-stack lift the full brief implies, and without contradicting the project's own
no-punishment design principle.

### Consequences

Future work extending Academy content or moving progress server-side should follow `ACADEMY_ENGINE.md`'s phasing
rather than re-deriving scope from the original brief.

---

# DECISION-012

## Title

Learning-First Product Direction (V2 Strategy Reset)

### Status

Accepted

### Context

The original product treated learning, portfolio, gamification, and the AI mentor as roughly equal pillars
under a "gamified financial education platform" umbrella. This diluted the value proposition and created an
XP system that rewarded portfolio wealth/profit directly (see DECISION-014).

### Decision

Invest Game V2 is a learning-first investment education platform. Learning is the primary pillar; the
portfolio is a practice environment; gamification is a motivation layer; the Mentor is a support layer. See
`PRODUCT_VISION.md` for the full positioning.

### Rationale

- A clearer value proposition than "gamified investing app."
- A stronger, more defensible retention loop (Learn → Practice → Progress → Grow).
- A safer incentive structure — rewarding learning instead of wealth avoids nudging users toward risk-taking
  for game rewards.

### Consequences

All documentation and future feature work must be evaluated against `PRODUCT_VISION.md`'s core loop and
positioning. Features that only serve the portfolio or gamification layers, without serving learning, need
explicit justification.

---

# DECISION-013

## Title

Portfolio as a Practice Environment, Not the Core Mechanic

### Status

Accepted

### Context

Previous documentation (`FEATURES.md`) implied buy/sell execution was a planned MVP feature and treated
portfolio performance as a primary product signal.

### Decision

The portfolio exists to connect learned concepts to real, tracked assets. It does not execute financial
orders. Buy/Sell execution features are retired from the roadmap rather than deferred.

### Rationale

Connects theory to application without taking on the regulatory and safety surface of an execution platform,
consistent with the product's explicit non-goal of being a broker (`PRODUCT_VISION.md` §11).

### Consequences

`FEATURES.md`'s "Buy Assets"/"Sell Assets" entries are reclassified as deprecated concepts, not planned work.

---

# DECISION-014

## Title

XP Rewards Learning Behavior, Never Wealth or Profit

### Status

Accepted

### Context

The current implementation (`mission_catalog.dart`, `achievement_catalog.dart`) awards XP directly for
portfolio value thresholds and positive returns. This predates the V2 strategy reset and directly contradicts
it.

### Decision

XP is awarded for learning and practice actions (lesson/quiz/module/mission completion) — never for wealth,
amount invested, portfolio size, profit, or risk-taking. XP should ultimately be derived from an auditable
`XPEvent` log rather than a single mutable field.

### Rationale

Prevents the product from incentivizing unhealthy financial behavior (chasing XP by taking on more risk or
depositing more money) and keeps the reward system honest and auditable.

### Consequences

The current wealth/profit-tied catalog entries are a known, tracked gap (see `FEATURES.md`'s XP System
status) to be corrected in a future implementation pass — not fixed by this documentation update, which is
docs-only.

---

# DECISION-015

## Title

Pet Represents Learning Progress, Not Financial Risk Profile

### Status

Accepted

### Context

The backend independently computes an `InvestorProfile` risk classification (Guardian/Tactician/Adventurer)
from an onboarding questionnaire. There is currently no code linkage between this and pet species, and the
onboarding pet-config flow already deliberately asks a goal/horizon question rather than a risk-tolerance
question.

### Decision

Keep pet species/identity fully decoupled from financial risk profile. The pet is an emotional representation
of learning progress and personal identity, not a financial instrument or a risk indicator.

### Rationale

Emotional reward without distorting financial behavior or implying the app is giving risk-based financial
advice through pet choice.

### Consequences

Any future feature proposing to link pet species/behavior to `InvestorProfile` needs an explicit, reviewed
product decision — it is not a natural extension of existing code.

---

# DECISION-016

## Title

Documentation Distinguishes Current Implementation from Target Architecture

### Status

Accepted

### Context

Prior documentation described target/aspirational architecture and shipped reality in the same voice,
frequently blurring the two (e.g. `FEATURES.md` statuses like "Planned" next to features that were partially
built differently than described).

### Decision

Technical documentation explicitly labels **Current** (what exists in the codebase today) versus **Target**
(what the V2 architecture is intended to become), with a **Gap** called out when they differ materially.

### Rationale

Lets a new developer or AI agent trust the documentation without re-deriving reality from the code every time,
and prevents documentation from silently drifting into aspiration-as-fact.

### Consequences

`FEATURES.md`, `ARCHITECTURE.md`, and `API_GUIDELINES.md` were updated to this format as part of this
documentation pass. Future edits to these files should preserve the distinction.

---

# DECISION-017

## Title

Keep Modular Monolith and PostgreSQL (Reaffirmed)

### Status

Accepted (reaffirms DECISION-002, DECISION-003)

### Context

The V2 strategy reset changes product direction and priorities but does not introduce new scaling or
organizational requirements that would justify a different backend shape.

### Decision

Continue with the Spring Boot modular monolith (hexagonal-leaning `core/application/infrastructure/
presentation` layering) and PostgreSQL + Flyway as the target production stack. No microservices during V2.

### Rationale

- Sufficient for the product's current and near-term complexity.
- Simpler development and deployment.
- PostgreSQL fits the domain's clearly relational shape (users, learning progress, XP events, portfolio,
  transactions) and gives strong consistency guarantees the reward/XP ledger design depends on.

### Consequences

New backend features (learning progress persistence, XP events, mission/achievement server migration) should
be designed as new modules/packages inside the existing monolith, following the structure documented in
`ARCHITECTURE.md`.

---

# DECISION-018

## Title

Academy School Layer, Knowledge Progress Track, and Financial Life Curriculum — a Deliberate Departure from the Phase 0 Scope

### Status

Accepted

### Context

A large product brief requested a full 19-school financial academy (School → Module → Lesson hierarchy,
competency/mastery tracking, cross-topic prerequisites, a 10-tier knowledge level, pet-as-teacher behaviors).
`ACADEMY_ENGINE.md` documents that an earlier, similarly ambitious brief for the same feature was deliberately
reconciled down to a "Phase 0" slice — one authored module, client-only progress, no new backend systems — per
`AI_RULES.md`'s "avoid introducing large new systems" and a validate-one-module-first philosophy. This tension
was surfaced directly to the user, who explicitly chose to proceed with the larger scope rather than the
Phase-0-consistent minimal option.

### Decision

Add a `School` entity above `AcademyModule` (additive — existing module/lesson ids and content are untouched),
a "Knowledge Progress" tier system (`KnowledgeLevel`/`KnowledgeProgressCalculator`) computed from curriculum
completion and kept strictly separate from the existing XP-driven Game Level, and per-school prerequisite
support in `AcademyProgressCalculator`. Fully author one new school — **School 1, "Financial Life" → Module 1,
"Money Fundamentals"** (10 lessons) — as the validation slice, per the brief's own "prioritize architecture
first, validate one path" instruction. The remaining 18 schools (including 6 that already existed as
placeholder modules, now reparented under their matching school) are declared as `contentAvailable: false`
journey nodes with no lessons yet, mirroring the exact "coming soon" pattern already proven for
`investor_foundations`'s sibling modules.

"Competency"/"mastery" from the brief is modeled as per-school completion percent rather than a second,
parallel taxonomy — a school already is a competency grouping, so this avoids maintaining two ontologies in
sync. No backend schema changes: school/module ids remain a purely client-side content-organization layer over
the existing lesson-completion contract (`LearningController`).

### Rationale

- This is the correct home for `PRODUCT_VISION.md` §9's Knowledge Progress vs. Game Level separation, which
  was documented but never actually built — the brief's own "Level System" request is the natural trigger for
  finally building it, rather than inventing an XP-adjacent number.
- Prerequisites are additive-only: no school or module that is reachable today gains a new prerequisite that
  would retroactively lock it. `investor_foundations` (now under School 3, "Investment Fundamentals") keeps
  zero prerequisites.
- Full Question-entity metadata (20 fields, 10 question types), a backend School/Competency schema, and content
  for the other 17 schools remain explicitly out of scope this pass — no real usage data yet justifies them,
  consistent with `AI_RULES.md`'s "does it solve a real, measured problem" test even under this larger scope.

### Consequences

- Future schools/modules should follow the same pattern: add real content behind `contentAvailable: true`,
  wire a `schoolId`, keep prerequisites additive-only.
- `ACADEMY_ENGINE.md`, `FEATURES.md`, and `ROADMAP.md` are updated to reflect the School layer and Financial
  Life as delivered, and to record which brief items (question bank, remaining schools' content, Portfolio/
  Mentor integration, backend-authoritative progress) remain future work.

---

# DECISION-019

## Title

Academy Domain ("Escola") Layer — Grouping the 19 Schools Into 8 Broader Areas

### Status

Accepted

### Context

A large product brief asked for an Academy → School → Module → Lesson hierarchy, replacing the "long vertical
list of subjects" presentation with a browsable library. Investigation found that hierarchy already exists —
DECISION-018 built exactly this shape, and all 19 subjects the new brief listed (Vida Financeira, Renda Fixa,
Ações, Valuation, ...) are already `School` entities in `AcademyCatalog`. The actual gap: today's `School` sits
at the brief's "Módulo/assunto" granularity, and `AcademyHomeScreen` renders all 19 of them as one flat card
list — which *is* the "long list" problem the brief describes. There was no grouping layer above `School` into
the ~6-8 broader areas ("Escolas": Educação Financeira, Investimentos, Análise e Valuation, ...) the brief
describes.

### Decision

Add an `AcademyDomain` entity purely as a navigation grouping one level above `School` (`AcademyDomainCatalog`,
8 domains, static, mirrors `AcademyCatalog`'s pattern). Every existing school id is assigned to exactly one
domain — additive only, zero school/module/lesson ids, content, or progress logic touched. `AcademyHomeScreen`'s
school list is replaced by a domain list (`AcademyDomainCard` → `AcademyDomainDetailScreen`, which lists that
domain's schools using the existing, unmodified `SchoolCard` → `SchoolDetailScreen` flow). Domain status/mastery
(`AcademyProgressCalculator.domainStatus`, `KnowledgeProgressCalculator.percentForDomain`) are always derived
from member schools, never stored, following the same "nothing stored that could drift" discipline as the rest
of the Academy progress model. No backend changes — same "client-side content-organization layer only"
rationale as DECISION-018.

### Rationale

- Mirrors DECISION-018's own precedent: a large brief lands, gets reconciled to an additive slice that validates
  the concept without an in-place rebuild, preserving every existing id.
- Reuses `SchoolStatus` for domain status instead of introducing a parallel enum — the possible states
  (comingSoon/locked/available/inProgress/completed) are identical, so a second enum would just be duplication.
- Out of scope this pass, consistent with "don't invent content without need": new placeholder modules for
  not-yet-authored subjects (Orçamento, Crédito e Dívidas, ...), search/filter UI, and any backend School/Domain
  schema.

### Consequences

- Future schools should be assigned a `domainId`'s worth of membership in `AcademyDomainCatalog` as they're
  added — `academy_domain_catalog_test.dart` fails the build if a school is left unowned or double-owned.
- `ACADEMY_ENGINE.md` is updated (§3c) to reflect the Domain layer as delivered.
- In the same pass, a pre-existing latent bug was found and fixed: the backend's `learning_modules`/
  `learning_lessons` seed data (`V4__learning_gamification_schema.sql`) was never updated for the
  `money_fundamentals` module shipped under DECISION-018, so lesson-completion XP for that module silently
  never reached the server. Fixed via `V9__seed_money_fundamentals_learning_catalog.sql`, unrelated to the
  Domain layer itself but discovered while verifying "XP keeps working" end to end.

---

# DECISION-020

## Title

Academy Mastery, Recommendations, Review & Financial Lab — Extending the School Layer Rather Than Rebuilding It

### Status

Accepted

### Context

A large product brief (near-identical in shape to the one that produced DECISION-018/019) requested a full
adaptive-learning transformation of the Academy: mastery distinct from progress, personalized "what should I
learn next" recommendations, a spaced-repetition-ready review loop, a Financial Lab simulation area, richer
companion/mentor integration, and more. Investigation confirmed most of the structural ask already existed
(School → Module → Lesson hierarchy, Domains, Knowledge Progress, prerequisites, a `ContinueLearningCard`,
a real backend-authoritative learning API) and that "Mastery" was, by DECISION-018's own deliberate choice,
modeled as per-school completion percent rather than a second taxonomy. The user, presented with this finding,
chose to proceed with a substantial extension rather than a minimal increment — same pattern as DECISION-018.

### Decision

Add a genuinely performance-based Mastery signal, kept strictly distinct from Progress/completion:
`AcademyProgressLocalRepository.markLessonPerfect`/`loadPerfectLessonIds` tracks whether a lesson was answered
correctly on the first try (monotonic — mastery can improve on replay, never regress), and `MasteryCalculator`
derives a 4-tier (`Exploring`/`Understanding`/`Applying`/`Mastering`) score from it, mirroring
`KnowledgeProgressCalculator`'s aggregation shape exactly. `AcademyRecommendationService` derives "what should
I do next" (continue, or review a not-yet-perfect lesson) and a review queue, surfaced via a "Today's Review"
card on the Academy home and a "Recommended For You" section on Home (filtered to avoid duplicating the
existing Continue card). A new Financial Lab area (`features/academy/presentation/screens/financial_lab/`)
ships one real simulation — Compound Interest, pure client-side, no persistence, no XP — with the remaining
labs from the brief shown as `contentAvailable: false`-style placeholders, mirroring the exact pattern already
proven for unauthored Schools.

No backend/Java changes, no new curriculum content, no prerequisite hard-lock→soft-guidance change, and no new
exercise types — scoped deliberately to what's verifiable with `flutter analyze`/`flutter test` alone in this
pass. See `ACADEMY_ENGINE.md` §3d for the full design.

### Rationale

- Mirrors DECISION-018/019's own precedent: a large brief lands, gets reconciled to an additive slice that
  closes the highest-value genuine gaps without an in-place rebuild, preserving every existing id and contract.
- Mastery-vs-Progress was the single biggest conceptual gap versus the brief's own product-review checklist —
  worth closing properly rather than leaving "mastery" as a second name for the same completion number.
- Review lessons intentionally grant no client-side XP: `LessonSessionController`'s existing rule ("the backend
  is the only source of truth for XP") would be violated by fabricating a "+10 XP" locally; `FEATURES.md`'s
  target "Revision activity +10" XP stays a documented backend follow-up, not implemented here.

### Consequences

- `AcademyController.masteryFor` keeps its name (call-site compatibility) but is now documented honestly as
  Progress, not Mastery — `realMasteryFor`/`masteryTierFor` are the new, real Mastery accessors.
- `docs/FEATURES.md`'s Learning Content status and `docs/ROADMAP.md` are updated to reflect these as delivered
  ahead of their original Beta/V1 staging, same as DECISION-018 was reflected there.
- Future schools/lessons need no changes to participate in Mastery/Review — both derive from the same
  `completedLessonIds`/`perfectLessonIds` sets every school already uses.

---

# DECISION-021

## Title

Retiring "MVP" as the Product's Default Frame — Production-Grade Standards at Every Stage

### Status

Accepted

### Context

Since DECISION-004 ("MVP First"), the project's documentation and AI-assistant instructions have used "MVP" as
the default frame for scoping decisions — appropriate for validating the initial product direction, but
increasingly used, in practice, to justify shortcuts ("it's okay, this is just an MVP") beyond what DECISION-004
ever intended. The user explicitly directed a project-wide mindset change: stop treating Invest Game V2 as an
MVP/prototype/proof-of-concept, and instead treat it as a long-term, production-grade financial education and
investment platform under continuous development, while preserving all valid existing architectural decisions
(XP server authority, offline sync, no-punishment learning, existing domain boundaries, etc.) and without
retroactively rewriting the historical record.

### Decision

This does **not** revise DECISION-004, DECISION-002, or DECISION-003 — they remain accurate historical records
of what was decided, and why, at that point in the project's life. Instead, this decision **supersedes DECISION-004's
framing going forward**: `docs/AI_RULES.md` and `docs/AGENTS.md` are updated to make "production-quality
version of this feature" the default evaluating question (replacing "minimum version that demonstrates the
idea"), and a `docs/AI_RULES.md` Technical Debt Policy is added so a genuinely necessary shortcut is documented
explicitly (Why / Impact / Current workaround / Desired future state / Priority) instead of silently
accumulating as unlabeled "MVP-era" code. `docs/ROADMAP.md`'s "MVP V2" stage is renamed to "Alpha" — the
same stage, same scope and completion criteria, without the framing that implicitly invited corner-cutting.
Every other doc's "MVP V2"/"MVP-era" reference to *this product's own* current or recent state is updated to
match; references to the historical `Pet-Invest-App` MVP (the prior, superseded product this repository is
derived from) are left untouched, since those describe a different, real, historical artifact.

### Rationale

- "Production-grade" is explicitly not "overengineered": `AI_RULES.md`'s existing KISS/DRY/YAGNI, "Preserve
  the Architecture," and "Avoid" sections are kept in full — this decision changes the *quality bar* applied
  to in-scope work, not the *scope* of what's built at once.
- A named Technical Debt Policy gives future work (human or AI) a legitimate way to ship a necessary temporary
  boundary without it silently calcifying into permanent, unlabeled architecture — closing the gap the old
  "MVP First" framing left open.
- Renaming the roadmap stage rather than restructuring it preserves every existing cross-reference's meaning
  (`ACADEMY_ENGINE.md`/`MARKET_EVENTS_ENGINE.md`'s "Phase 0 ≈ [stage]" mapping, `FEATURES.md`'s status lines) —
  a rename, not a re-plan.

### Consequences

- `docs/AI_RULES.md`, `docs/AGENTS.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/PRODUCT_VISION.md`,
  `docs/FEATURES.md`, `docs/AI_MENTOR.md`, `docs/PROJECT_CONTEXT.md`, and `README.md` are updated in the same
  pass as this decision.
- Any future doc or code comment that frames a *current* shortcut as acceptable "because it's an MVP" should be
  treated as stale — point back to this decision and `AI_RULES.md`'s Technical Debt Policy instead.
- DECISION-002/003/004's historical text is intentionally left unedited — read them as "what was true and
  decided then," not as current guidance.

---

# DECISION-022

## Title

Academy Curriculum Content Moves From Hardcoded Dart to Backend-Authoritative (Postgres + JSON Authoring)

### Status

Accepted

### Context

The Academy's entire curriculum (domains, schools, modules, lessons, steps, pt/en/es text) lived as hardcoded
Dart `const` data (`AcademyCatalog`/`AcademyDomainCatalog`/`FinancialLifeCatalog`), while the backend only held
a shallow id+XP validation catalog (`learning_modules`/`learning_lessons`, seeded via hand-written Flyway
`INSERT`s in `V4`/`V9`) — a design `ACADEMY_ENGINE.md` §7 explicitly deferred moving off of, pending real
content velocity ("not before, per YAGNI"). The project owner directly requested centralizing content in the
backend/database: the backend already existed and was underused, and a large increase in authored content
("muito mais conteúdo") was planned — exactly the trigger §7's YAGNI condition named. The dual-catalog design
had already caused one real bug (a module shipped in the Dart catalog before its server-side seed existed,
returning "Unknown lesson id" for every completion attempt, fixed in `V9`).

### Decision

Domains/schools/modules/lessons/steps (structural data + one translation row per (entity, lang)) move into
Postgres, extending the existing `learning_modules`/`learning_lessons` tables rather than duplicating them
(`V10__academy_content_schema.sql`, schema only). A new `GET /api/v1/academy/catalog?lang=` endpoint serves the
full curriculum, authenticated like every other endpoint. Content authoring is JSON files under
`academy-content/` (one per school) — explicitly **not** a CRUD/admin API or a UI, and **not** continuing
hand-written Flyway `INSERT`s either — loaded by an idempotent `AcademyContentSeedRunner` on every boot
(`findById().orElseGet(new)` + `save()` for permanent ids; delete-and-reinsert for everything else). The
client (`AcademyCatalogRepository`/`AcademyCatalogSnapshot`) fetches and caches the catalog per language,
cache-first then revalidate, replacing the static catalog everywhere it was read (calculators now take the
snapshot as a parameter instead of reading a static class). The 8 domains/19 schools/14 modules/16 lessons
already authored in Dart were converted to the new JSON format by a one-time, throwaway script rather than
hand-transcribed, preserving every id exactly (ids are permanent — shared with `lesson_progress`/`xp_events`).
See `ACADEMY_ENGINE.md` §3e for the full design.

### Rationale

- **JSON files over a CRUD/admin API**: the project has no precedent for user-facing content-write endpoints
  anywhere, and building one (auth model for editors, validation, an editing UI) is real, unbounded scope the
  actual problem doesn't need — a JSON diff reviewed in a PR is sufficient authoring UX for a solo/small team,
  and the seeder makes "commit JSON → deploy → live" the entire publish flow.
- **Extending `learning_modules`/`learning_lessons` instead of duplicating them**: those tables are already the
  authoritative id+XP source for `CompleteLessonUseCaseImpl`/`GetLearningProgressUseCaseImpl` — a second,
  parallel content-catalog table would recreate the exact two-tables-that-must-agree problem this decision
  exists to eliminate.
- **Per-language fetch, not pre-fetching all 3 languages**: the old catalog held pt/en/es in memory
  simultaneously, so switching language was instant; fetching all 3 upfront would preserve that but at 3x
  unnecessary network cost on every load for a switch that only happens in Settings. Traded a rare, brief
  loading state for avoiding that constant overhead.
- **Delete-and-reinsert for children, upsert-by-id for parents**: only `academy_domains`/`academy_schools`/
  `learning_modules`/`learning_lessons` have an id shared with user progress and must never be deleted;
  everything nested under them (translations, prerequisites, steps, options, takeaways) has no such constraint,
  so the simplest-correct reconciliation (wipe and rewrite) is safe and requires no diffing logic.

### Consequences

- `AcademyCatalog`, `AcademyDomainCatalog`, `FinancialLifeCatalog`, and the one-time conversion script are
  deleted — the backend database is now the only place curriculum content is authored or stored.
  `docs/ACADEMY_ENGINE.md` §3e supersedes every prior section's implicit assumption of a static, always-available
  catalog; §7's "CMS / content pipeline" and "Backend School/prerequisite/competency schema" Phase-3+ items are
  marked delivered.
- The Academy now has a genuine offline/loading edge case it never had before (first launch with no
  connectivity and no cache) — `AcademyController.isCatalogLoading`/`catalogError` and
  `AcademyCatalogErrorState` handle it explicitly across every Academy screen.
- Adding a new school/module/lesson going forward is a JSON PR + deploy, not a Dart code change + app store
  release — the exact content-velocity unlock this decision was made to provide.

---

# DECISION-023

## Title

Production-Readiness Hardening Pass — Observability, Resilience, and Release Configuration

### Status

Accepted

### Context

Following DECISION-021's "production-grade at every stage" framing, a production-readiness
audit (backend + mobile, static review) found the app's core security design already sound
(BCrypt, secrets via env vars, CORS fail-closed, no hardcoded credentials, `GlobalExceptionHandler`
never leaking stack traces) but identified real operational gaps: no health checks, no outbound
HTTP timeouts, a reset-token log leak path, no CI/CD or containerization, and — on mobile — the
unedited Flutter template `applicationId`/bundle id, debug-signed release builds, and no
crash/error reporting. The project owner directed fixing everything addressable without an
external account/credential the owner alone can provide (a real keystore, a Sentry DSN, an Apple
signing team).

### Decision

Backend: added Spring Boot Actuator (`/actuator/health` only, `permitAll`), a shared
`RestTemplate` bean (`HttpClientConfig`) with bounded connect/read timeouts injected into
`BrapiInvestmentApiClient`/`GeminiChatClient`/`LibreTranslateClient` (previously each built its
own `RestTemplate` with no timeout at all), a `RequestIdFilter` + `logback-spring.xml`
(JSON via `logstash-logback-encoder` in `prod`, a readable pattern otherwise) carrying a
correlation id through every log line, explicit HikariCP pool settings in
`application-prod.properties`, a CSP header in `SecurityConfig` (Spring Security has no default
CSP, unlike HSTS/X-Frame-Options which were already on), the OWASP `dependency-check-maven`
plugin (not bound to the default build — run explicitly / in CI, since it needs network access to
the NVD feed), a multi-stage `Dockerfile`, and `.github/workflows/backend-ci.yml`
(test + non-blocking dependency-check). `JavaMailPasswordResetMailerAdapter`'s dev-only fallback
(logging the raw reset token when no `JavaMailSender` is configured) now throws instead of logging
when the `prod` profile is active, so a misconfigured production SMTP setting fails loudly rather
than leaking a live reset token to logs. Verified (no code change needed): every controller
resolves its user from `SecurityUtils.getCurrentUserEmail()`, never from a client-supplied id —
the audit's suspected IDOR/authorization gap doesn't exist in practice.

Mobile: `applicationId`/namespace/iOS-macOS bundle id changed from the Flutter template default
(`com.example.petrimonium`) to `com.jf.petrimonium` across Android, iOS, macOS, and Linux.
Android release builds sign with a real keystore when `android/key.properties` exists (gitignored;
`key.properties.example` documents the `keytool` command), falling back to debug signing only for
local `flutter run --release`; release builds also enable `minifyEnabled`/`shrinkResources`.
`compileSdk` bumped to 37 to match what `flutter_secure_storage` now requires (Flutter's own
default was a version behind and failed the build). `sentry_flutter` is wired in `main.dart`
behind a build-time `SENTRY_DSN` — a safe no-op until a real DSN is supplied. A release build now
calls `ApiConstants.assertConfiguredForRelease()` at startup, which throws if `API_BASE_URL` was
left at the `localhost` dev default, rather than silently shipping pointed at a developer machine.
`ApiClient`'s HTTP calls now carry a 15s timeout. The Academy offline-sync gap — a lesson
completed offline whose XP sync failed was never retried — is closed with a pending-sync set
(`AcademyProgressLocalRepository.markPendingSync`/`clearPendingSync`) that
`AcademyController.load()` retries on every app start/reconciliation; safe because
`CompleteLessonUseCaseImpl` is already idempotent per lesson id. `.github/workflows/mobile-ci.yml`
runs `flutter analyze` + `flutter test`.

Explicitly **not** done in this pass, because each needs an input only the project owner can
provide or a scope large enough to deserve its own reviewed change: a real Android keystore file
(scaffolding only — see `key.properties.example`), a real Sentry DSN/account, iOS code signing
(Apple Developer team + provisioning profile), JWT refresh/revocation, a Redis-backed
(multi-instance-safe) rate limiter, LGPD data export/delete endpoints, custom app icon/splash
(no source asset exists to use), and broad widget/integration test expansion.

### Rationale

- Every change here is either a config/wiring fix with no product-behavior change, or closes a
  gap the audit found concrete evidence for (the offline-sync silent-failure comment in
  `LessonSessionController` literally said "a future retry will pick this up" — that retry didn't
  exist until now).
- Deferred items all share one trait: completing them requires either a secret/account only the
  owner holds, or is large/sensitive enough (auth token lifecycle, a new rate-limit backing store,
  legal-facing data deletion) to warrant its own scoped review rather than folding into a broad
  hardening pass.
- `RestTemplate` timeouts and the reset-token log fix were the two items with a real, if narrow,
  production failure mode (thread exhaustion under a slow provider; a secret in logs from a
  misconfiguration) — prioritized accordingly over purely-additive items like Actuator.

### Consequences

- `docs/ARCHITECTURE.md`'s Logging/Security/Error Handling principles are now backed by concrete
  implementations (correlation ids, CSP, bounded external-call timeouts) rather than being
  aspirational-only.
- Shipping a real Android/iOS release still requires the owner to run the `keytool` command in
  `android/key.properties.example`, create a Sentry project, and configure iOS signing in Xcode —
  none of that is deferrable to code.
- Future outbound HTTP integrations should reuse the `HttpClientConfig` `RestTemplate` bean rather
  than constructing a new `RestTemplate()`, to keep the timeout guarantee universal.

---

# Future Decisions

Whenever a significant architectural or product decision is made, add a new entry following the same structure.

Each decision should include:

- Title
- Status
- Context
- Decision
- Rationale
- Consequences

---

# Guiding Principle

Document decisions once.

Refer to them often.

Avoid revisiting previously accepted decisions unless new evidence justifies a change.