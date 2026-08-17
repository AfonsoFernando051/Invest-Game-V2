import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';

enum LessonStatus { locked, available, completed }

enum ModuleStatus { comingSoon, locked, available, inProgress, completed }

enum SchoolStatus { comingSoon, locked, available, inProgress, completed }

/// Pure functions deriving lesson/module progression state from
/// [AcademyCatalog] (static) crossed with the set of completed lesson ids
/// (persisted). Nothing here is stored as a separate value that could drift
/// from the source of truth.
class AcademyProgressCalculator {
  const AcademyProgressCalculator._();

  /// A lesson unlocks once the previous lesson in its module is completed;
  /// the first lesson of a module is always available.
  static LessonStatus lessonStatus({
    required Lesson lesson,
    required Set<String> completedIds,
  }) {
    if (completedIds.contains(lesson.id)) return LessonStatus.completed;

    final moduleLessons = AcademyCatalog.lessonsForModule(lesson.moduleId);
    final index = moduleLessons.indexWhere((l) => l.id == lesson.id);
    if (index <= 0) return LessonStatus.available;

    final previous = moduleLessons[index - 1];
    return completedIds.contains(previous.id) ? LessonStatus.available : LessonStatus.locked;
  }

  /// [module.prerequisites] (other module ids) are checked before a module
  /// with real content is ever offered as `available` — a module with no
  /// prerequisites is unaffected, so no pre-existing module can regress from
  /// `available`/`inProgress`/`completed` to `locked` by this check alone.
  static ModuleStatus moduleStatus({
    required AcademyModule module,
    required Set<String> completedIds,
  }) {
    if (!module.contentAvailable || module.lessonIds.isEmpty) return ModuleStatus.comingSoon;
    if (module.prerequisites.any((id) => !completedIds.contains(id))) return ModuleStatus.locked;

    final completedInModule = module.lessonIds.where(completedIds.contains).length;
    if (completedInModule == 0) return ModuleStatus.available;
    if (completedInModule == module.lessonIds.length) return ModuleStatus.completed;
    return ModuleStatus.inProgress;
  }

  /// Same shape as [moduleStatus], aggregated across the school's modules
  /// with real content: `comingSoon` if the school itself isn't available
  /// yet or has no such modules, `locked` if an unmet school-level
  /// prerequisite blocks it, otherwise derived from how many of those
  /// modules are complete.
  static SchoolStatus schoolStatus({
    required School school,
    required Set<String> completedIds,
  }) {
    if (!school.contentAvailable) return SchoolStatus.comingSoon;
    if (school.prerequisites.any((id) => !completedIds.contains(id))) return SchoolStatus.locked;

    final modules = AcademyCatalog.modulesForSchool(school.id).where((m) => m.contentAvailable).toList();
    if (modules.isEmpty) return SchoolStatus.comingSoon;

    final statuses = modules.map((m) => moduleStatus(module: m, completedIds: completedIds)).toList();
    if (statuses.every((s) => s == ModuleStatus.completed)) return SchoolStatus.completed;
    if (statuses.any((s) => s == ModuleStatus.completed || s == ModuleStatus.inProgress)) {
      return SchoolStatus.inProgress;
    }
    return SchoolStatus.available;
  }

  /// The next lesson the learner should continue with: the first
  /// not-yet-completed lesson of the first module with real content,
  /// scanning modules in curriculum order. `null` once every available
  /// lesson is completed.
  static Lesson? nextLessonToContinue({required Set<String> completedIds}) {
    final orderedModules = [...AcademyCatalog.modules]..sort((a, b) => a.order.compareTo(b.order));
    for (final module in orderedModules) {
      if (moduleStatus(module: module, completedIds: completedIds) == ModuleStatus.locked) continue;
      if (!module.contentAvailable) continue;
      for (final lesson in AcademyCatalog.lessonsForModule(module.id)) {
        if (!completedIds.contains(lesson.id)) return lesson;
      }
    }
    return null;
  }
}
