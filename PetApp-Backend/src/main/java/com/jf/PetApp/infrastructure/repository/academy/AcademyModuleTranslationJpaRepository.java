package com.jf.PetApp.infrastructure.repository.academy;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.jf.PetApp.infrastructure.entity.AcademyModuleTranslationJpaEntity;

@Repository
public interface AcademyModuleTranslationJpaRepository extends JpaRepository<AcademyModuleTranslationJpaEntity, Long> {

    List<AcademyModuleTranslationJpaEntity> findByModuleId(String moduleId);

    List<AcademyModuleTranslationJpaEntity> findByLang(String lang);

    void deleteByModuleId(String moduleId);
}
