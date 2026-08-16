package com.jf.PetApp.core.domain.gamification;

/**
 * The kinds of XP-granting events the backend currently recognizes. Kept
 * intentionally small (learning-only) — mission/achievement event types are
 * added when those systems move server-side.
 */
public enum XpEventType {
    LESSON_COMPLETED,
    MODULE_COMPLETED
}
