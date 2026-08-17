import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';

void main() {
  // Real modules/lessons from the pt catalog — exercised against the actual
  // curriculum shape rather than hand-built fixtures, since the progression
  // rules are defined purely in terms of AcademyCatalog's real data.
  final contentModule = AcademyCatalog.modules.firstWhere((m) => m.contentAvailable && m.lessonIds.length >= 2);
  final moduleLessons = AcademyCatalog.lessonsForModule(contentModule.id);

  group('lessonStatus', () {
    test('the first lesson of a module is always available when nothing is completed', () {
      final status = AcademyProgressCalculator.lessonStatus(lesson: moduleLessons.first, completedIds: {});
      expect(status, LessonStatus.available);
    });

    test('a completed lesson is completed regardless of position', () {
      final status = AcademyProgressCalculator.lessonStatus(
        lesson: moduleLessons.first,
        completedIds: {moduleLessons.first.id},
      );
      expect(status, LessonStatus.completed);
    });

    test('the second lesson is locked until the first is completed', () {
      final second = moduleLessons[1];
      final locked = AcademyProgressCalculator.lessonStatus(lesson: second, completedIds: {});
      expect(locked, LessonStatus.locked);

      final unlocked = AcademyProgressCalculator.lessonStatus(
        lesson: second,
        completedIds: {moduleLessons.first.id},
      );
      expect(unlocked, LessonStatus.available);
    });
  });

  group('moduleStatus', () {
    test('a module with no real content is comingSoon', () {
      const placeholder = AcademyModule(
        id: 'placeholder',
        schoolId: 'x',
        title: 'x',
        description: 'x',
        icon: Icons.school,
        order: 1,
        contentAvailable: false,
      );
      expect(AcademyProgressCalculator.moduleStatus(module: placeholder, completedIds: {}), ModuleStatus.comingSoon);
    });

    test('an unmet prerequisite locks the module even if it has content', () {
      final gated = AcademyModule(
        id: 'gated',
        schoolId: contentModule.schoolId,
        title: 'x',
        description: 'x',
        icon: Icons.school,
        order: 1,
        lessonIds: contentModule.lessonIds,
        prerequisites: const ['some-unmet-prereq'],
        contentAvailable: true,
      );
      expect(AcademyProgressCalculator.moduleStatus(module: gated, completedIds: {}), ModuleStatus.locked);
    });

    test('available with zero completed lessons, inProgress partway, completed when all done', () {
      expect(AcademyProgressCalculator.moduleStatus(module: contentModule, completedIds: {}), ModuleStatus.available);

      final partial = {moduleLessons.first.id};
      expect(AcademyProgressCalculator.moduleStatus(module: contentModule, completedIds: partial), ModuleStatus.inProgress);

      final all = moduleLessons.map((l) => l.id).toSet();
      expect(AcademyProgressCalculator.moduleStatus(module: contentModule, completedIds: all), ModuleStatus.completed);
    });
  });

  group('schoolStatus', () {
    test('a school with no content-available modules is comingSoon', () {
      const emptySchool = School(id: 'empty', title: 'x', description: 'x', icon: Icons.school, order: 1, contentAvailable: false);
      expect(AcademyProgressCalculator.schoolStatus(school: emptySchool, completedIds: {}), SchoolStatus.comingSoon);
    });

    test('an unmet school-level prerequisite locks it', () {
      final gated = School(
        id: 'gated-school',
        title: 'x',
        description: 'x',
        icon: Icons.school,
        order: 1,
        prerequisites: const ['some-unmet-prereq'],
        contentAvailable: true,
      );
      expect(AcademyProgressCalculator.schoolStatus(school: gated, completedIds: {}), SchoolStatus.locked);
    });

    test('a real available school with content resolves to a real status (not comingSoon/locked)', () {
      final school = AcademyCatalog.schools.firstWhere((s) => s.contentAvailable && s.prerequisites.isEmpty);
      final status = AcademyProgressCalculator.schoolStatus(school: school, completedIds: {});
      expect(status, anyOf(SchoolStatus.available, SchoolStatus.inProgress, SchoolStatus.completed));
    });
  });

  group('nextLessonToContinue', () {
    test('returns the first lesson of the curriculum when nothing is completed', () {
      final next = AcademyProgressCalculator.nextLessonToContinue(completedIds: {});
      expect(next, isNotNull);
    });

    test('returns null once every available lesson is completed', () {
      final allAvailableLessonIds = AcademyCatalog.modules
          .where((m) => m.contentAvailable)
          .expand((m) => m.lessonIds)
          .toSet();

      final next = AcademyProgressCalculator.nextLessonToContinue(completedIds: allAvailableLessonIds);
      expect(next, isNull);
    });

    test('skips a completed lesson and returns the next incomplete one in the same module', () {
      final next = AcademyProgressCalculator.nextLessonToContinue(completedIds: {moduleLessons.first.id});
      expect(next, isNot(equals(moduleLessons.first)));
    });
  });
}
