package com.jf.PetApp.infrastructure.controller.auth;

import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.jf.PetApp.application.auth.dto.LoginCommand;
import com.jf.PetApp.application.auth.dto.LoginResult;
import com.jf.PetApp.application.auth.dto.RegisterCommand;
import com.jf.PetApp.application.auth.dto.RegisterResult;
import com.jf.PetApp.application.auth.exception.AuthenticationException;
import com.jf.PetApp.application.auth.exception.PasswordResetTokenInvalidException;
import com.jf.PetApp.application.auth.exception.UserAlreadyExistsException;
import com.jf.PetApp.application.auth.usecase.LoginUseCase;
import com.jf.PetApp.application.auth.usecase.RegisterUserUseCase;
import com.jf.PetApp.application.auth.usecase.RequestPasswordResetUseCase;
import com.jf.PetApp.application.auth.usecase.ResetPasswordUseCase;
import com.jf.PetApp.infrastructure.security.jwt.JwtAuthenticationFilter;

@WebMvcTest(controllers = AuthController.class)
@AutoConfigureMockMvc(addFilters = false) // Disable security filters to test only web layer
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private LoginUseCase loginUseCase;

    @MockitoBean
    private RegisterUserUseCase registerUserUseCase;

    @MockitoBean
    private RequestPasswordResetUseCase requestPasswordResetUseCase;

    @MockitoBean
    private ResetPasswordUseCase resetPasswordUseCase;

    @MockitoBean
    private JwtAuthenticationFilter jwtAuthenticationFilter; // mock the exact filter that security config uses

    // ── /auth/login ──────────────────────────────────────────────────────

    @Test
    void login_WithValidCredentials_ReturnsAccessToken() throws Exception {
        when(loginUseCase.execute(new LoginCommand("investor@test.com", "Str0ngPass")))
                .thenReturn(new LoginResult("a.jwt.token"));

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"investor@test.com","password":"Str0ngPass"}"""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").value("a.jwt.token"));
    }

    @Test
    void login_WithInvalidCredentials_Returns401() throws Exception {
        when(loginUseCase.execute(new LoginCommand("investor@test.com", "wrong")))
                .thenThrow(new AuthenticationException());

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"investor@test.com","password":"wrong"}"""))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("INVALID_CREDENTIALS"));
    }

    @Test
    void login_WithBlankEmail_Returns400ValidationError() throws Exception {
        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"","password":"Str0ngPass"}"""))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    // ── /auth/register ───────────────────────────────────────────────────

    @Test
    void register_WithValidData_Returns201WithUserIdAndEmail() throws Exception {
        when(registerUserUseCase.execute(new RegisterCommand("investor", "investor@test.com", "Str0ngPass1")))
                .thenReturn(new RegisterResult(42L, "investor@test.com"));

        mockMvc.perform(post("/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"username":"investor","email":"investor@test.com","password":"Str0ngPass1"}"""))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.userId").value(42))
                .andExpect(jsonPath("$.email").value("investor@test.com"));
    }

    @Test
    void register_WithAlreadyRegisteredEmail_Returns409() throws Exception {
        when(registerUserUseCase.execute(new RegisterCommand("investor", "investor@test.com", "Str0ngPass1")))
                .thenThrow(new UserAlreadyExistsException());

        mockMvc.perform(post("/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"username":"investor","email":"investor@test.com","password":"Str0ngPass1"}"""))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("USER_ALREADY_EXISTS"));
    }

    @Test
    void register_WithWeakPassword_Returns400ValidationError() throws Exception {
        mockMvc.perform(post("/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"username":"investor","email":"investor@test.com","password":"weak"}"""))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    // ── /auth/forgot-password ────────────────────────────────────────────

    @Test
    void forgotPassword_WithExistingEmail_ReturnsGenericSuccessMessage() throws Exception {
        mockMvc.perform(post("/auth/forgot-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"investor@test.com"}"""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").exists());

        verify(requestPasswordResetUseCase).execute("investor@test.com");
    }

    @Test
    void forgotPassword_WithUnknownEmail_StillReturns200WithSameGenericMessage() throws Exception {
        // RequestPasswordResetUseCase silently no-ops for an unknown email; the controller
        // must not treat that differently — this is the enumeration-avoidance guarantee.
        mockMvc.perform(post("/auth/forgot-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"nobody@test.com"}"""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").exists());
    }

    @Test
    void forgotPassword_WithInvalidEmailFormat_Returns400ValidationError() throws Exception {
        mockMvc.perform(post("/auth/forgot-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"not-an-email"}"""))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    // ── /auth/reset-password ─────────────────────────────────────────────

    @Test
    void resetPassword_WithValidToken_Returns200() throws Exception {
        mockMvc.perform(post("/auth/reset-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"token":"raw-token-value","newPassword":"NewStr0ngPass"}"""))
                .andExpect(status().isOk());

        verify(resetPasswordUseCase).execute("raw-token-value", "NewStr0ngPass");
    }

    @Test
    void resetPassword_WithInvalidOrExpiredToken_Returns400() throws Exception {
        doThrow(new PasswordResetTokenInvalidException())
                .when(resetPasswordUseCase).execute(eq("bad-token"), eq("NewStr0ngPass"));

        mockMvc.perform(post("/auth/reset-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"token":"bad-token","newPassword":"NewStr0ngPass"}"""))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("PASSWORD_RESET_TOKEN_INVALID"));
    }

    @Test
    void resetPassword_WithWeakNewPassword_Returns400ValidationError() throws Exception {
        mockMvc.perform(post("/auth/reset-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"token":"raw-token-value","newPassword":"weak"}"""))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }
}
