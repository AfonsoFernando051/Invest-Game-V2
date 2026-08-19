package com.jf.PetApp.application.mentor.usecase;

import com.jf.PetApp.application.common.exception.ResourceNotFoundException;
import com.jf.PetApp.application.investment.dto.AllocationSliceDTO;
import com.jf.PetApp.application.investment.dto.PortfolioSummaryDTO;
import com.jf.PetApp.application.investment.usecase.GetPortfolioAllocationUseCase;
import com.jf.PetApp.application.investment.usecase.GetPortfolioSummaryUseCase;
import com.jf.PetApp.application.mentor.dto.MentorChatRequest;
import com.jf.PetApp.application.mentor.dto.MentorChatResponse;
import com.jf.PetApp.application.mentor.dto.MentorTurnDTO;
import com.jf.PetApp.application.mentor.port.GeminiChatPort;
import com.jf.PetApp.application.mentor.port.MentorConversationRepositoryPort;
import com.jf.PetApp.application.mentor.port.MentorMessageRepositoryPort;
import com.jf.PetApp.application.mentor.prompt.MentorSystemPromptBuilder;
import com.jf.PetApp.application.pet.usecase.GetMyPetUseCase;
import com.jf.PetApp.application.user.port.UserRepository;
import com.jf.PetApp.core.domain.MentorConversation;
import com.jf.PetApp.core.domain.Pet;
import com.jf.PetApp.core.domain.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GetMentorReplyUseCaseImpl implements GetMentorReplyUseCase {

    private static final Logger log = LoggerFactory.getLogger(GetMentorReplyUseCaseImpl.class);
    private static final int MAX_HISTORY_TURNS = 10;
    private static final int MAX_TITLE_LENGTH = 60;
    private static final String FALLBACK_REPLY =
            "Hmm, I'm having a little trouble thinking right now 🐾 Let's try again in a moment.";

    private final UserRepository userRepository;
    private final GetPortfolioSummaryUseCase getPortfolioSummaryUseCase;
    private final GetPortfolioAllocationUseCase getPortfolioAllocationUseCase;
    private final GetMyPetUseCase getMyPetUseCase;
    private final GeminiChatPort geminiChatPort;
    private final MentorConversationRepositoryPort conversationRepositoryPort;
    private final MentorMessageRepositoryPort messageRepositoryPort;

    public GetMentorReplyUseCaseImpl(UserRepository userRepository,
                                      GetPortfolioSummaryUseCase getPortfolioSummaryUseCase,
                                      GetPortfolioAllocationUseCase getPortfolioAllocationUseCase,
                                      GetMyPetUseCase getMyPetUseCase,
                                      GeminiChatPort geminiChatPort,
                                      MentorConversationRepositoryPort conversationRepositoryPort,
                                      MentorMessageRepositoryPort messageRepositoryPort) {
        this.userRepository = userRepository;
        this.getPortfolioSummaryUseCase = getPortfolioSummaryUseCase;
        this.getPortfolioAllocationUseCase = getPortfolioAllocationUseCase;
        this.getMyPetUseCase = getMyPetUseCase;
        this.geminiChatPort = geminiChatPort;
        this.conversationRepositoryPort = conversationRepositoryPort;
        this.messageRepositoryPort = messageRepositoryPort;
    }

    @Override
    public MentorChatResponse execute(String email, MentorChatRequest request) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        MentorConversation conversation = request.conversationId() != null
                ? conversationRepositoryPort.findByIdAndUser(request.conversationId(), email)
                        .orElseThrow(() -> new ResourceNotFoundException("Conversation not found"))
                : conversationRepositoryPort.create(email, null);

        PortfolioSummaryDTO summary = getPortfolioSummaryUseCase.execute(email);
        List<AllocationSliceDTO> allocation = getPortfolioAllocationUseCase.execute(email);
        Pet pet = getMyPetUseCase.execute(email).orElse(null);

        String systemPrompt = MentorSystemPromptBuilder.build(
                pet, summary, allocation, request.context(), user.getPreferredLanguage());

        List<MentorTurnDTO> history = messageRepositoryPort
                .findRecentByConversation(conversation.id(), MAX_HISTORY_TURNS * 2).stream()
                .map(m -> new MentorTurnDTO(m.role(), m.text()))
                .toList();

        String reply;
        try {
            reply = geminiChatPort.generateReply(systemPrompt, history, request.message());
        } catch (Exception e) {
            // e.getMessage() here is safe to log: GeminiChatClient never lets the API key
            // reach an exception message (see its own catch block).
            log.warn("Gemini call failed, falling back to canned reply: {}", e.getMessage());
            reply = FALLBACK_REPLY;
        }

        messageRepositoryPort.append(conversation.id(), "user", request.message());
        messageRepositoryPort.append(conversation.id(), "mentor", reply);

        String title = conversation.title();
        if (title == null || title.isBlank()) {
            title = buildTitle(request.message());
            conversationRepositoryPort.updateTitle(conversation.id(), title);
        } else {
            conversationRepositoryPort.touch(conversation.id());
        }

        return new MentorChatResponse(reply, conversation.id(), title);
    }

    private String buildTitle(String firstMessage) {
        String trimmed = firstMessage.strip();
        if (trimmed.length() <= MAX_TITLE_LENGTH) {
            return trimmed;
        }
        return trimmed.substring(0, MAX_TITLE_LENGTH - 3) + "...";
    }
}
