package com.jf.PetApp.infrastructure.seed.academy;

import java.time.Instant;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;

import com.jf.PetApp.infrastructure.entity.LessonProgressJpaEntity;
import com.jf.PetApp.infrastructure.repository.academy.AcademyChoiceQuestionOptionJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyChoiceQuestionOptionTranslationJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyDomainJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyDomainTranslationJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyLessonStepJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyLessonStepTakeawayJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyLessonStepTakeawayTranslationJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyLessonStepTranslationJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyLessonTranslationJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyModulePrerequisiteJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademyModuleTranslationJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademySchoolJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademySchoolPrerequisiteJpaRepository;
import com.jf.PetApp.infrastructure.repository.academy.AcademySchoolTranslationJpaRepository;
import com.jf.PetApp.infrastructure.repository.learning.LearningLessonJpaRepository;
import com.jf.PetApp.infrastructure.repository.learning.LearningModuleJpaRepository;
import com.jf.PetApp.infrastructure.repository.learning.LessonProgressJpaRepository;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Runs {@link AcademyContentSeedRunner} against the real content under
 * {@code src/main/resources/academy-content/} (on the test classpath by
 * default) rather than a hand-authored fixture — this exercises every step
 * type the real catalog actually uses and doubles as a consistency check on
 * the authored content itself.
 */
@DataJpaTest
class AcademyContentSeedRunnerTest {

    @Autowired
    private AcademyDomainJpaRepository domainRepository;
    @Autowired
    private AcademyDomainTranslationJpaRepository domainTranslationRepository;
    @Autowired
    private AcademySchoolJpaRepository schoolRepository;
    @Autowired
    private AcademySchoolTranslationJpaRepository schoolTranslationRepository;
    @Autowired
    private AcademySchoolPrerequisiteJpaRepository schoolPrerequisiteRepository;
    @Autowired
    private LearningModuleJpaRepository moduleRepository;
    @Autowired
    private AcademyModuleTranslationJpaRepository moduleTranslationRepository;
    @Autowired
    private AcademyModulePrerequisiteJpaRepository modulePrerequisiteRepository;
    @Autowired
    private LearningLessonJpaRepository lessonRepository;
    @Autowired
    private AcademyLessonTranslationJpaRepository lessonTranslationRepository;
    @Autowired
    private AcademyLessonStepJpaRepository stepRepository;
    @Autowired
    private AcademyLessonStepTranslationJpaRepository stepTranslationRepository;
    @Autowired
    private AcademyChoiceQuestionOptionJpaRepository optionRepository;
    @Autowired
    private AcademyChoiceQuestionOptionTranslationJpaRepository optionTranslationRepository;
    @Autowired
    private AcademyLessonStepTakeawayJpaRepository takeawayRepository;
    @Autowired
    private AcademyLessonStepTakeawayTranslationJpaRepository takeawayTranslationRepository;
    @Autowired
    private LessonProgressJpaRepository lessonProgressRepository;

    private AcademyContentSeedRunner newRunner() {
        return new AcademyContentSeedRunner(
                domainRepository,
                domainTranslationRepository,
                schoolRepository,
                schoolTranslationRepository,
                schoolPrerequisiteRepository,
                moduleRepository,
                moduleTranslationRepository,
                modulePrerequisiteRepository,
                lessonRepository,
                lessonTranslationRepository,
                stepRepository,
                stepTranslationRepository,
                optionRepository,
                optionTranslationRepository,
                takeawayRepository,
                takeawayTranslationRepository);
    }

    @Test
    void run_SeedsTheFullAuthoredCatalog() throws Exception {
        newRunner().run(null);

        assertThat(domainRepository.count()).isEqualTo(8);
        assertThat(schoolRepository.count()).isEqualTo(19);
        assertThat(moduleRepository.count()).isEqualTo(14);
        assertThat(lessonRepository.count()).isEqualTo(137);
        assertThat(stepRepository.count()).isEqualTo(695);
        assertThat(optionRepository.count()).isGreaterThan(0);
        assertThat(takeawayRepository.count()).isGreaterThan(0);
    }

    @Test
    void run_TwiceInARow_DoesNotDuplicateAnyRow() throws Exception {
        AcademyContentSeedRunner runner = newRunner();
        runner.run(null);

        long domains = domainRepository.count();
        long schools = schoolRepository.count();
        long modules = moduleRepository.count();
        long lessons = lessonRepository.count();
        long steps = stepRepository.count();
        long stepTranslations = stepTranslationRepository.count();
        long options = optionRepository.count();
        long optionTranslations = optionTranslationRepository.count();
        long takeaways = takeawayRepository.count();

        runner.run(null);

        assertThat(domainRepository.count()).isEqualTo(domains);
        assertThat(schoolRepository.count()).isEqualTo(schools);
        assertThat(moduleRepository.count()).isEqualTo(modules);
        assertThat(lessonRepository.count()).isEqualTo(lessons);
        assertThat(stepRepository.count()).isEqualTo(steps);
        assertThat(stepTranslationRepository.count()).isEqualTo(stepTranslations);
        assertThat(optionRepository.count()).isEqualTo(options);
        assertThat(optionTranslationRepository.count()).isEqualTo(optionTranslations);
        assertThat(takeawayRepository.count()).isEqualTo(takeaways);
    }

    @Test
    void run_NeverTouchesExistingLessonProgress() throws Exception {
        newRunner().run(null);

        LessonProgressJpaEntity progress = new LessonProgressJpaEntity();
        progress.setUserId(1L);
        progress.setLessonId("money_fundamentals_what_is_money");
        progress.setCompletedAt(Instant.now());
        lessonProgressRepository.save(progress);

        newRunner().run(null);

        assertThat(lessonProgressRepository.findAll()).hasSize(1);
        assertThat(lessonProgressRepository.findAll().get(0).getLessonId()).isEqualTo("money_fundamentals_what_is_money");
        assertThat(lessonRepository.findById("money_fundamentals_what_is_money")).isPresent();
    }
}
