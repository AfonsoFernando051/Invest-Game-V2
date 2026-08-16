# Invest Game V2

> A learning-first investment education application: learn progressively, practice through a real portfolio,
> earn XP through learning, and watch your companion grow with you.

---

# What is Invest Game V2?

Invest Game V2 teaches beginners how to invest through structured, interactive lessons — then lets them
apply what they've learned to a tracked, practical portfolio. Gamification (XP, levels, missions, a virtual
pet) exists to keep the experience motivating and to represent progress, not to be the point of the product.

See [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md) for the full product vision — it is the source of
truth for what this product is and why.

---

# Core loop

```text
Learn → Practice → Progress → Grow
```

Open the app → continue a lesson → learn a concept → practice it in a quiz → earn XP → watch the pet
progress → apply the concept to your tracked portfolio → return to learning. Full detail in
`docs/PRODUCT_VISION.md` §6.

---

# Main areas

- **Learn** — the Academy: structured learning paths, interactive lessons, quizzes.
- **Portfolio** — track holdings, transactions, and dividends; connect lessons to real assets. No order
  execution.
- **Pet** — an evolving companion that visually represents your learning progress.
- **Mentor** — a contextual AI tutor grounded in your learning progress and portfolio, never an autonomous
  financial adviser.

---

# Technical stack

- **Frontend:** Flutter / Dart (`petapp_mobile/`)
- **Backend:** Java / Spring Boot, modular monolith (`PetApp-Backend/`)
- **Database:** PostgreSQL + Flyway
- **Auth:** JWT

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full system architecture, including what's
implemented today versus the target shape.

---

# Repository relationship

This is an **independent V2 repository**, derived from the original `Pet-Invest-App` MVP but pursuing a
different product direction. The original MVP remains preserved in its own repository as historical context
and a technical reference — it is not this product's specification. See
[`docs/PROJECT_CONTEXT.md`](docs/PROJECT_CONTEXT.md) for the full relationship and the reasoning behind the
strategy change.

---

# Documentation

The complete project documentation is in [`docs/`](docs/). Recommended reading order:

1. [`AGENTS.md`](docs/AGENTS.md) — start here if you're an AI assistant
2. [`PRODUCT_VISION.md`](docs/PRODUCT_VISION.md) — source of truth for the product
3. [`PROJECT_CONTEXT.md`](docs/PROJECT_CONTEXT.md) — repository context and documentation model
4. [`ARCHITECTURE.md`](docs/ARCHITECTURE.md)
5. [`DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md)
6. [`CODING_GUIDELINES.md`](docs/CODING_GUIDELINES.md)
7. [`API_GUIDELINES.md`](docs/API_GUIDELINES.md)
8. [`FEATURES.md`](docs/FEATURES.md)
9. [`ACADEMY_ENGINE.md`](docs/ACADEMY_ENGINE.md), [`AI_MENTOR.md`](docs/AI_MENTOR.md), [`MARKET_EVENTS_ENGINE.md`](docs/MARKET_EVENTS_ENGINE.md)
10. [`ROADMAP.md`](docs/ROADMAP.md)
11. [`DECISIONS.md`](docs/DECISIONS.md)
12. [`AI_RULES.md`](docs/AI_RULES.md)

---

# Product identity

Invest Game V2 **is not**:

- a bank;
- a brokerage or execution platform;
- a cryptocurrency exchange;
- an autonomous financial adviser.

Invest Game V2 **is**:

- a learning-first investment education platform;
- a structured, gamified learning journey;
- a practical portfolio tracker;
- a companion-driven progression experience.

---

# Development philosophy

- Learning-first: every feature is evaluated against `PRODUCT_VISION.md`'s core loop.
- MVP-first within each stage: prove the loop before expanding it (`ROADMAP.md`).
- Prefer incremental improvements over large rewrites.
- Reuse existing components and patterns before introducing new ones.
- Technology exists to support the product — not define it.

---

# Contributing

Before making changes:

- Read `docs/PRODUCT_VISION.md` and `docs/AGENTS.md`.
- Follow the existing architecture (`docs/ARCHITECTURE.md`).
- Preserve the visual identity (`docs/DESIGN_SYSTEM.md`).
- Never award XP for wealth, portfolio size, or profit — see `docs/FEATURES.md`'s XP System.
- Update documentation in the same change when architectural behavior changes.
