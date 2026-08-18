# AGENTS.md

# AI Assistant Guide

Welcome to the Invest Game V2 repository.

Before making changes, read the project documentation to understand the product, architecture, coding standards, and current priorities.

**This is a documentation-defined product pivot.** The product is now learning-first
(`PRODUCT_VISION.md`) — not the previous "gamified investing app" direction. When in doubt about product
intent, `PRODUCT_VISION.md` overrides older assumptions baked into code comments, variable names, or your own
prior training on this repo.

## Documentation Index

Read the following files in order:

1. `PRODUCT_VISION.md`
   - What the product is and why (source of truth)
   - Positioning, target audience, core loop
   - Safety boundaries

2. `PROJECT_CONTEXT.md`
   - Repository relationship to the original Pet Invest App MVP
   - Documentation model
   - Product identity, pet companion narrative

3. `ARCHITECTURE.md`
   - System architecture (Current vs. Target)
   - Frontend structure
   - Backend structure
   - Database
   - Technical decisions

4. `DESIGN_SYSTEM.md`
   - UI guidelines
   - UX principles
   - Visual identity
   - Components
   - Animations
   - Accessibility

5. `CODING_GUIDELINES.md`
   - Code style
   - Best practices
   - Flutter conventions
   - Spring Boot conventions
   - Financial precision & auditability rules

6. `API_GUIDELINES.md`
   - REST conventions (Current vs. Target)
   - Authentication
   - Error handling
   - API standards

7. `FEATURES.md`
   - Functional specifications, ordered by product priority
   - Business rules
   - Feature status (Current vs. Target)

8. `ACADEMY_ENGINE.md` / `AI_MENTOR.md` / `MARKET_EVENTS_ENGINE.md`
   - Domain-specific engine designs for Learning, Mentor, and Market Events

9. `ROADMAP.md`
   - Alpha / Beta / V1 staging
   - What's not planned

10. `DECISIONS.md`
    - Architectural Decision Records (ADR)
    - Important historical decisions
    - Trade-offs
    - Rejected approaches

11. `AI_RULES.md`
    - Rules that govern AI behavior
    - Constraints
    - Development philosophy

---

# Collaboration Principles

Always understand the existing project before proposing changes.

Preserve the project's architecture, coding style, and visual identity.

Avoid introducing unnecessary complexity.

Prefer incremental improvements over large rewrites.

Always explain technical trade-offs when suggesting significant changes.

If multiple solutions exist, prefer the one that provides the best balance between maintainability, readability, and implementation effort.

---

# Product Maturity

Invest Game V2 is a long-term, production-grade financial education and investment platform under continuous
development — not an MVP, prototype, or proof of concept. Historical references to "MVP V2" describe the
current roadmap *stage* (`ROADMAP.md`'s "Alpha" stage — see DECISION-021), not the product's ambition.
Build every feature on production-appropriate foundations: correct, maintainable, testable, and extensible —
see `AI_RULES.md` for the full standard. This does not mean building every future feature now; it means not
choosing shortcuts that create predictable technical debt (see `AI_RULES.md`'s Technical Debt Policy for how
to document an unavoidable one).

The primary goal is completing the Alpha stage's core loop (`ROADMAP.md`) to a production-quality bar
before introducing new stages of work.

Do not suggest large architectural changes or technology migrations unless explicitly requested.

---

# General Principles

Always prioritize:

- Maintainability
- Readability
- Simplicity
- Reusable components
- Consistent user experience
- Performance
- Clean architecture

Avoid:

- Premature optimization
- Overengineering
- Unnecessary refactoring
- Technology changes without clear justification
- UI redesigns unless explicitly requested

---

# Product Identity

Invest Game V2 is **not** a banking application, a brokerage, or an autonomous financial adviser.

It is a **learning-first investment education platform**: the user learns progressively, practices through a
tracked portfolio, earns XP primarily through learning and educational practice, and evolves a pet as a
representation of that progress. See `PRODUCT_VISION.md` for the full positioning.

Every technical and design decision should reinforce this vision — see the checklist below.

# Rules Specific to This Product

- **Product priority is learning first.** Do not propose changes that treat the portfolio or gamification as
  the primary mechanic — see `PRODUCT_VISION.md` §4.
- **Do not create duplicate architecture.** Extend the existing `core → application → infrastructure →
  presentation` (backend) and `presentation/domain/data` (Flutter) layering rather than introducing a
  parallel pattern.
- **Domain logic never lives in Flutter UI.** Business rules belong in domain/service layers on both sides —
  see `CODING_GUIDELINES.md`.
- **XP must be auditable and must never reward wealth, portfolio size, or profit directly.** See
  `FEATURES.md`'s XP System and DECISION-014 — this is a known, tracked gap in the current implementation,
  not a pattern to extend.
- **The portfolio's current market value is a tracked figure, never the source of truth for XP or rewards.**
  Rewards derive from learning/practice events.
- **The Mentor is educational and contextual, never an autonomous financial adviser.** No deterministic
  buy/sell/allocation instructions — see `AI_MENTOR.md` and `PRODUCT_VISION.md` §11.
- **Update documentation when architectural behavior changes.** If you change something this documentation
  set describes, update the relevant file in the same change.
- **Do not introduce technologies without an explicit architectural reason.** See `ARCHITECTURE.md`'s
  Decision Principles.

---

# Important

If documentation conflicts with implementation:

1. Follow `PRODUCT_VISION.md` for product intent (it is the source of truth per `PROJECT_CONTEXT.md`'s
   documentation model).
2. Follow `DECISIONS.md`
3. Follow `ROADMAP.md`
4. Follow the existing implementation
5. Ask for clarification before making breaking changes

Where a document explicitly marks something **Current** vs. **Target** (see `ARCHITECTURE.md`,
`FEATURES.md`, `API_GUIDELINES.md`), the Current label describes what's actually implemented — trust it over
inferring behavior from older, unmarked prose elsewhere.

Never assume a redesign or rewrite is acceptable without explicit approval.