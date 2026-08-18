# ACADEMY_CONTENT_AUTHORING.md

# How to add Academy content with an AI's help

Since DECISION-022 (see `DECISIONS.md`), the Academy curriculum lives in the backend database, authored as JSON
files under `PetApp-Backend/src/main/resources/academy-content/` and loaded by `AcademyContentSeedRunner` on
every boot. This document is a copy-pasteable workflow for drafting new content with an auxiliary AI (Claude,
ChatGPT, or any other) and getting it into the project — see `ACADEMY_ENGINE.md` §3e for the architecture, and
`academy-content/README.md` for the file-format rules this document assumes.

---

## 1. Decide what you're adding

| You want to... | Do this |
|---|---|
| Add a lesson to a module that already has content | Edit the existing school's JSON file, append to that module's `lessons` array |
| Fill in a module that's currently `"contentAvailable": false` (a placeholder — most modules are this today) | Edit the existing school's JSON file, author `lessons`, flip `contentAvailable` to `true` on the module |
| Add a brand-new module to an existing school | Edit the existing school's JSON file, add a new object to `modules` |
| Add a brand-new school | Create `schools/{domainId}/{schoolId}.json` |
| Add a brand-new domain | Add an entry to `domains.json` (rare — there are already 8) |

Check what already exists before creating anything new — most of the curriculum's "skeleton" (19 schools, 14
modules) is already there as empty placeholders, just waiting for lessons:

```bash
find PetApp-Backend/src/main/resources/academy-content/schools -name '*.json' \
  -exec python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d['schoolId'], d['domainId'], 'contentAvailable=' + str(d['contentAvailable']))" {} \;
```

## 2. Generate the content with an AI

Copy the prompt block below, fill in the `<<...>>` placeholders with what you want, and paste it into an
auxiliary AI session (a fresh one — it doesn't need this repo's context, just this prompt).

<details>
<summary><strong>Click to expand the prompt template</strong></summary>

````
You are drafting curriculum content for a financial education app's "Academy" feature. I need you to output
ONLY a JSON object (or array of step objects, if I ask for steps only) — no explanation, no markdown fences,
just the raw JSON.

TOPIC: <<describe what this lesson/module should teach, e.g. "how CDBs and LCIs work, and the difference
between them">>

WHERE THIS GOES: <<e.g. "a new lesson in the existing 'fixed_income' school/module" or "a brand-new module
called X in school Y">>

## Content rules (non-negotiable)

- Write in three languages: pt (Brazilian Portuguese), en (English), es (Spanish) — every one of them, in full,
  not machine-translated filler. Keep tone, examples and numbers consistent across all three.
- Tone: encouraging, plain language, teaches the user to *investigate* concepts (why something works, what
  trade-offs it has) rather than memorize definitions or receive buy/sell advice. Never give financial advice
  or imply a specific investment is good/bad — explain mechanisms, not verdicts.
- No-punishment: a wrong quiz answer is never framed as a failure. `explanation` text should be neutral/
  educational ("here's why"), never shaming, regardless of whether the option chosen was right or wrong.
- Each lesson is a short unit (2–5 minutes): 1 `explanation` step, 1 `example` step, 1–2 `choice_question`
  steps, 1 `summary` step is the typical shape — see the example lesson below.
- `choice_question` options: exactly one correct answer, plausible-but-wrong distractors (not joke answers),
  4 options is typical (2 is fine for a true/false-style question). `explanation` must justify the correct
  answer clearly enough to teach even someone who got it wrong.
- `framing`: use `"micro_exercise"` for a question testing recall of what was just explained, `"apply"` for a
  question asking the learner to reason about a new situation using the same concept.
- Every `order` field is a 1-based integer, sequential within its parent (steps within a lesson, lessons
  within a module, modules within a school).
- Keep `lessonId`/`moduleId`/`schoolId` values as short, stable, lowercase_snake_case English slugs describing
  the content (e.g. `fixed_income_what_is_a_cdb`) — these ids are permanent once shipped, never renamed.

## Exact JSON shape to produce

A lesson looks like this (fill in real content, keep every key, keep the exact structure):

```json
{{EXAMPLE_LESSON_JSON}}
```

A `explanation`/`example` step only has `title`+`body` per language. A `summary` step only has `title`+
`takeaways` (a list of short bullet strings) per language. A `choice_question` step has `framing` and
`correctIndex` at the top level (not per-language) plus `prompt`/`options`/`explanation` per language.

If I asked for a whole new MODULE (not just a lesson), wrap it like this instead:

```json
{
  "moduleId": "<<slug>>",
  "order": <<int>>,
  "iconKey": "<<one of: account_balance_outlined, account_balance_wallet_outlined, analytics_outlined,
    bar_chart_outlined, beach_access_outlined, calculate_outlined, candlestick_chart_outlined,
    credit_card_outlined, currency_bitcoin, dashboard_customize_outlined, explore_outlined, flag_outlined,
    gavel_outlined, gpp_maybe_outlined, health_and_safety_outlined, insights_outlined, map_outlined,
    payments_outlined, pie_chart_outline, psychology_outlined, public, public_outlined, query_stats_outlined,
    receipt_long_outlined, rocket_launch_outlined, savings_outlined, shield_outlined, shopping_bag_outlined,
    show_chart, speed_outlined, timeline_outlined, trending_down, trending_up — do not invent a new one>>",
  "xpReward": <<int, module-completion bonus — 100 is the existing convention for a real module>>,
  "contentAvailable": true,
  "prerequisites": [],
  "translations": {
    "pt": {"title": "...", "description": "..."},
    "en": {"title": "...", "description": "..."},
    "es": {"title": "...", "description": "..."}
  },
  "lessons": [ /* one or more lesson objects, shape above, xpReward 20 each is the existing convention */ ]
}
```

Now generate the content.
````

</details>

Before pasting, replace `{{EXAMPLE_LESSON_JSON}}` with a real example — the block below (an actual shipped
lesson) works well:

<details>
<summary><strong>Click to expand the example lesson JSON to paste in</strong></summary>

```json
{
  "lessonId": "money_fundamentals_what_is_money",
  "order": 1,
  "xpReward": 20,
  "translations": {
    "pt": {"title": "O que é Dinheiro?"},
    "en": {"title": "What Is Money?"},
    "es": {"title": "¿Qué es el Dinero?"}
  },
  "steps": [
    {
      "type": "explanation",
      "order": 1,
      "translations": {
        "pt": {"title": "As três funções do dinheiro", "body": "Dinheiro é qualquer coisa amplamente aceita para trocar por bens e serviços. Ele cumpre três funções: é meio de troca, reserva de valor e unidade de conta. Antes do dinheiro, as pessoas trocavam bens diretamente — o escambo — mas isso só funciona quando as duas partes querem exatamente o que a outra tem."},
        "en": {"title": "Money's three jobs", "body": "Money is anything widely accepted in exchange for goods and services. It does three jobs: medium of exchange, store of value, and unit of account. Before money, people traded goods directly — bartering — but that only works when both sides happen to want exactly what the other has."},
        "es": {"title": "Las tres funciones del dinero", "body": "El dinero es cualquier cosa ampliamente aceptada para intercambiar por bienes y servicios. Cumple tres funciones: medio de intercambio, reserva de valor y unidad de cuenta. Antes del dinero, las personas intercambiaban bienes directamente — el trueque —, pero eso solo funciona cuando ambas partes quieren exactamente lo que la otra tiene."}
      }
    },
    {
      "type": "example",
      "order": 2,
      "translations": {
        "pt": {"title": "Na prática", "body": "Imagine que você corta cabelo e precisa de ovos. No escambo, você só consegue os ovos se encontrar alguém que cria galinhas e precisa cortar o cabelo naquele dia. Com dinheiro, você corta o cabelo de qualquer cliente e compra ovos de quem quer que os venda."},
        "en": {"title": "In practice", "body": "Imagine you're a barber and you need eggs. With barter, you only get the eggs if you find someone who raises chickens and also needs a haircut that same day. With money, you cut any customer's hair and buy eggs from whoever sells them."},
        "es": {"title": "En la práctica", "body": "Imagina que cortas cabello y necesitas huevos. Con el trueque, solo consigues los huevos si encuentras a alguien que críe gallinas y necesite cortarse el cabello ese mismo día. Con dinero, le cortas el cabello a cualquier cliente y compras huevos a quien sea que los venda."}
      }
    },
    {
      "type": "choice_question",
      "order": 3,
      "framing": "micro_exercise",
      "correctIndex": 1,
      "translations": {
        "pt": {
          "prompt": "Por que o escambo é difícil de sustentar em uma economia grande?",
          "options": ["Porque bens não podem ser trocados entre desconhecidos", "Porque exige encontrar alguém que queira exatamente o que você oferece, no momento certo", "Porque é ilegal na maioria dos países", "Porque bens não têm valor sem dinheiro"],
          "explanation": "O escambo depende da \"dupla coincidência de desejos\". O dinheiro elimina essa exigência."
        },
        "en": {
          "prompt": "Why is bartering hard to sustain in a large economy?",
          "options": ["Because goods can't be exchanged between strangers", "Because it requires finding someone who wants exactly what you offer, at the right time", "Because it's illegal in most countries", "Because goods have no value without money"],
          "explanation": "Barter depends on a \"double coincidence of wants\". Money removes that requirement."
        },
        "es": {
          "prompt": "¿Por qué es difícil sostener el trueque en una economía grande?",
          "options": ["Porque los bienes no pueden intercambiarse entre desconocidos", "Porque exige encontrar a alguien que quiera exactamente lo que ofreces, en el momento justo", "Porque es ilegal en la mayoría de los países", "Porque los bienes no tienen valor sin dinero"],
          "explanation": "El trueque depende de una \"doble coincidencia de deseos\". El dinero elimina ese requisito."
        }
      }
    },
    {
      "type": "summary",
      "order": 4,
      "translations": {
        "pt": {"title": "O que você aprendeu", "takeaways": ["Dinheiro é meio de troca, reserva de valor e unidade de conta.", "O escambo exige uma coincidência de interesses difícil de sustentar em escala."]},
        "en": {"title": "What you learned", "takeaways": ["Money is a medium of exchange, a store of value, and a unit of account.", "Barter requires a coincidence of interests that's hard to sustain at scale."]},
        "es": {"title": "Lo que aprendiste", "takeaways": ["El dinero es medio de intercambio, reserva de valor y unidad de cuenta.", "El trueque exige una coincidencia de intereses difícil de sostener a gran escala."]}
      }
    }
  ]
}
```

</details>

## 3. Review the AI's output before saving it

Never paste an AI's content straight in unreviewed. Check:

- [ ] Valid JSON (paste into `python3 -m json.tool` or any JSON linter).
- [ ] All 3 languages present at every level, and actually saying the same thing (not machine-translated
      nonsense in one of them).
- [ ] `choice_question.correctIndex` really points at the correct option — AIs get this wrong sometimes.
- [ ] No financial advice or "you should buy/avoid X" framing — mechanisms and trade-offs only.
- [ ] `iconKey` is one of the existing keys (see the prompt's list) — an unknown key silently falls back to a
      generic icon in the app rather than erroring, so a typo won't fail loudly.
- [ ] Ids are new (not reusing an existing `lessonId`/`moduleId`/`schoolId` by accident) and follow the
      snake_case slug convention.
- [ ] Tone matches the existing example — encouraging, no shame for a wrong answer.

## 4. Add it to the project

1. Save the JSON into the right file — see the table in step 1.
2. Validate + boot the backend locally and check the API, then update `AcademyContentSeedRunnerTest`'s row
   counts, then deploy — the full mechanics of this are in `academy-content/README.md`'s "Adding new content"
   section (don't duplicate it here).

## Reference: full schema per level

See `academy-content/README.md` for the file-organization rules, and any existing file under
`academy-content/schools/` for more real examples — `financial_life.json` (the `money_fundamentals` module) is
the most complete one today.
