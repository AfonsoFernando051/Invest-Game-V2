# ROADMAP.md

# Invest Game V2 — Roadmap

## Overview

This roadmap defines development priorities for Invest Game V2. It exists to guide decisions and prevent
speculative work, not to promise a fixed feature list. See `PRODUCT_VISION.md` for the product this roadmap
serves.

The roadmap is staged in three parts — **MVP V2**, **Beta**, **V1** — rather than the previous five numbered
phases. This replaces the old Phase 1–5 structure. Where other documents (`ACADEMY_ENGINE.md`,
`MARKET_EVENTS_ENGINE.md`) use their own internal "Phase 0 / Phase 3+" notation for a specific feature's
rollout, read those as: **Phase 0 ≈ MVP V2, Phase 3+ ≈ Beta or later** — they are feature-local phase
numbers, not this roadmap's stage names.

Growth is driven by evidence — user feedback, real usage data, measured technical need — not by the existence
of an idea in this document. **Not every item below is a commitment; items under Beta and V1 are directional,
not mandatory.**

---

## MVP V2 — Prove the core loop

**Goal:** ship the smallest complete version of `PRODUCT_VISION.md`'s core loop (Learn → Practice → Progress →
Grow) end to end, so it can be validated with real users.

### Learning
- Foundations curriculum (Level 1 of `ACADEMY_ENGINE.md`'s knowledge roadmap).
- Interactive lessons: explanation, example, micro-exercise, applied scenario, summary.
- Quizzes with encouraging, non-punitive feedback.
- Lesson/module/school progress tracking, with a Knowledge Progress track separate from Game Level.

**Status:** expanded beyond the original Phase 0 slice by explicit user direction (`DECISIONS.md`
DECISION-018) — a `School` layer now groups modules into the brief's full 19-school journey; School 1
("Financial Life," 10 new lessons) and School 3 ("Investment Fundamentals," the pre-existing "Fundamentos do
Investidor" module) are real, the other 17 schools are "coming soon" placeholders. See `ACADEMY_ENGINE.md`.

### Gamification
- XP tied to learning and practice actions (see `FEATURES.md`'s XP table).
- Levels derived from XP.
- Basic achievements and missions.

**Status:** implemented, but **XP is currently also awarded for portfolio value and profit thresholds** in
`mission_catalog.dart` / `achievement_catalog.dart` — this contradicts the learning-first XP principle and is
tracked as a required migration before MVP V2 can be considered complete. See `FEATURES.md` and `DECISIONS.md`.

### Pet
- Five species (Dog, Wolf, Fox, Bear, Lion), basic evolution stages, basic reward-driven progression.

**Status:** implemented for the Dog species' art assets; other species share the enum but not full evolution
art — see `ARCHITECTURE.md`'s Current vs Target notes.

### Portfolio
- Add/track holdings, transaction history, allocation, dividends, basic performance.
- No order execution — tracking and simulation only (see `PRODUCT_VISION.md` §11).

**Status:** implemented.

### Integration
- Lesson → portfolio contextualization ("you just learned P/E — here's how it looks on this asset").

**Status:** not yet implemented — the Academy and Portfolio features are intentionally decoupled today
(`ACADEMY_ENGINE.md` §4). This is the highest-value MVP V2 gap to close next, since it is this product's core
differentiator (`PRODUCT_VISION.md` §10).

### Mentor
- Lesson-focused, portfolio-grounded educational chat with safety rules (no buy/sell advice, no price
  predictions).

**Status:** implemented (`AI_MENTOR.md`).

### MVP V2 completion criteria

MVP V2 is complete when a user can:

- create an account and log in;
- complete the Foundations learning path lesson by lesson, with quizzes;
- earn XP exclusively from learning/practice actions (not wealth or profit);
- see their pet evolve as a result;
- track a real or simulated portfolio;
- see at least one lesson concept reflected back in their portfolio view;
- ask the Mentor a grounded question and get a safe, educational answer.

---

## Beta — Expand the loop

Begins once MVP V2's core loop is validated with real usage.

- Fixed Income, Variable Income, ETFs, FIIs, and Fundamental Analysis curriculum levels (`ACADEMY_ENGINE.md`
  knowledge roadmap, Levels 2–4).
- Backend-authoritative learning progress and XP (event-sourced `XPEvent` model — see `FEATURES.md`).
- Missions and streaks expanded, richer achievements.
- Multiple pet species with full evolution art, accessories, habitat customization.
- Educational Portfolio Intelligence: contextual callbacks from portfolio/dividend events back to relevant
  lessons (`MARKET_EVENTS_ENGINE.md`, reinterpreted as educational triggers rather than trading cues).
- Contextual Mentor invocation from lesson/asset screens instead of only a standing chat tab.
- Practical market challenges (e.g. "compare the P/E of three companies you follow").
- Stronger analytics on learning engagement and retention.

## V1 — Depth and personalization

Directional, evidence-gated — none of this is a commitment until Beta data justifies it.

- Adaptive learning (content sequencing based on quiz performance).
- Advanced portfolio analytics.
- Richer practice challenges, including paper-trading-style simulation steps.
- Deeper pet evolution and collectible depth.
- Seasonal content / live-ops calendar.
- Social features — only if user demand is validated; not assumed.
- Stronger personalization across learning and Mentor.

---

## Features not planned

Outside this product's scope, at any stage documented here:

- Cryptocurrency trading
- Real-money investing / order execution
- Banking services, payment processing, brokerage integration
- High-frequency or professional trading tooling
- The Mentor acting as an autonomous, deterministic financial adviser ("buy this," "put 70% here")

See `PRODUCT_VISION.md` §11 for the reasoning.

---

## Decision rules

Before starting a new feature, ask:

- Which step of the core loop (`PRODUCT_VISION.md` §6) does this strengthen?
- Does it keep XP tied to learning/practice, not wealth?
- Is it required to validate the current stage (MVP V2 / Beta / V1), or does it belong to a later one?
- Will users benefit from it without being pulled away from the learning-first center of the product?

If the honest answer weakens any of these, postpone the feature and record why in `DECISIONS.md` if the
question is likely to come up again.

---

## Guiding principle

Finish the core loop before expanding it. A validated MVP V2 that proves Learn → Practice → Progress → Grow
creates more value than a wide feature set that never proves the loop works.
