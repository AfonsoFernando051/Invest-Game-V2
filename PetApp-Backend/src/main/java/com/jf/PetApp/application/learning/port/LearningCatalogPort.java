package com.jf.PetApp.application.learning.port;

import java.util.List;
import java.util.Optional;

import com.jf.PetApp.core.domain.learning.LessonCatalogEntry;
import com.jf.PetApp.core.domain.learning.ModuleCatalogEntry;

/**
 * Read-only access to the server's lesson/module catalog (seeded via
 * Flyway — see V2__learning_gamification_schema.sql). Use cases depend on
 * this port, never on Spring Data or JPA entities directly.
 */
public interface LearningCatalogPort {

    Optional<LessonCatalogEntry> findLesson(String lessonId);

    Optional<ModuleCatalogEntry> findModule(String moduleId);

    List<String> lessonIdsForModule(String moduleId);

    List<ModuleCatalogEntry> allModules();
}
