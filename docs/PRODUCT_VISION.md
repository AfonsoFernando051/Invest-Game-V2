# PRODUCT_VISION.md

# Invest Game V2 — Product Vision

## Document role

This is the **source of truth for what Invest Game V2 is and why it exists.** Every other document in
`docs/` — architecture, features, roadmap, design — must be consistent with what is written here. When a
document conflicts with this one, this one wins, and the other document should be corrected.

This file replaces the previous `PRODUCT_VISION.md`, which was a stray duplicate of `AI_RULES.md` and carried
no actual product content.

> **Relationship to the original Pet Invest App:** Invest Game V2 is derived from the `Pet-Invest-App` MVP but
> is a **separate product and architecture initiative** with a different product philosophy. The original MVP
> is preserved in its own repository and should be treated as historical context and a technical reference,
> not as this product's specification. See `PROJECT_CONTEXT.md` for the full relationship.

---

## 1. The core principle

> **LEARN → PRACTICE → PROGRESS → GROW**

```text
                    INVEST GAME
                         |
          +--------------+--------------+
          |              |              |
          v              v              v
       LEARNING       PORTFOLIO     GAMIFICATION
          |              |              |
       Knowledge       Practice         XP
       Lessons         Assets           Levels
       Quizzes        Transactions      Missions
       Progress       Analysis          Rewards
          |              |              |
          +--------------+--------------+
                         |
                         v
                        PET
                         |
                         v
                    MOTIVATION
                         |
                         +-------> LEARNING
```

The product is **not** documented as an investment-simulation game with education bolted on. It is a learning
product whose practice environment happens to be a portfolio, whose retention mechanism happens to be
gamification, and whose emotional anchor happens to be a pet.

---

## 2. Problem

Most beginners who want to start investing run into the same wall:

- They don't know **what** to study first.
- They don't know **in what order** concepts build on each other.
- They have no way to know whether they actually **understood** a concept, versus just having read about it.
- They can't connect financial theory to **their own, real financial decisions** — lessons stay abstract.
- Existing options are polarized: dense financial content made for professionals, or gamified apps that
  entertain without teaching anything durable.

## 3. Solution

Invest Game provides:

- A structured, progressive **learning path** (Academy) instead of a wall of articles.
- **Interactive lessons** with explanations, examples, and micro-exercises rather than long-form reading.
- **Quizzes** that check understanding, with encouraging (never punitive) feedback.
- **Educational challenges** that connect a concept to a real, held asset.
- A **portfolio** that acts as the practice environment where lessons become concrete.
- **XP and levels** that reward the act of learning and practicing, not the size of a portfolio.
- An **evolving pet** that visualizes the learner's journey.
- A **contextual AI mentor** that tutors inside the learning flow, not a robo-advisor.

### Core promise

> **Learn investing step by step, put the knowledge into practice, and watch your companion grow with you.**

---

## 4. Product positioning

The product has four layers, and the order between them is deliberate — it is not a list of equal pillars.

| Layer | Role | Examples |
|---|---|---|
| **Primary** | Investment education | Academy, learning paths, lessons, quizzes |
| **Secondary** | Portfolio practice & tracking | Holdings, transactions, allocation, dividends |
| **Motivation layer** | Gamification & pets | XP, levels, missions, achievements, pet evolution |
| **Support layer** | AI Mentor | Contextual tutoring grounded in the learning + portfolio state |

The learning experience is primary. The portfolio exists to make learning concrete. Gamification exists to
keep the learner coming back. The pet exists to make progress feel emotionally real. None of the lower layers
should be documented, designed, or built as if they were the point of the product.

---

## 5. Target audience

### Primary

Young adults and beginner investors, roughly 18–35, who:

- want to start investing but haven't yet;
- have limited financial literacy;
- already consume educational content online (videos, short-form, social);
- feel overwhelmed by fragmented, jargon-heavy financial information;
- respond well to interactive, bite-sized learning;
- want visible, structured progress;
- are motivated by game mechanics (streaks, levels, collectibles).

### Secondary

Early-stage investors who already hold assets but want to organize and deepen their knowledge rather than
learn from zero.

### Explicit non-goals

The product is **not** initially designed for:

- professional or institutional traders;
- advanced quantitative users;
- professional analysts;
- users seeking trading signals or alpha;
- users looking for direct execution of financial transactions.

These exclusions are deliberate. Building for them would pull the product away from its educational core.

---

## 6. Core loop

```text
OPEN APP
   ↓
SEE PROGRESS
   ↓
CONTINUE LESSON
   ↓
LEARN
   ↓
PRACTICE / QUIZ
   ↓
EARN XP
   ↓
PET PROGRESSES
   ↓
UNLOCK NEW CONTENT
   ↓
APPLY KNOWLEDGE TO PORTFOLIO
   ↓
RECEIVE EDUCATIONAL FEEDBACK
   ↓
RETURN TO LEARNING
```

**Product rule:** features that do not strengthen learning, practice, progression, or retention require
explicit justification before being added. When proposing a feature, name which step of this loop it
strengthens. If it doesn't strengthen any step, reconsider it.

---

## 7. Navigation (target)

- **Home** — personal learning dashboard (see §8).
- **Learn** — the Academy / learning journey.
- **Portfolio** — the practical investment environment.
- **Pet** — companion progression and customization.

Profile and settings live outside the primary navigation. The Mentor is primarily a **contextual** tool, not
necessarily a top-level tab — it should be reachable from wherever the user needs tutoring (a lesson, an asset
screen, a quiz mistake), not treated as a fifth, disconnected destination.

> **Current implementation gap:** the shipped bottom navigation
> (`petapp_mobile/lib/features/dashboard/presentation/screens/dashboard_screen.dart`) has five tabs — Home,
> Carteira (Wallet), Proventos (Passive Income), Academia, Mentor — with the Pet surfaced only as a widget on
> Home, and Mentor as a standing top-level tab. This is pre-existing MVP-era navigation and is **not being
> changed by this documentation pass** (no code changes here). It is recorded as a target-navigation gap for a
> future Beta-stage pass — see `ARCHITECTURE.md`'s Current vs Target notes and `ROADMAP.md`.

## 8. Home

Home is the central orchestration layer of the product. It should answer, in this priority order:

1. **What am I learning?** — continue-lesson CTA.
2. **How am I progressing?** — XP / level.
3. **How is my companion doing?** — pet progression.
4. **What should I do next?** — daily/weekly mission.
5. **How is my practical portfolio doing?** — a snapshot, not a dashboard.
6. **What should I look at, based on what I've learned?** — a personalized educational recommendation.

Financial performance must never dominate Home. A user opening the app should see their learning progress
before their portfolio's percentage change.

---

## 9. Knowledge progress vs. game level

These are two different things and must never be conflated in product copy, design, or logic:

```text
Knowledge Progress               XP
     ↓                            ↓
Educational readiness      Motivational progression
                                   ↓
                          Pet progression / rewards
```

- **Knowledge Progress** — how much of the educational curriculum the user has actually completed and
  demonstrated understanding of (lessons completed, quizzes passed).
- **Game Level** — a motivational progression derived from accumulated XP.

**Level 20 does not mean "advanced investor."** It means the user has been consistently active and completing
learning/practice activities. Product copy, onboarding, and the Mentor must never imply that a game level is a
certification of financial competence.

---

## 10. Product differentiation

The strongest differentiation is **not** "it has a pet." It is:

> **The user's learning journey is connected to a practical investment portfolio and a persistent gamified
> progression system.**

```text
Learn
 ↓
Understand
 ↓
Practice
 ↓
See the concept show up in the portfolio
 ↓
Earn XP
 ↓
Pet progresses
 ↓
Continue learning
```

The pet makes the loop emotionally engaging. The learning ↔ portfolio connection (see `ACADEMY_ENGINE.md` §
"Educational Portfolio Intelligence") is the deeper, harder-to-copy differentiator.

---

## 11. Safety / financial product boundaries

Invest Game V2 is, and should always be documented as:

> **Financial education + portfolio tracking/practice.**

It is **not**, at least not in this stage of the product:

- a broker;
- an execution platform;
- a trading-signal engine;
- an automated investment adviser.

The product must always distinguish an educational explanation from personalized financial advice. When the
Mentor discusses a user's portfolio, it should prioritize explanation, education, transparency, and risk
awareness over instruction. Deterministic directives — "buy this," "sell this," "put 70% here" — are out of
scope unless a future, explicit product and legal decision authorizes them. See `AI_MENTOR.md` for the
Mentor's full behavioral contract.

---

## 12. Guiding question

Every product, design, and engineering decision should be able to answer:

> **Does this strengthen learning, practice, progression, or the emotional connection to the pet — without
> encouraging unhealthy financial behavior?**

If the honest answer is no, reconsider the decision.
