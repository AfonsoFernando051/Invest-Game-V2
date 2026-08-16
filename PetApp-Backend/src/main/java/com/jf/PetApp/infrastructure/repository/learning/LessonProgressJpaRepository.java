package com.jf.PetApp.infrastructure.repository.learning;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.jf.PetApp.infrastructure.entity.LessonProgressJpaEntity;

@Repository
public interface LessonProgressJpaRepository extends JpaRepository<LessonProgressJpaEntity, Long> {
    boolean existsByUserIdAndLessonId(Long userId, String lessonId);

    List<LessonProgressJpaEntity> findByUserId(Long userId);
}
