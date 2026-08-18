# AI_RULES.md

# AI Development Rules

## Purpose

This document defines how AI assistants should collaborate on Invest Game V2.

The goal is to ensure that every suggestion, implementation, or review aligns with the project's architecture, product vision, design philosophy, and development priorities.

These rules apply to all AI coding assistants.

---

# Primary Objective

Help develop Invest Game V2 while preserving its:

- Product vision
- Architecture
- Visual identity
- Code quality
- Maintainability

The AI should improve the project, not reinvent it.

---

# Understand Before Changing

Before proposing any implementation:

Read the project documentation.

At minimum, understand:

- PRODUCT_VISION.md (source of truth for product intent)
- PROJECT_CONTEXT.md
- ARCHITECTURE.md
- DESIGN_SYSTEM.md
- FEATURES.md
- ROADMAP.md
- DECISIONS.md

Never make assumptions without understanding the existing project. Never assume the previous "gamified
investing app" framing still applies — `PRODUCT_VISION.md` documents the current, learning-first direction.

---

# Preserve Existing Decisions

Architectural decisions already made should be respected.

Do not suggest replacing technologies simply because newer alternatives exist.

Examples:

Do not suggest:

- Migrating Flutter to another framework
- Rewriting Spring Boot
- Moving to microservices
- Switching to serverless
- Rebuilding the UI

Unless the user explicitly requests it.

---

# Production-Grade Standards, Not MVP Validation

Invest Game V2 is a long-term, production-grade financial education and investment platform under continuous
development — not an MVP, prototype, proof of concept, or throwaway implementation. "MVP" may still describe
*historical* context (e.g. the original Pet Invest App MVP this project superseded, or `ROADMAP.md`'s
"Alpha" stage before it was renamed — see DECISION-021) but must not be used to justify a shortcut today.

The following reasoning is no longer acceptable:

- "It's okay, this is just an MVP."
- "We can hardcode this for now because it's early-stage."
- "We don't need validation/tests because it's not production yet."
- "We'll rewrite it properly later."

The evaluating question for new work is **"What is the production-quality version of this feature?"**, not
"What is the minimum version that can demonstrate the idea?" This does not mean building every possible future
feature now — see `AI_RULES.md`'s Keep Solutions Simple / Avoid sections below, which still apply in full.
It means building today's scoped feature on foundations — domain logic, state management, error handling,
validation, accessibility — that do not unnecessarily block tomorrow's features.

The current priority is completing `ROADMAP.md`'s active stage (Alpha, then Beta, then V1) to a
production-quality bar before expanding into the next one — still evaluate every new suggestion against:

- Completing unfinished features to production quality (not just "working on the happy path")
- Fixing bugs at the root cause, not with a workaround that hides them
- Improving stability and maintainability
- Avoiding large new systems that aren't required by the current roadmap stage

---

# Technical Debt Policy

Technical debt is allowed. Hidden technical debt is not.

Whenever a shortcut is genuinely necessary (e.g. a temporary client-side computation standing in for a
not-yet-built backend endpoint), document it explicitly, in the code and/or in `DECISIONS.md` for anything
significant, using this shape:

```text
Technical Debt
Why: <the constraint that made the shortcut necessary>
Impact: <what breaks or degrades because of it>
Current workaround: <what's actually implemented today>
Desired future state: <what should eventually replace it>
Priority: <how urgent closing this gap is>
```

Do not normalize a permanent shortcut as if it were the intended architecture — a future reader (human or AI)
should be able to tell, at a glance, that something is a deliberate temporary boundary rather than a design
choice.

---

# Think Like a Senior Engineer

Always evaluate:

- Implementation cost
- Long-term maintenance
- Simplicity
- Readability
- Scalability
- User impact

Do not optimize for theoretical perfection.

Optimize for practical development.

---

# Preserve the Architecture

Follow the existing architecture.

Do not introduce new architectural patterns unless there is a clear reason.

Examples of changes that require strong justification:

- Event sourcing
- CQRS
- Microservices
- Serverless architecture
- Domain-driven redesign

The current architecture is intentionally simple.

Respect it.

---

# Preserve the Design

The application's visual identity is established.

Improve the interface through refinement.

Do not redesign it.

Focus on:

- Better spacing
- Better hierarchy
- Better usability
- Better accessibility
- Better animations

Never change the overall visual identity without explicit approval.

---

# Reuse Existing Components

Before creating new code:

Check whether an existing solution already exists.

Prefer:

- Existing widgets
- Existing services
- Existing utilities
- Existing design patterns

Consistency is more valuable than originality.

---

# Keep Solutions Simple

Prefer:

Simple solutions.

Avoid:

Complex solutions that solve hypothetical future problems.

Follow:

- KISS
- DRY
- YAGNI

---

# Explain Trade-offs

When multiple solutions exist:

Explain:

- Advantages
- Disadvantages
- Complexity
- Long-term maintenance

Recommend one solution and justify it.

Do not simply list options.

---

# Incremental Improvements

Prefer improving existing code over replacing it.

Small improvements are preferred over large rewrites.

If an existing implementation works:

Improve it.

Do not rebuild it.

---

# Performance

Optimize only when necessary.

Do not introduce complexity for hypothetical performance gains.

Measure before optimizing.

---

# Code Generation

Generated code should:

- Follow project conventions
- Be readable
- Be maintainable
- Be reusable
- Match the existing style

Avoid generating isolated code that ignores the current architecture.

---

# Business Logic

Business rules belong in the business layer.

Never move business logic into:

- Flutter Widgets
- Controllers
- UI components

Respect the existing separation of responsibilities.

---

# Documentation

Whenever a significant architectural decision is made:

Suggest updating:

- DECISIONS.md
- FEATURES.md
- ROADMAP.md

Documentation should evolve together with the project.

---

# Product Mindset

Always remember:

Invest Game V2 is:

- A learning-first investment education platform. Learning is primary; the portfolio is a practice
  environment; gamification is a motivation layer; the Mentor is a support layer. See `PRODUCT_VISION.md` §4.

It is NOT:

- A banking application.
- A brokerage or execution platform.
- A cryptocurrency exchange.
- An autonomous financial adviser.

Every suggestion should reinforce the learning-first nature of the product — gamification and the pet exist
to support learning retention, not the other way around.

---

# Specific Rules for This Product

- **XP must be auditable and must never reward wealth, portfolio size, or profit directly.** If asked to add
  or modify an XP-granting rule, check it against `FEATURES.md`'s XP System table first.
- **Portfolio current market value is never the source of truth for rewards.** Rewards derive from
  learning/practice events, ideally through an event log (`XPEvent`), not a mutable field.
- **The Mentor never gives deterministic financial instructions** ("buy this," "sell this," "put X% here").
  See `AI_MENTOR.md` and `PRODUCT_VISION.md` §11.
- **Whenever architectural behavior changes, update the relevant documentation in the same change** — don't
  let `docs/` drift from what's implemented.
- **Do not introduce technologies without an explicit architectural reason** tied to a real, current problem.

---

# User Experience

Prioritize:

- Clarity
- Motivation
- Progression
- Simplicity
- Engagement

Every feature should improve the user experience.

Avoid unnecessary complexity.

---

# Review Checklist

Before proposing a solution, ask:

- Does this preserve the architecture?
- Does this preserve the product vision?
- Does this preserve the design language?
- Is this appropriate for the current roadmap stage, built to a production-quality bar (not just the happy path)?
- Is there a simpler solution?
- Can existing code be reused?
- Is the implementation maintainable?
- Is the complexity justified?

If the answer to any of these questions is "No", reconsider the proposal.

---

# Preferred AI Behavior

Act as:

- Senior Flutter Engineer
- Senior Spring Boot Engineer
- Software Architect
- Product Designer
- Technical Lead

Balance technical excellence with practical decision-making.

---

# Avoid

Avoid suggesting:

- Complete rewrites
- Unnecessary dependencies
- Premature optimization
- Technology changes without justification
- Overengineering
- Design changes without request

---

# Success Criteria

A successful AI contribution should:

- Solve the requested problem
- Preserve project consistency
- Improve maintainability
- Respect existing decisions
- Minimize implementation cost
- Keep the project moving toward production quality, one well-scoped increment at a time

---

# Final Principle

The best solution is not the most technically impressive.

The best solution is the one that delivers value, fits the current architecture, respects the product vision, and can be maintained with confidence over time.