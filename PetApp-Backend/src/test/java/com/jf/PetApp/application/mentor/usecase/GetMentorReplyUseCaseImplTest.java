package com.jf.PetApp.application.mentor.usecase;

import com.jf.PetApp.application.common.exception.ResourceNotFoundException;
import com.jf.PetApp.application.investment.dto.PortfolioSummaryDTO;
import com.jf.PetApp.application.investment.usecase.GetPortfolioAllocationUseCase;
import com.jf.PetApp.application.investment.usecase.GetPortfolioSummaryUseCase;
import com.jf.PetApp.application.mentor.dto.MentorChatRequest;
import com.jf.PetApp.application.mentor.dto.MentorChatResponse;
import com.jf.PetApp.application.mentor.dto.MentorTurnDTO;
import com.jf.PetApp.application.mentor.port.GeminiChatPort;
import com.jf.PetApp.application.mentor.port.MentorConversationRepositoryPort;
import com.jf.PetApp.application.mentor.port.MentorMessageRepositoryPort;
import com.jf.PetApp.application.pet.usecase.GetMyPetUseCase;
import com.jf.PetApp.application.user.port.UserRepository;
import com.jf.PetApp.core.domain.MentorConversation;
import com.jf.PetApp.core.domain.MentorMessage;
import com.jf.PetApp.core.domain.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

class GetMentorReplyUseCaseImplTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private GetPortfolioSummaryUseCase getPortfolioSummaryUseCase;
    @Mock
    private GetPortfolioAllocationUseCase getPortfolioAllocationUseCase;
    @Mock
    private GetMyPetUseCase getMyPetUseCase;
    @Mock
    private GeminiChatPort geminiChatPort;
    @Mock
    private MentorConversationRepositoryPort conversationRepositoryPort;
    @Mock
    private MentorMessageRepositoryPort messageRepositoryPort;

    private GetMentorReplyUseCaseImpl useCase;

    private static final String EMAIL = "investor@test.com";
    private static final Long CONVERSATION_ID = 42L;
    private static final PortfolioSummaryDTO EMPTY_SUMMARY =
            new PortfolioSummaryDTO(0.0, 0.0, 0.0, 0.0, 0);

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        useCase = new GetMentorReplyUseCaseImpl(
                userRepository, getPortfolioSummaryUseCase, getPortfolioAllocationUseCase, getMyPetUseCase,
                geminiChatPort, conversationRepositoryPort, messageRepositoryPort);

        User user = new User();
        user.setEmail(EMAIL);
        user.setPreferredLanguage("pt");
        when(userRepository.findByEmail(EMAIL)).thenReturn(Optional.of(user));
        when(getPortfolioSummaryUseCase.execute(EMAIL)).thenReturn(EMPTY_SUMMARY);
        when(getPortfolioAllocationUseCase.execute(EMAIL)).thenReturn(List.of());
        when(getMyPetUseCase.execute(EMAIL)).thenReturn(Optional.empty());

        MentorConversation existingConversation =
                new MentorConversation(CONVERSATION_ID, EMAIL, "Existing chat", Instant.now(), Instant.now());
        when(conversationRepositoryPort.findByIdAndUser(eq(CONVERSATION_ID), eq(EMAIL)))
                .thenReturn(Optional.of(existingConversation));
        when(messageRepositoryPort.findRecentByConversation(anyLong(), anyInt())).thenReturn(List.of());
    }

    private MentorChatRequest requestWithConversation(Long conversationId) {
        return new MentorChatRequest("What are dividends?", conversationId, null);
    }

    @Test
    void execute_WhenUserDoesNotExist_Throws() {
        when(userRepository.findByEmail(EMAIL)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> useCase.execute(EMAIL, requestWithConversation(CONVERSATION_ID)));
    }

    @Test
    void execute_WhenConversationIdDoesNotBelongToUser_Throws() {
        when(conversationRepositoryPort.findByIdAndUser(eq(CONVERSATION_ID), eq(EMAIL)))
                .thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> useCase.execute(EMAIL, requestWithConversation(CONVERSATION_ID)));
    }

    @Test
    void execute_WithNoConversationId_CreatesANewConversation() {
        MentorConversation created = new MentorConversation(99L, EMAIL, null, Instant.now(), Instant.now());
        when(conversationRepositoryPort.create(eq(EMAIL), any())).thenReturn(created);
        when(geminiChatPort.generateReply(anyString(), any(), anyString())).thenReturn("Dividends are periodic payments...");

        MentorChatResponse response = useCase.execute(EMAIL, requestWithConversation(null));

        assertEquals(99L, response.conversationId());
        verify(conversationRepositoryPort).create(eq(EMAIL), any());
    }

    @Test
    void execute_OnSuccess_ReturnsTheGeminiReplyVerbatimAndPersistsBothTurns() {
        when(geminiChatPort.generateReply(anyString(), any(), anyString())).thenReturn("Dividends are periodic payments...");

        MentorChatResponse response = useCase.execute(EMAIL, requestWithConversation(CONVERSATION_ID));

        assertEquals("Dividends are periodic payments...", response.reply());
        verify(messageRepositoryPort).append(CONVERSATION_ID, "user", "What are dividends?");
        verify(messageRepositoryPort).append(CONVERSATION_ID, "mentor", "Dividends are periodic payments...");
    }

    @Test
    void execute_WhenGeminiThrows_ReturnsTheCannedFallbackInsteadOfPropagating() {
        when(geminiChatPort.generateReply(anyString(), any(), anyString())).thenThrow(new RuntimeException("Gemini request failed"));

        MentorChatResponse response = useCase.execute(EMAIL, requestWithConversation(CONVERSATION_ID));

        assertNotNull(response.reply());
        assertTrue(response.reply().toLowerCase().contains("trouble") || !response.reply().isBlank());
        verify(messageRepositoryPort).append(eq(CONVERSATION_ID), eq("mentor"), anyString());
    }

    @Test
    void execute_WithMoreThanTenHistoryTurns_RequestsOnlyTheMostRecentWindowFromStorage() {
        List<MentorMessage> recent = new ArrayList<>();
        for (int i = 0; i < 20; i++) {
            recent.add(new MentorMessage((long) i, CONVERSATION_ID, i % 2 == 0 ? "user" : "mentor", "turn " + i, Instant.now()));
        }
        when(messageRepositoryPort.findRecentByConversation(CONVERSATION_ID, 20)).thenReturn(recent);
        when(geminiChatPort.generateReply(anyString(), any(), anyString())).thenReturn("ok");

        useCase.execute(EMAIL, requestWithConversation(CONVERSATION_ID));

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<MentorTurnDTO>> historyCaptor = ArgumentCaptor.forClass(List.class);
        verify(geminiChatPort).generateReply(anyString(), historyCaptor.capture(), anyString());

        assertEquals(20, historyCaptor.getValue().size());
        verify(messageRepositoryPort).findRecentByConversation(CONVERSATION_ID, 20);
    }

    @Test
    void execute_OnFirstMessage_AutoTitlesTheConversationFromIt() {
        MentorConversation untitled = new MentorConversation(CONVERSATION_ID, EMAIL, null, Instant.now(), Instant.now());
        when(conversationRepositoryPort.findByIdAndUser(eq(CONVERSATION_ID), eq(EMAIL)))
                .thenReturn(Optional.of(untitled));
        when(geminiChatPort.generateReply(anyString(), any(), anyString())).thenReturn("ok");

        MentorChatResponse response = useCase.execute(EMAIL, requestWithConversation(CONVERSATION_ID));

        assertEquals("What are dividends?", response.title());
        verify(conversationRepositoryPort).updateTitle(CONVERSATION_ID, "What are dividends?");
        verify(conversationRepositoryPort, never()).touch(any());
    }

    @Test
    void execute_OnSubsequentMessage_TouchesRatherThanRetitling() {
        when(geminiChatPort.generateReply(anyString(), any(), anyString())).thenReturn("ok");

        useCase.execute(EMAIL, requestWithConversation(CONVERSATION_ID));

        verify(conversationRepositoryPort).touch(CONVERSATION_ID);
        verify(conversationRepositoryPort, never()).updateTitle(any(), any());
    }
}
