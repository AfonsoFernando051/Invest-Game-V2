package com.jf.PetApp.application.learning.port;

import java.util.Set;

/**
 * Application-layer boundary for per-user lesson completion state. Use
 * cases depend on this port, never on Spring Data or JPA entities directly.
 */
public interface LessonProgressRepositoryPort {

    boolean isLessonCompleted(Long userId, String lessonId);

    /** No-op if the lesson is already marked completed (idempotent). */
    void markCompleted(Long userId, String lessonId);

    Set<String> completedLessonIds(Long userId);
}
