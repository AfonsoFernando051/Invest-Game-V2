# ARCHITECTURE.md

# System Architecture

## Overview

Invest Game V2 follows a traditional client-server architecture designed for maintainability, scalability, and rapid iteration. It supports the learning-first product defined in `PRODUCT_VISION.md` — the architecture exists to serve that product, not the other way around.

The current architecture prioritizes simplicity and predictable development over premature optimization, and is intentionally designed to evolve incrementally.

This document distinguishes **Current** (what exists in the codebase today) from **Target** (what the V2 direction is evolving toward) wherever they differ materially — see DECISION-016 in `DECISIONS.md`.

---

# Technology Stack

## Frontend

- Flutter
- Dart

Responsibilities:

- User Interface
- State Management
- Navigation
- API Communication
- Local Storage
- Animations
- User Experience

---

## Backend

- Java
- Spring Boot

Responsibilities:

- Authentication
- Authorization
- Business Rules
- Learning Progress
- Portfolio Tracking
- User Progression (XP, levels)
- Missions
- Achievements
- REST API

Rankings/leaderboards are a deprecated early-stage concept, not a current backend responsibility — see
`FEATURES.md`'s "Deprecated / reconsidered concepts."

---

## Database

- PostgreSQL

Responsibilities:

- Persistent storage
- Transactions
- User data
- Financial simulation
- Game progression

---

## Authentication

Authentication is based on JWT.

Responsibilities:

- Login
- Registration
- Token validation
- Session management
- Authorization

---

# Architecture Style

The backend follows a layered architecture.

```
Controller
    ↓
Service
    ↓
Repository
    ↓
Database
```

Each layer has a single responsibility.

Business logic belongs exclusively inside the Service layer.

Controllers should remain thin.

Repositories should only access data.

---

# Frontend Architecture

Flutter is organized by features, each following a `presentation / domain / data` split internally.

## Current

```
petapp_mobile/lib/
core/
    constants/   di/   events/   navigation/
    network/     services/   theme/   utils/   widgets/
features/
    academy/       (Learning — see ACADEMY_ENGINE.md)
    asset_details/
    auth/
    dashboard/     (bottom-nav shell + Home content)
    game/          (level/XP calculation)
    home/
    investment/
    mentor/
    onboarding/
    pet/
    portfolio/
    profile/
    settings/
```

State is wired manually: a single `DI` service locator (`core/di/`) plus `ChangeNotifier` controllers
(`PortfolioController`, `MascotController`, `AcademyController`, `LessonSessionController`,
`AssetDetailsController`, `MentorChatController`, `PetCompanionController`), observed via
`AnimatedBuilder`/`ListenableBuilder`/`addListener`. No state-management package (Provider/Riverpod/Bloc/GetX)
is used.

`PetCompanionController` (`features/pet/presentation/companion/`) is the persistent pet companion's single
source of truth: which contextual `PetMessage` (see `PetMessageCatalog`) the speech bubble is showing, driven
by route-aware `enterContext(PetContext)` calls from each major screen and by `AppEventBus` reactions
(lesson/XP/level-up/achievement/evolution). One instance is owned by `DashboardScreen` for the whole
authenticated session — `PetCompanionHeader`/`PetSpeechBubbleOverlay`/`PetInteractionSheet` are the reusable
presentation layer wired to it; no screen holds its own copy.

## Target

```
lib/
├── core/
│   ├── networking/
│   ├── storage/
│   ├── theme/
│   ├── routing/
│   └── utilities/
└── features/
    ├── auth/
    ├── home/
    ├── learning/       (product-facing name for today's `academy/`)
    ├── portfolio/
    ├── pet/
    ├── gamification/   (XP/levels/missions/achievements, currently spread under portfolio/ and game/)
    ├── mentor/
    └── profile/
```

**Gap:** the target groups gamification (XP, levels, missions, achievements) into its own feature; today it is
split across `features/game/` (level calculation) and `features/portfolio/domain/services/` (mission and
achievement catalogs). This consolidation is a Beta-stage refactor, not required for the Alpha stage — see `ROADMAP.md`.
The feature is called "Academy" in code and product copy (see `ACADEMY_ENGINE.md`) even though the conceptual
pillar is named "Learning" in `PRODUCT_VISION.md`; both names refer to the same feature and do not need to be
reconciled by renaming code.

**Rule (current and target):** UI must not call network services directly.

```text
Widget
 ↓
Controller / Notifier
 ↓
Use Case
 ↓
Repository
 ↓
Data Source
 ↓
API
```

---

# State Management

The current lightweight `ChangeNotifier` approach is a deliberate choice for the app's current size and
complexity, not a permanent constraint — see `AI_RULES.md`'s Technical Debt Policy if it's ever kept past the
point it stops fitting. The target principle is:

> UI state and business state must remain separated.

Do not introduce a new state-management package merely to modernize the stack. Any future migration must be
justified by demonstrated complexity the current approach can no longer handle — see `AI_RULES.md`.

---

# Backend Architecture

The backend is organized as a modular monolith with a hexagonal-leaning layering:
`core (domain/ports) → application (use cases per module) → infrastructure (adapters) → presentation
(controllers)`.

## Current

```
com/jf/PetApp/
core/
    domain/assessment/   domain/enums/   port/   security/
application/
    auth/   investment/   mentor/   onboarding/   pet/   settings/   translation/   user/
infrastructure/
    config/   controller/   entity/   external/   repository/   security/
presentation/
    auth/
```

This already closely matches the target shape below — no restructuring is required to reach it, only new
modules as features grow.

## Target

```
core/
├── domain/
└── ports/

application/
├── learning/
├── portfolio/
├── gamification/
├── pet/
└── mentor/

infrastructure/
├── persistence/
├── market-data/
├── ai/
└── security/

presentation/
├── auth/
├── learning/
├── portfolio/
├── gamification/
├── pet/
└── mentor/
```

Avoid microservices during V2 unless a demonstrated scaling or organizational need requires them
(DECISION-017).

---

# Business Logic

Business rules should never exist inside:

- Flutter Widgets
- Controllers
- Database queries

Business rules belong in dedicated service classes.

---

# API Design

The backend exposes a REST API. See `API_GUIDELINES.md` for conventions, namespaces, and the current
(unversioned) vs. target (`/api/v1/*`) URL structure.

General principles:

- Stateless
- JSON only
- Consistent naming
- Clear error responses
- Proper HTTP status codes

Future GraphQL adoption is not planned.

---

# Reusable Components

The frontend should maximize component reuse.

Examples:

- Buttons
- Cards
- Dialogs
- Inputs
- Progress Indicators
- Loading States
- Empty States
- Error States

Avoid duplicating UI code.

---

# Domain Model (Target)

Conceptual blueprint for the V2 domain — not an instruction to implement every entity immediately. See
`ROADMAP.md` for what's staged into Alpha vs. Beta.

```text
USER
│
├── USER_PROFILE
├── USER_PREFERENCES
│
├── LEARNING_PROGRESS
│
├── QUIZ_ATTEMPT
│
├── XP_EVENT
│
├── ACHIEVEMENT
│
├── MISSION
│
├── PET
│
└── PORTFOLIO


COURSE / LEARNING PATH
├── MODULE
└── LESSON


PORTFOLIO
├── TRANSACTION
├── POSITION
└── PORTFOLIO_SNAPSHOT


ASSET
├── PRICE
├── FUNDAMENTALS
└── DIVIDEND
```

**Current:** only `USER`, `PORTFOLIO`/`TRANSACTION`-adjacent tables (`jf_finances` and related), and pet
profile data (`jf_pets`) exist in PostgreSQL. `LEARNING_PROGRESS`, `XP_EVENT`, `QUIZ_ATTEMPT`, `ACHIEVEMENT`,
and `MISSION` do not exist on the backend at all today — they live entirely in Flutter local storage
(`SharedPreferences`). See `ACADEMY_ENGINE.md` and `FEATURES.md`'s XP System for the migration path.

---

# Database Principles

The database is the single source of truth for persistent business data — learning progress, XP events,
achievements, missions, pet progression, portfolio, transactions, assets, and dividends (target state; see
gap above for what's local-only today).

Local device storage (`SharedPreferences`) is appropriate for theme, temporary preferences, cached UI state,
and other non-authoritative local data — **not** as the canonical source of learning progress or XP once the
backend migration above happens.

Avoid:

- duplicated information
- inconsistent relationships
- unnecessary denormalization

Optimize only when measurements indicate a real need.

---

# Performance Philosophy

Performance is important.

Premature optimization is not.

Always prefer:

- readable code
- maintainable code
- measurable improvements

Only optimize proven bottlenecks.

---

# Scalability

The current architecture is intentionally simple.

Scale only when necessary.

Expected evolution:

1. Stable Alpha-stage release
2. Production usage
3. Performance improvements
4. Infrastructure improvements
5. Horizontal scaling

Do not build for millions of users before validating the product.

---

# AWS Strategy

AWS Lambda has been evaluated.

Current decision:

Do NOT migrate the backend to a serverless architecture at the current stage of development.

Reasons:

- Increased complexity
- Harder debugging
- No current scaling requirement
- Traditional backend better fits current needs

Future Lambda adoption is acceptable only for asynchronous workloads.

Examples:

- Scheduled jobs
- Notification processing
- Report generation
- Ranking updates
- Background calculations
- Import/export tasks

Core business logic should remain inside the Spring Boot backend.

---

# Market Data Abstraction

```text
AssetDataProvider
       ↓
Provider Adapter
       ↓
External Market API
```

The domain must never depend directly on a market-data vendor. **Current:** already satisfied —
`ExternalInvestmentApiPort` is the port, `BrapiInvestmentApiClient` the sole adapter. This shape makes a
future provider swap (or adding a second provider) a new adapter class, not a domain change — keep new
market-data integrations (e.g. `MarketEventSourcePort` in `MARKET_EVENTS_ENGINE.md`) behind the same pattern.

---

# Error Handling

Errors should be:

- predictable
- descriptive
- logged
- user-friendly

Never expose internal exceptions directly to users.

---

# Logging

Log meaningful events.

Examples:

- Authentication
- Business failures
- External API failures
- Unexpected exceptions

Avoid excessive logging.

Sensitive information must never be logged.

---

# Security

Always validate:

- authentication
- authorization
- user ownership
- request input

Never trust client-side validation.

The backend is responsible for enforcing business rules.

---

# Testing Philosophy

Critical business rules should be testable.

Prioritize testing:

- Services
- Business rules
- Authentication
- Financial calculations

These are non-negotiable, regardless of project stage — "MVP" is never a reason to skip testing
business-critical logic (`AI_RULES.md`). Widget/UI tests are added where they protect a meaningful user flow
(e.g. a lesson session's completion path) rather than for blanket coverage of every screen.

---

# Maintainability

Every architectural decision should reduce long-term maintenance costs.

Prefer:

- simple solutions
- explicit code
- reusable modules
- low coupling
- high cohesion

Avoid unnecessary abstractions.

---

# Evolution Principles

Architecture should evolve gradually.

Preferred order:

1. Build
2. Validate
3. Improve
4. Optimize
5. Scale

Avoid rewriting working code unless there is a measurable benefit.

---

# Decision Principles

Before introducing a new library, framework, or architectural pattern, ask:

- Does it solve a real problem?
- Is the current solution insufficient?
- Does it reduce maintenance?
- Is the added complexity justified?
- Will the team benefit from this change?

If the answer is "no" to most questions, keep the existing solution.

---

# Architecture Goals

The architecture should always prioritize:

- Simplicity
- Readability
- Maintainability
- Testability
- Scalability
- Reliability

Technology choices should support the product—not drive it.