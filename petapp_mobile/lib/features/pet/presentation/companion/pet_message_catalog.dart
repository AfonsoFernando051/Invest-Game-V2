import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/features/game/domain/services/level_calculator.dart';
import 'package:petrimonium/features/game/domain/services/level_title.dart';
import 'package:petrimonium/features/pet/domain/enums/pet_animation_state.dart';
import 'package:petrimonium/features/pet/domain/enums/pet_evolution_stage.dart';
import 'package:petrimonium/features/pet/presentation/companion/pet_context.dart';
import 'package:petrimonium/features/pet/presentation/companion/pet_message.dart';

/// The single source of truth for what the pet companion says. Nothing
/// outside this file constructs a [PetMessage] with literal copy — screens
/// only supply the real data (XP, next lesson title, holdings count...) and
/// get back a fully-formed message or `null` when there's nothing worth
/// saying yet (`PetCompanionController` never invents a generic filler).
class PetMessageCatalog {
  const PetMessageCatalog._();

  /// A nudge offered when the user lands on [context], subject to
  /// `PetCompanionController`'s cooldown/priority rules — never guaranteed
  /// to actually show.
  static PetMessage? pageEnter(
    PetContext context, {
    required int userXp,
    Map<String, String> data = const {},
  }) {
    switch (context) {
      case PetContext.home:
        return _homeNudge(userXp);
      case PetContext.academy:
        return _academyNudge(data);
      case PetContext.portfolio:
        return _portfolioNudge(data);
      case PetContext.mentor:
        return _mentorNudge();
      case PetContext.profile:
        return _profileSummary(userXp);
    }
  }

  static PetMessage? _homeNudge(int userXp) {
    final level = LevelCalculator.fromXp(userXp);
    // Only worth mentioning when the next level is genuinely close —
    // "12000 XP to go" right after leveling up isn't an encouraging nudge.
    if (level.progress < 0.5) return null;
    final remaining = level.xpForNextLevel - level.xpIntoLevel;
    if (remaining <= 0) return null;

    return PetMessage(
      id: 'home_xp_to_next_level',
      context: PetContext.home,
      priority: PetMessagePriority.normal,
      trigger: PetMessageTrigger.pageEnter,
      textKey: AppStrings.companionHomeXpToNextLevel,
      params: {'xp': '$remaining'},
      mood: PetAnimationState.happy,
      action: const PetMessageAction(
        labelKey: AppStrings.companionActionViewProgress,
        destination: PetContext.profile,
      ),
    );
  }

  static PetMessage? _academyNudge(Map<String, String> data) {
    final lessonTitle = data['lessonTitle'];
    if (lessonTitle == null || lessonTitle.isEmpty) return null;

    return PetMessage(
      id: 'academy_continue_lesson',
      context: PetContext.academy,
      priority: PetMessagePriority.normal,
      trigger: PetMessageTrigger.pageEnter,
      textKey: AppStrings.companionAcademyContinueLesson,
      params: {'lessonTitle': lessonTitle},
      mood: PetAnimationState.think,
      action: const PetMessageAction(
        labelKey: AppStrings.companionActionContinue,
        destination: PetContext.academy,
      ),
    );
  }

  static PetMessage? _portfolioNudge(Map<String, String> data) {
    final countStr = data['count'];
    final count = countStr == null ? 0 : int.tryParse(countStr) ?? 0;
    if (count <= 1) return null;

    return PetMessage(
      id: 'portfolio_diversified',
      context: PetContext.portfolio,
      priority: PetMessagePriority.low,
      trigger: PetMessageTrigger.pageEnter,
      textKey: AppStrings.companionPortfolioDiversified,
      params: {'count': '$count'},
      mood: PetAnimationState.happy,
    );
  }

  static PetMessage _mentorNudge() {
    return const PetMessage(
      id: 'mentor_nudge',
      context: PetContext.mentor,
      priority: PetMessagePriority.low,
      trigger: PetMessageTrigger.pageEnter,
      textKey: AppStrings.companionMentorNudge,
      mood: PetAnimationState.idle,
    );
  }

  static PetMessage _profileSummary(int userXp) {
    final level = LevelCalculator.fromXp(userXp);
    return PetMessage(
      id: 'profile_summary',
      context: PetContext.profile,
      priority: PetMessagePriority.low,
      trigger: PetMessageTrigger.pageEnter,
      textKey: AppStrings.companionProfileSummary,
      params: {
        'level': '${level.level}',
        'stage': LevelTitle.forLevel(level.level),
      },
      mood: PetAnimationState.idle,
    );
  }

  // ── Event-triggered reactions ─────────────────────────────────────────

  static PetMessage lessonCompleted(String lessonId) {
    return PetMessage(
      id: 'event_lesson_completed_$lessonId',
      context: PetContext.academy,
      priority: PetMessagePriority.high,
      trigger: PetMessageTrigger.lessonCompleted,
      textKey: AppStrings.companionEventLessonCompleted,
      mood: PetAnimationState.victory,
    );
  }

  static PetMessage xpGained(int amount) {
    return PetMessage(
      id: 'event_xp_gained',
      context: PetContext.home,
      priority: PetMessagePriority.normal,
      trigger: PetMessageTrigger.xpGained,
      textKey: AppStrings.companionEventXpGained,
      params: {'xp': '$amount'},
      mood: PetAnimationState.happy,
    );
  }

  static PetMessage levelUp(int newLevel) {
    return PetMessage(
      id: 'event_level_up',
      context: PetContext.home,
      priority: PetMessagePriority.high,
      trigger: PetMessageTrigger.levelUp,
      textKey: AppStrings.companionEventLevelUp,
      params: {'level': '$newLevel'},
      mood: PetAnimationState.celebrate,
    );
  }

  static PetMessage achievementUnlocked(String title) {
    return PetMessage(
      id: 'event_achievement_unlocked_$title',
      context: PetContext.portfolio,
      priority: PetMessagePriority.high,
      trigger: PetMessageTrigger.achievementUnlocked,
      textKey: AppStrings.companionEventAchievementUnlocked,
      params: {'title': title},
      mood: PetAnimationState.celebrate,
    );
  }

  /// Never punitive — same encouraging, "let's look at this together" tone
  /// as a wrong-answer explanation inside a lesson, just offered a level up:
  /// a pattern across recent answers, not a single mistake.
  static PetMessage difficultyDetected(String schoolTitle) {
    return PetMessage(
      id: 'event_difficulty_detected_$schoolTitle',
      context: PetContext.academy,
      priority: PetMessagePriority.normal,
      trigger: PetMessageTrigger.difficultyDetected,
      textKey: AppStrings.companionEventDifficultyDetected,
      params: {'school': schoolTitle},
      mood: PetAnimationState.think,
    );
  }

  static PetMessage schoolMastered(String schoolTitle) {
    return PetMessage(
      id: 'event_school_mastered_$schoolTitle',
      context: PetContext.academy,
      priority: PetMessagePriority.high,
      trigger: PetMessageTrigger.schoolMastered,
      textKey: AppStrings.companionEventSchoolMastered,
      params: {'school': schoolTitle},
      mood: PetAnimationState.victory,
    );
  }

  static PetMessage evolved(PetEvolutionStage newStage) {
    return PetMessage(
      id: 'event_evolved',
      context: PetContext.home,
      priority: PetMessagePriority.high,
      trigger: PetMessageTrigger.evolved,
      textKey: AppStrings.companionEventEvolved,
      params: {'stage': newStage.label},
      mood: PetAnimationState.victory,
    );
  }
}
