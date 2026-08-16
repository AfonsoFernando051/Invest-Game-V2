package com.jf.PetApp.application.gamification.port;

import com.jf.PetApp.core.domain.gamification.XpEventType;

/**
 * Application-layer boundary for the XP ledger. Use cases and services
 * depend on this port, never on Spring Data or JPA entities directly.
 */
public interface XpEventRepositoryPort {

    boolean existsByUserIdAndEventTypeAndSourceId(Long userId, XpEventType eventType, String sourceId);

    void save(Long userId, XpEventType eventType, int amount, String sourceId);

    /** Sum of every XP event's amount for the user — the total XP source of truth. */
    int sumAmountByUserId(Long userId);
}
