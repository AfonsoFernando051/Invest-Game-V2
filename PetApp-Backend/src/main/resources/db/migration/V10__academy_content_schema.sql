-- Schema for the full Academy curriculum content (domains, schools, modules,
-- lessons, steps, choice-question options, summary takeaways) plus their
-- pt/en/es translations. Structural data (ids, order, xpReward, icon,
-- prerequisites, contentAvailable) is language-independent and lives in
-- these tables; text lives in the paired "_translations" tables, one row
-- per (entity, lang).
--
-- Schema only — no seed data. Content is loaded by AcademyContentSeedRunner
-- from JSON files under src/main/resources/academy-content/ on every boot
-- (idempotent upsert by natural id), not by hardcoded INSERTs in migrations.
-- See docs/ACADEMY_ENGINE.md and academy-content/README.md.
--
-- learning_modules/learning_lessons already exist (V4/V9) and are the
-- server's authoritative id+XP catalog used by CompleteLessonUseCaseImpl/
-- GetLearningProgressUseCaseImpl — extended here, not duplicated. The new
-- columns are nullable because those tables already hold rows seeded by
-- V4/V9; AcademyContentSeedRunner fills them on boot, before the app
-- accepts traffic, so in practice they're never null once a request lands.

create table academy_domains (
    domain_id   varchar(64) not null,
    order_index integer not null,
    icon_key    varchar(64) not null,
    primary key (domain_id)
);

create table academy_domain_translations (
    domain_id   varchar(64) not null,
    lang        varchar(2) not null check (lang in ('pt', 'en', 'es')),
    title       varchar(255) not null,
    description varchar(1000) not null,
    primary key (domain_id, lang),
    constraint fk_academy_domain_translations_domain
        foreign key (domain_id) references academy_domains (domain_id) on delete cascade
);

create table academy_schools (
    school_id          varchar(64) not null,
    domain_id          varchar(64) not null,
    order_index        integer not null,
    icon_key           varchar(64) not null,
    content_available  boolean not null default false,
    primary key (school_id),
    constraint fk_academy_schools_domain
        foreign key (domain_id) references academy_domains (domain_id)
);

create table academy_school_translations (
    school_id   varchar(64) not null,
    lang        varchar(2) not null check (lang in ('pt', 'en', 'es')),
    title       varchar(255) not null,
    description varchar(1000) not null,
    primary key (school_id, lang),
    constraint fk_academy_school_translations_school
        foreign key (school_id) references academy_schools (school_id) on delete cascade
);

create table academy_school_prerequisites (
    school_id              varchar(64) not null,
    prerequisite_school_id varchar(64) not null,
    primary key (school_id, prerequisite_school_id),
    constraint fk_academy_school_prereq_school
        foreign key (school_id) references academy_schools (school_id) on delete cascade,
    constraint fk_academy_school_prereq_prereq
        foreign key (prerequisite_school_id) references academy_schools (school_id)
);

-- Extend the existing server-owned validation/XP catalog with the
-- structural fields needed to render the curriculum tree (icon, ordering
-- context via school, and "coming soon" gating). Nullable — see header.
alter table learning_modules add column school_id varchar(64);
alter table learning_modules add column icon_key varchar(64);
alter table learning_modules add column content_available boolean not null default false;

alter table learning_modules
    add constraint fk_learning_modules_school
        foreign key (school_id) references academy_schools (school_id);

create table academy_module_translations (
    module_id   varchar(64) not null,
    lang        varchar(2) not null check (lang in ('pt', 'en', 'es')),
    title       varchar(255) not null,
    description varchar(1000) not null,
    primary key (module_id, lang),
    constraint fk_academy_module_translations_module
        foreign key (module_id) references learning_modules (module_id) on delete cascade
);

create table academy_module_prerequisites (
    module_id              varchar(64) not null,
    prerequisite_module_id varchar(64) not null,
    primary key (module_id, prerequisite_module_id),
    constraint fk_academy_module_prereq_module
        foreign key (module_id) references learning_modules (module_id) on delete cascade,
    constraint fk_academy_module_prereq_prereq
        foreign key (prerequisite_module_id) references learning_modules (module_id)
);

create table academy_lesson_translations (
    lesson_id varchar(64) not null,
    lang      varchar(2) not null check (lang in ('pt', 'en', 'es')),
    title     varchar(255) not null,
    primary key (lesson_id, lang),
    constraint fk_academy_lesson_translations_lesson
        foreign key (lesson_id) references learning_lessons (lesson_id) on delete cascade
);

-- Steps are a small closed set of 4 shapes — modeled as one table with a
-- discriminator + nullable columns (no JPA @Inheritance, consistent with
-- the rest of the backend having no ORM inheritance anywhere) rather than
-- a satellite table per type. The primary key is the natural
-- (lesson_id, step_order) pair, not a generated id — that's what makes the
-- seeder's upsert idempotent without having to look up a previously
-- generated id.
create table academy_lesson_steps (
    lesson_id             varchar(64) not null,
    step_order            integer not null,
    step_type             varchar(32) not null
        check (step_type in ('EXPLANATION', 'EXAMPLE', 'CHOICE_QUESTION', 'SUMMARY')),
    framing               varchar(32) check (framing in ('MICRO_EXERCISE', 'APPLY')),
    correct_option_index  integer,
    primary key (lesson_id, step_order),
    constraint fk_academy_lesson_steps_lesson
        foreign key (lesson_id) references learning_lessons (lesson_id) on delete cascade
);

create table academy_lesson_step_translations (
    lesson_id   varchar(64) not null,
    step_order  integer not null,
    lang        varchar(2) not null check (lang in ('pt', 'en', 'es')),
    title       varchar(255),
    body        varchar(2000),
    prompt      varchar(1000),
    explanation varchar(1000),
    primary key (lesson_id, step_order, lang),
    constraint fk_academy_lesson_step_translations_step
        foreign key (lesson_id, step_order) references academy_lesson_steps (lesson_id, step_order) on delete cascade
);

create table academy_choice_question_options (
    lesson_id  varchar(64) not null,
    step_order integer not null,
    position   integer not null,
    primary key (lesson_id, step_order, position),
    constraint fk_academy_choice_options_step
        foreign key (lesson_id, step_order) references academy_lesson_steps (lesson_id, step_order) on delete cascade
);

create table academy_choice_question_option_translations (
    lesson_id   varchar(64) not null,
    step_order  integer not null,
    position    integer not null,
    lang        varchar(2) not null check (lang in ('pt', 'en', 'es')),
    option_text varchar(500) not null,
    primary key (lesson_id, step_order, position, lang),
    constraint fk_academy_choice_option_translations_option
        foreign key (lesson_id, step_order, position)
        references academy_choice_question_options (lesson_id, step_order, position) on delete cascade
);

create table academy_lesson_step_takeaways (
    lesson_id  varchar(64) not null,
    step_order integer not null,
    position   integer not null,
    primary key (lesson_id, step_order, position),
    constraint fk_academy_lesson_step_takeaways_step
        foreign key (lesson_id, step_order) references academy_lesson_steps (lesson_id, step_order) on delete cascade
);

create table academy_lesson_step_takeaway_translations (
    lesson_id     varchar(64) not null,
    step_order    integer not null,
    position      integer not null,
    lang          varchar(2) not null check (lang in ('pt', 'en', 'es')),
    takeaway_text varchar(500) not null,
    primary key (lesson_id, step_order, position, lang),
    constraint fk_academy_takeaway_translations_takeaway
        foreign key (lesson_id, step_order, position)
        references academy_lesson_step_takeaways (lesson_id, step_order, position) on delete cascade
);
