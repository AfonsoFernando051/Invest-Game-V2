package com.jf.PetApp.infrastructure.repository.gamification;

import com.jf.PetApp.application.gamification.port.XpEventRepositoryPort;
import com.jf.PetApp.core.domain.gamification.XpEventType;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
class XpEventRepositoryAdapterTest {

    @Autowired
    private XpEventJpaRepository jpaRepository;

    private XpEventRepositoryPort adapter;

    @BeforeEach
    void setUp() {
        adapter = new XpEventRepositoryAdapter(jpaRepository);
    }

    @Test
    void existsByUserIdAndEventTypeAndSourceId_WhenNeverSaved_ReturnsFalse() {
        assertThat(adapter.existsByUserIdAndEventTypeAndSourceId(1L, XpEventType.LESSON_COMPLETED, "lesson1"))
                .isFalse();
    }

    @Test
    void save_ThenExistsByUserIdAndEventTypeAndSourceId_ReturnsTrue() {
        adapter.save(1L, XpEventType.LESSON_COMPLETED, 20, "lesson1");

        assertThat(adapter.existsByUserIdAndEventTypeAndSourceId(1L, XpEventType.LESSON_COMPLETED, "lesson1"))
                .isTrue();
    }

    @Test
    void existsByUserIdAndEventTypeAndSourceId_DoesNotMatchADifferentSourceId() {
        adapter.save(1L, XpEventType.LESSON_COMPLETED, 20, "lesson1");

        assertThat(adapter.existsByUserIdAndEventTypeAndSourceId(1L, XpEventType.LESSON_COMPLETED, "lesson2"))
                .isFalse();
    }

    @Test
    void sumAmountByUserId_WithNoEvents_ReturnsZeroRatherThanNull() {
        assertThat(adapter.sumAmountByUserId(999L)).isZero();
    }

    @Test
    void sumAmountByUserId_SumsAcrossMultipleEvents() {
        adapter.save(1L, XpEventType.LESSON_COMPLETED, 20, "lesson1");
        adapter.save(1L, XpEventType.MODULE_COMPLETED, 50, "module1");

        assertThat(adapter.sumAmountByUserId(1L)).isEqualTo(70);
    }

    @Test
    void sumAmountByUserId_IsolatedPerUser() {
        adapter.save(1L, XpEventType.LESSON_COMPLETED, 20, "lesson1");
        adapter.save(2L, XpEventType.LESSON_COMPLETED, 20, "lesson1");

        assertThat(adapter.sumAmountByUserId(1L)).isEqualTo(20);
        assertThat(adapter.sumAmountByUserId(2L)).isEqualTo(20);
    }
}
