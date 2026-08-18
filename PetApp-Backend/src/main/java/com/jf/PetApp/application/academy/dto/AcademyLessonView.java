package com.jf.PetApp.application.academy.dto;

import java.util.List;

public record AcademyLessonView(
        String id,
        String moduleId,
        String title,
        int order,
        int xpReward,
        List<AcademyLessonStepView> steps) {
}
