package com.jf.PetApp.infrastructure.seed.academy.model;

import java.util.List;
import java.util.Map;

/** One module from a school content JSON file, nested under a school. */
public record ModuleSeedDto(
        String moduleId,
        int order,
        String iconKey,
        int xpReward,
        boolean contentAvailable,
        List<String> prerequisites,
        Map<String, LocalizedTextDto> translations,
        List<LessonSeedDto> lessons) {
}
