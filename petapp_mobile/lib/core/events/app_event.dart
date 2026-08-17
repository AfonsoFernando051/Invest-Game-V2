import 'package:petrimonium/features/pet/domain/enums/pet_evolution_stage.dart';
import 'package:petrimonium/features/portfolio/domain/entities/achievement.dart';

/// Something the Financial Engine or Game Engine did that other systems
/// (character reactions, notifications, a future AI Mentor) may want to
/// react to, without being called directly by whatever emitted it.
///
/// Kept intentionally small: only the events this codebase can honestly emit
/// today. Add a case when a real trigger exists for it, not in advance of one.
sealed class AppEvent {
  const AppEvent();
}

/// Fired the moment a permanent achievement is unlocked (see
/// `AchievementCatalog` — achievements never re-lock).
class AchievementUnlockedEvent extends AppEvent {
  final Achievement achievement;
  const AchievementUnlockedEvent(this.achievement);
}

/// Fired when the pet's evolution tier advances (see
/// `MascotController.evaluateEvolution`).
class PetEvolvedEvent extends AppEvent {
  final PetEvolutionStage newStage;
  const PetEvolvedEvent(this.newStage);
}

/// Fired when the player's computed level (see `LevelCalculator`) increases.
class UserLeveledUpEvent extends AppEvent {
  final int newLevel;
  const UserLeveledUpEvent(this.newLevel);
}

/// Fired the moment a lesson is marked complete locally (see
/// `LessonSessionController._completeLesson`) — independent of whether the
/// backend XP sync that follows it succeeds.
class LessonCompletedEvent extends AppEvent {
  final String lessonId;
  const LessonCompletedEvent(this.lessonId);
}

/// Fired whenever the user's persisted total XP increases (see
/// `MascotController.evaluateEvolution`, the single choke point XP changes
/// flow through from both lesson completion and portfolio/gamification
/// sync).
class XpGainedEvent extends AppEvent {
  final int amount;
  final int newTotalXp;
  const XpGainedEvent({required this.amount, required this.newTotalXp});
}

/// Fired when the learner has recently missed enough questions in one
/// Academy school to be worth a gentle "let's review" nudge (see
/// `AcademyProgressLocalRepository.recordMiss`). Carries the school's
/// already-resolved, current-language title — not its id — so the pet
/// feature stays decoupled from the Academy's school/module id scheme,
/// matching how `AchievementUnlockedEvent` carries a resolved title.
class DifficultyDetectedEvent extends AppEvent {
  final String schoolTitle;
  const DifficultyDetectedEvent(this.schoolTitle);
}

/// Fired the moment completing a lesson brings every currently-available
/// module of its school to 100% (see
/// `LessonSessionController._completeLesson`). Same "carry the resolved
/// title" reasoning as [DifficultyDetectedEvent].
class SchoolMasteredEvent extends AppEvent {
  final String schoolTitle;
  const SchoolMasteredEvent(this.schoolTitle);
}
