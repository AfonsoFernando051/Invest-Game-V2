package com.jf.PetApp.infrastructure.repository.mentor;

import com.jf.PetApp.infrastructure.entity.MentorConversationJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SpringMentorConversationJpaRepository extends JpaRepository<MentorConversationJpaEntity, Long> {

    List<MentorConversationJpaEntity> findByUser_EmailOrderByUpdatedAtDesc(String email);

    Optional<MentorConversationJpaEntity> findByIdAndUser_Email(Long id, String email);
}
