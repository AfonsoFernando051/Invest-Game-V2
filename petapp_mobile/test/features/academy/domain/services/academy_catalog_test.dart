import 'package:flutter_test/flutter_test.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';

/// Structural/integrity coverage for the curriculum data (`AcademyCatalog`
/// plus the sub-catalogs it aggregates, e.g. `FinancialLifeCatalog`) — this
/// is large hand-authored content, so rather than asserting every string,
/// these tests check the invariants the rest of the app relies on: no
/// dangling references, no duplicate ids, and parity across the three
/// supported languages.
void main() {
  for (final language in ['pt', 'en', 'es']) {
    group('AcademyCatalog ($language)', () {
      setUp(() => Translator.currentLanguage = language);

      test('has at least one school and one module', () {
        expect(AcademyCatalog.schools, isNotEmpty);
        expect(AcademyCatalog.modules, isNotEmpty);
      });

      test('every module references a school that actually exists', () {
        final schoolIds = AcademyCatalog.schools.map((s) => s.id).toSet();
        for (final module in AcademyCatalog.modules) {
          expect(schoolIds.contains(module.schoolId), isTrue, reason: 'module ${module.id} references unknown school ${module.schoolId}');
        }
      });

      test('every lessonId a module declares resolves to a real lesson in that module', () {
        for (final module in AcademyCatalog.modules) {
          for (final lessonId in module.lessonIds) {
            final lesson = AcademyCatalog.lessonById(lessonId);
            expect(lesson, isNotNull, reason: 'module ${module.id} declares missing lesson $lessonId');
            expect(lesson!.moduleId, module.id, reason: 'lesson $lessonId claims a different moduleId than $module.id declares it under');
          }
        }
      });

      test('module ids are unique', () {
        final ids = AcademyCatalog.modules.map((m) => m.id).toList();
        expect(ids.toSet().length, ids.length);
      });

      test('school ids are unique', () {
        final ids = AcademyCatalog.schools.map((s) => s.id).toList();
        expect(ids.toSet().length, ids.length);
      });

      test('lesson ids are unique across the whole catalog', () {
        final ids = AcademyCatalog.modules.expand((m) => m.lessonIds).toList();
        expect(ids.toSet().length, ids.length);
      });

      test('every module prerequisite references a real module', () {
        final moduleIds = AcademyCatalog.modules.map((m) => m.id).toSet();
        for (final module in AcademyCatalog.modules) {
          for (final prereq in module.prerequisites) {
            expect(moduleIds.contains(prereq), isTrue, reason: '${module.id} has an unknown prerequisite $prereq');
          }
        }
      });

      test('every school prerequisite references a real school', () {
        final schoolIds = AcademyCatalog.schools.map((s) => s.id).toSet();
        for (final school in AcademyCatalog.schools) {
          for (final prereq in school.prerequisites) {
            expect(schoolIds.contains(prereq), isTrue, reason: '${school.id} has an unknown prerequisite $prereq');
          }
        }
      });

      test('every content-available module has at least one lesson', () {
        for (final module in AcademyCatalog.modules.where((m) => m.contentAvailable)) {
          expect(module.lessonIds, isNotEmpty, reason: '${module.id} is contentAvailable but has no lessons');
        }
      });
    });
  }

  group('modulesForSchool', () {
    test('returns only modules belonging to that school, matching modules order', () {
      final school = AcademyCatalog.schools.first;
      final modules = AcademyCatalog.modulesForSchool(school.id);
      for (final module in modules) {
        expect(module.schoolId, school.id);
      }
      final sorted = [...modules]..sort((a, b) => a.order.compareTo(b.order));
      expect(modules, sorted);
    });

    test('returns an empty list for an unknown school id', () {
      expect(AcademyCatalog.modulesForSchool('does-not-exist'), isEmpty);
    });
  });

  group('lessonsForModule', () {
    test('returns lessons in ascending order', () {
      final module = AcademyCatalog.modules.firstWhere((m) => m.lessonIds.length > 1);
      final lessons = AcademyCatalog.lessonsForModule(module.id);
      for (var i = 1; i < lessons.length; i++) {
        expect(lessons[i].order, greaterThanOrEqualTo(lessons[i - 1].order));
      }
    });
  });

  group('moduleById / lessonById / schoolById', () {
    test('return null for unknown ids instead of throwing', () {
      expect(AcademyCatalog.moduleById('nope'), isNull);
      expect(AcademyCatalog.lessonById('nope'), isNull);
      expect(AcademyCatalog.schoolById('nope'), isNull);
    });

    test('resolve real ids to the matching entity', () {
      final module = AcademyCatalog.modules.first;
      expect(AcademyCatalog.moduleById(module.id)?.id, module.id);
    });
  });

  group('xpEarnedFor', () {
    test('is 0 for an empty completed set', () {
      expect(AcademyCatalog.xpEarnedFor({}), 0);
    });

    test('sums the xpReward of every completed lesson, using the pt catalog as the XP source of truth', () {
      Translator.currentLanguage = 'pt';
      final firstLesson = AcademyCatalog.modules.expand((m) => AcademyCatalog.lessonsForModule(m.id)).first;

      expect(AcademyCatalog.xpEarnedFor({firstLesson.id}), firstLesson.xpReward);
    });
  });
}
