# PROJECT_CONTEXT.md

# Invest Game V2 — Project Context

## What this repository is

Invest Game V2 (`AfonsoFernando051/Invest-Game-V2`) is a **new, independent product repository** derived from
the original `Pet-Invest-App` MVP. It reuses that MVP's codebase, patterns, and Flutter/Spring Boot foundation
as a starting point, but it is being steered toward a **different product** with a different philosophy and a
different priority order between its systems.

**Treat the original MVP as historical context, an implementation reference, and a reusable technical
foundation — not as the specification for this product.** The specification for what this product is and is
becoming lives in `PRODUCT_VISION.md`.

---

## The direction change, in one line

The original concept was closer to *a gamified investment app with a portfolio, education, an AI mentor, and
a virtual pet*, with all of those treated as roughly equal pillars. V2 is a **learning-first investment
education product**: the user learns progressively, practices what they learn through a portfolio, earns XP
primarily through learning and educational practice, and evolves a pet as a representation of that progress.
See `PRODUCT_VISION.md` for the full reasoning, positioning, and target audience.

---

## Mission

Help beginners build real investing knowledge, in the right order, through interactive learning — and let
them see that knowledge applied to a real, tracked portfolio.

---

## Product identity

Invest Game V2 **is**:

- an investment education platform;
- a structured, gamified learning journey;
- a practical portfolio tracker and learning environment;
- a companion-driven progression experience.

Invest Game V2 **is not**:

- a bank;
- a brokerage or execution platform;
- a trading-signal or advisory service;
- a professional analyst's tool.

This distinction should always be respected — see `PRODUCT_VISION.md` §11 for the full safety boundary.

---

## Documentation model

Every document in `docs/` belongs to one of these categories. Avoid creating a new file unless none of the
existing ones represent the concept.

| Category | Question it answers | Documents |
|---|---|---|
| **Product** | What the product is and why it exists | `PRODUCT_VISION.md`, `PROJECT_CONTEXT.md` |
| **Domain** | How business concepts relate | `FEATURES.md`, `ACADEMY_ENGINE.md`, `MARKET_EVENTS_ENGINE.md` |
| **Architecture** | How the software is structured | `ARCHITECTURE.md`, `API_GUIDELINES.md` |
| **Engineering** | How developers implement features | `CODING_GUIDELINES.md` |
| **AI** | How AI systems (Mentor + coding assistants) behave | `AI_MENTOR.md`, `AGENTS.md`, `AI_RULES.md` |
| **Design** | How the interface should look and feel | `DESIGN_SYSTEM.md` |
| **Planning** | What ships when, and why decisions were made | `ROADMAP.md`, `DECISIONS.md` |

The Home/navigation/core-loop "Experience" material lives inside `PRODUCT_VISION.md` rather than a separate
file — it's small enough that a dedicated document would fragment, not clarify.

---

## Technical philosophy

Technology exists to support the product. New technologies are adopted only when they solve a real, current
problem — not because a newer alternative exists. Stability and maintainability are preferred over novelty.
See `ARCHITECTURE.md` and `DECISIONS.md` for the accepted stack and the reasoning behind it.

---

## Product evolution order

1. Prove the core learning loop (see `PRODUCT_VISION.md` §6) end to end.
2. Stabilize the architecture supporting it.
3. Expand curriculum and gamification depth.
4. Deepen the learning ↔ portfolio connection.
5. Refine UX and visual polish.

Large rewrites are avoided unless they solve a demonstrated, significant problem. See `ROADMAP.md` for the
MVP / Beta / V1 staging of this order.

---

## Core values

Every feature should reinforce at least one of:

- Learning
- Practice
- Progression
- Motivation
- Simplicity
- Trustworthiness

If a feature does not clearly serve one of these, reconsider whether it belongs in the product — see
`PRODUCT_VISION.md` §6's product rule.

---

## The Pet Companion system

### Emotional core of the app

The pet is the visual and emotional reflection of the user's **learning journey** — not of their portfolio's
performance and not of their wealth. It is the core driver of daily engagement and retention, but it earns
that role by representing *progress through learning*, not by tracking money.

### Companion mechanics

- **Visual progression.** As the user completes lessons, quizzes, and missions, the pet evolves. Leveling up
  the pet represents motivational progression (see `PRODUCT_VISION.md` §9 for why this is explicitly *not*
  the same as financial competence).
- **Space-themed habitat.** The pet inhabits an evolving environment consistent with the app's futuristic,
  space-inspired visual identity (see `DESIGN_SYSTEM.md`). Users unlock skins, habitat decorations, and
  collectible accessories through progression — cosmetic, never gameplay-affecting.
- **Dynamic feedback.** The pet reacts to learning milestones, streaks, mission completions, and — as an
  educational moment, not a financial verdict — to what happens in the user's tracked portfolio. See
  `MARKET_EVENTS_ENGINE.md` for how portfolio/market events are turned into pet reactions and educational
  callbacks rather than trading cues.

### Safe learning environment

The pet never "dies," degrades, or penalizes the user for a wrong quiz answer or a portfolio drawdown.
Mistakes — in a quiz or in a tracked position — are learning opportunities. When a tracked portfolio drops,
the pet's role is to calmly point back to relevant lessons (diversification, patience, market cycles), never
to shame or punish. This no-punishment principle is binding across Academy (`ACADEMY_ENGINE.md`) and
Market Events (`MARKET_EVENTS_ENGINE.md`) design.

### Pet identity, not financial advice

Pet species (Dog, Wolf, Fox, Bear, Lion) are a personality/identity choice made during onboarding. **Species
selection must never be presented as, or driven by, a financial risk-tolerance assessment.** The backend
already computes an investor risk profile (`InvestorProfile`: Guardian/Tactician/Adventurer) from a separate
onboarding questionnaire — that profile is deliberately not linked to pet species in code today, and should
stay that way unless a specific, reviewed product decision changes it.
