package com.jf.PetApp.infrastructure.controller.mentor;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.jf.PetApp.application.mentor.usecase.GetMentorReplyUseCase;
import com.jf.PetApp.infrastructure.security.jwt.JwtAuthenticationFilter;

@WebMvcTest(controllers = MentorController.class)
@AutoConfigureMockMvc(addFilters = false) // Disable security filters to test only web layer
class MentorControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private GetMentorReplyUseCase getMentorReplyUseCase;

    @MockitoBean
    private JwtAuthenticationFilter jwtAuthenticationFilter; // mock the exact filter that security config uses

    @Test
    @WithMockUser(username = "investor@test.com")
    void chat_WithValidMessage_ReturnsMentorReply() throws Exception {
        when(getMentorReplyUseCase.execute(eq("investor@test.com"), any()))
                .thenReturn("Looks like a solid diversified portfolio!");

        mockMvc.perform(post("/api/mentor/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"message":"How is my portfolio doing?"}"""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.reply").value("Looks like a solid diversified portfolio!"));
    }

    @Test
    @WithMockUser(username = "investor@test.com")
    void chat_WithBlankMessage_Returns400ValidationError() throws Exception {
        mockMvc.perform(post("/api/mentor/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"message":""}"""))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    @Test
    @WithMockUser(username = "investor@test.com")
    void chat_WithMessageOverSizeLimit_Returns400ValidationError() throws Exception {
        String tooLong = "a".repeat(2001);

        mockMvc.perform(post("/api/mentor/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"message\":\"" + tooLong + "\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    @Test
    @WithMockUser(username = "investor@test.com")
    void chat_WithContextFieldsOverSizeLimit_Returns400ValidationError() throws Exception {
        String tooLongGoal = "a".repeat(201);

        mockMvc.perform(post("/api/mentor/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"message\":\"hi\",\"context\":{\"petGoal\":\"" + tooLongGoal + "\"}}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }
}
