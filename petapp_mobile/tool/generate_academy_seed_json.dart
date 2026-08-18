// One-time content migration: reads the current hardcoded Dart Academy
// catalog (AcademyDomainCatalog / AcademyCatalog / FinancialLifeCatalog,
// already merged by AcademyCatalog) in all 3 languages and emits the JSON
// seed files the backend's AcademyContentSeedRunner expects
// (PetApp-Backend/src/main/resources/academy-content/), instead of
// hand-transcribing ~4000 lines of lesson content.
//
// Run with: dart run tool/generate_academy_seed_json.dart
// Output:   tool/out/academy-content/{domains.json, schools/**/*.json}
//
// Deliberately reads via the public catalog getters (AcademyCatalog.schools,
// .modulesForSchool, .lessonsForModule) rather than the private per-language
// lists — this is the same surface the app itself uses, so the emitted JSON
// is guaranteed to match what users see today.
import 'dart:convert';
import 'dart:io';

import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_domain.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson_step.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_domain_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_icon_registry.dart';

const _langs = ['pt', 'en', 'es'];
const _outDir = 'tool/out/academy-content';

class _Snapshot {
  final List<AcademyDomain> domains;
  final List<School> schools;
  final Map<String, List<AcademyModule>> modulesBySchool;
  final Map<String, List<Lesson>> lessonsByModule;
  _Snapshot(this.domains, this.schools, this.modulesBySchool, this.lessonsByModule);
}

void main() {
  final snapshots = <String, _Snapshot>{};
  for (final lang in _langs) {
    Translator.languageNotifier.value = lang;
    final schools = AcademyCatalog.schools;
    final modulesBySchool = {for (final s in schools) s.id: AcademyCatalog.modulesForSchool(s.id)};
    final lessonsByModule = {
      for (final modules in modulesBySchool.values)
        for (final m in modules) m.id: AcademyCatalog.lessonsForModule(m.id),
    };
    snapshots[lang] = _Snapshot(AcademyDomainCatalog.domains, schools, modulesBySchool, lessonsByModule);
  }

  final warnings = <String>[];
  final pt = snapshots['pt']!;

  Directory(_outDir).createSync(recursive: true);
  Directory('$_outDir/schools').createSync(recursive: true);

  _writeDomains(pt, snapshots, warnings);
  for (final school in pt.schools) {
    _writeSchool(school, pt, snapshots, warnings);
  }

  if (warnings.isEmpty) {
    stdout.writeln('Generated academy-content JSON with no consistency warnings.');
  } else {
    stdout.writeln('Generated academy-content JSON with ${warnings.length} warning(s):');
    for (final w in warnings) {
      stdout.writeln('  - $w');
    }
  }
}

T? _byId<T>(List<T> items, String Function(T) idOf, String id) {
  for (final item in items) {
    if (idOf(item) == id) return item;
  }
  return null;
}

void _checkEqual(List<String> warnings, String context, Object? a, Object? b, String lang) {
  final same = a is List && b is List ? _listEquals(a, b) : a == b;
  if (!same) {
    warnings.add('$context differs between pt and $lang: $a vs $b');
  }
}

bool _listEquals(List a, List b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

void _writeDomains(_Snapshot pt, Map<String, _Snapshot> snapshots, List<String> warnings) {
  final domains = <Map<String, dynamic>>[];
  for (final domain in pt.domains) {
    final translations = <String, dynamic>{};
    for (final lang in _langs) {
      final match = _byId(snapshots[lang]!.domains, (d) => d.id, domain.id);
      if (match == null) {
        warnings.add('Domain ${domain.id} missing in $lang');
        continue;
      }
      if (lang != 'pt') {
        _checkEqual(warnings, 'Domain ${domain.id}.order', domain.order, match.order, lang);
        _checkEqual(warnings, 'Domain ${domain.id}.schoolIds', domain.schoolIds, match.schoolIds, lang);
      }
      translations[lang] = {'title': match.title, 'description': match.description};
    }
    domains.add({
      'domainId': domain.id,
      'order': domain.order,
      'iconKey': AcademyIconRegistry.keyFor(domain.icon),
      'translations': translations,
    });
  }
  _writeJson('$_outDir/domains.json', {'domains': domains});
}

void _writeSchool(School school, _Snapshot pt, Map<String, _Snapshot> snapshots, List<String> warnings) {
  final domainId = AcademyDomainCatalog.domainForSchool(school.id)?.id;
  if (domainId == null) {
    warnings.add('School ${school.id} has no owning domain — skipped');
    return;
  }

  final schoolTranslations = <String, dynamic>{};
  for (final lang in _langs) {
    final match = _byId(snapshots[lang]!.schools, (s) => s.id, school.id);
    if (match == null) {
      warnings.add('School ${school.id} missing in $lang');
      continue;
    }
    if (lang != 'pt') {
      _checkEqual(warnings, 'School ${school.id}.order', school.order, match.order, lang);
      _checkEqual(warnings, 'School ${school.id}.prerequisites', school.prerequisites, match.prerequisites, lang);
      _checkEqual(
        warnings,
        'School ${school.id}.contentAvailable',
        school.contentAvailable,
        match.contentAvailable,
        lang,
      );
    }
    schoolTranslations[lang] = {'title': match.title, 'description': match.description};
  }

  final modules = pt.modulesBySchool[school.id] ?? const <AcademyModule>[];
  final moduleJson = [for (final module in modules) _moduleJson(module, pt, snapshots, warnings)];

  final json = {
    'schoolId': school.id,
    'domainId': domainId,
    'order': school.order,
    'iconKey': AcademyIconRegistry.keyFor(school.icon),
    'contentAvailable': school.contentAvailable,
    'prerequisites': school.prerequisites,
    'translations': schoolTranslations,
    'modules': moduleJson,
  };

  _writeJson('$_outDir/schools/$domainId/${school.id}.json', json);
}

Map<String, dynamic> _moduleJson(
  AcademyModule module,
  _Snapshot pt,
  Map<String, _Snapshot> snapshots,
  List<String> warnings,
) {
  final translations = <String, dynamic>{};
  for (final lang in _langs) {
    final match = _byId(snapshots[lang]!.modulesBySchool[module.schoolId] ?? const [], (m) => m.id, module.id);
    if (match == null) {
      warnings.add('Module ${module.id} missing in $lang');
      continue;
    }
    if (lang != 'pt') {
      _checkEqual(warnings, 'Module ${module.id}.order', module.order, match.order, lang);
      _checkEqual(warnings, 'Module ${module.id}.prerequisites', module.prerequisites, match.prerequisites, lang);
      _checkEqual(
        warnings,
        'Module ${module.id}.contentAvailable',
        module.contentAvailable,
        match.contentAvailable,
        lang,
      );
    }
    translations[lang] = {'title': match.title, 'description': match.description};
  }

  final lessons = pt.lessonsByModule[module.id] ?? const <Lesson>[];
  final lessonJson = [for (final lesson in lessons) _lessonJson(lesson, module, snapshots, warnings)];

  return {
    'moduleId': module.id,
    'order': module.order,
    'iconKey': AcademyIconRegistry.keyFor(module.icon),
    'xpReward': _moduleXpReward(module),
    'contentAvailable': module.contentAvailable,
    'prerequisites': module.prerequisites,
    'translations': translations,
    'lessons': lessonJson,
  };
}

/// Module-completion XP bonus isn't on `AcademyModule` client-side (it's a
/// server-only concept today, see `learning_modules.xp_reward` seeded by
/// V4/V9) — reuse the same values already live in the server catalog so the
/// migration doesn't invent new bonus amounts.
int _moduleXpReward(AcademyModule module) {
  const knownModuleBonuses = {
    'investor_foundations': 100,
    'money_fundamentals': 100,
  };
  return knownModuleBonuses[module.id] ?? 0;
}

Map<String, dynamic> _lessonJson(
  Lesson lesson,
  AcademyModule module,
  Map<String, _Snapshot> snapshots,
  List<String> warnings,
) {
  final translations = <String, dynamic>{};
  for (final lang in _langs) {
    final match = _byId(snapshots[lang]!.lessonsByModule[module.id] ?? const [], (l) => l.id, lesson.id);
    if (match == null) {
      warnings.add('Lesson ${lesson.id} missing in $lang');
      continue;
    }
    if (lang != 'pt') {
      _checkEqual(warnings, 'Lesson ${lesson.id}.order', lesson.order, match.order, lang);
      _checkEqual(warnings, 'Lesson ${lesson.id}.xpReward', lesson.xpReward, match.xpReward, lang);
      _checkEqual(warnings, 'Lesson ${lesson.id}.stepCount', lesson.steps.length, match.steps.length, lang);
    }
    translations[lang] = {'title': match.title};
  }

  final steps = <Map<String, dynamic>>[];
  for (var i = 0; i < lesson.steps.length; i++) {
    steps.add(_stepJson(lesson, i, snapshots, warnings, module));
  }

  return {
    'lessonId': lesson.id,
    'order': lesson.order,
    'xpReward': lesson.xpReward,
    'translations': translations,
    'steps': steps,
  };
}

Map<String, dynamic> _stepJson(
  Lesson ptLesson,
  int index,
  Map<String, _Snapshot> snapshots,
  List<String> warnings,
  AcademyModule module,
) {
  final step = ptLesson.steps[index];
  final translations = <String, dynamic>{};

  for (final lang in _langs) {
    final matchLesson = _byId(snapshots[lang]!.lessonsByModule[module.id] ?? const [], (l) => l.id, ptLesson.id);
    if (matchLesson == null || index >= matchLesson.steps.length) {
      warnings.add('Lesson ${ptLesson.id} step #$index missing in $lang');
      continue;
    }
    final matchStep = matchLesson.steps[index];
    translations[lang] = _stepTranslation(matchStep);
  }

  return {
    'type': _stepType(step),
    'order': index + 1,
    if (step is ChoiceQuestionStep) 'framing': step.framing == ChoiceStepFraming.microExercise ? 'micro_exercise' : 'apply',
    if (step is ChoiceQuestionStep) 'correctIndex': step.correctIndex,
    'translations': translations,
  };
}

String _stepType(LessonStep step) => switch (step) {
      ExplanationStep() => 'explanation',
      ExampleStep() => 'example',
      ChoiceQuestionStep() => 'choice_question',
      SummaryStep() => 'summary',
    };

Map<String, dynamic> _stepTranslation(LessonStep step) => switch (step) {
      ExplanationStep(title: final t, body: final b) => {'title': t, 'body': b},
      ExampleStep(title: final t, body: final b) => {'title': t, 'body': b},
      ChoiceQuestionStep(prompt: final p, options: final o, explanation: final e) => {
          'prompt': p,
          'options': o,
          'explanation': e,
        },
      SummaryStep(title: final t, takeaways: final tk) => {'title': t, 'takeaways': tk},
    };

void _writeJson(String path, Object json) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));
}
