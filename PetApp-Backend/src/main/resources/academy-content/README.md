# Academy content

This directory is the authored source of truth for the Academy curriculum
(domains, schools, modules, lessons, steps) in pt/en/es. `AcademyContentSeedRunner`
reads every file here and upserts it into the database on every application
boot — see its Javadoc for the exact algorithm.

## Rules for editing this content

- **Ids are permanent.** `domainId`, `schoolId`, `moduleId`, `lessonId` are
  shared with `lesson_progress`/`xp_events.source_id` (a user's completion +
  XP history). Never rename or reuse one — a renamed id resets progress for
  everyone who completed it, and a reused id can grant XP twice or never.
- **To discontinue a school/module**, set `"contentAvailable": false` in its
  JSON. Do not delete its entry.
- **One file per school**, under `schools/{domainId}/{schoolId}.json`, each
  carrying its full module → lesson → step tree. `domains.json` lists the
  top-level domains.
- Steps, options, takeaways, translations and prerequisites have no id
  shared with user progress — the seeder deletes and fully reinserts them
  for their parent on every boot, so edit them freely.
- This directory is generated once from the legacy hardcoded Dart catalog by
  `petapp_mobile/tool/generate_academy_seed_json.dart`. New content from now
  on is authored directly as JSON here — that script is not meant to be run
  again.
