package com.jf.PetApp.infrastructure.seed.academy.model;

import java.util.List;
import java.util.Map;

/** One lesson from a school content JSON file, nested under a module. */
public record LessonSeedDto(
        String lessonId,
        int order,
        int xpReward,
        Map<String, LessonTextDto> translations,
        List<StepSeedDto> steps) {
}
