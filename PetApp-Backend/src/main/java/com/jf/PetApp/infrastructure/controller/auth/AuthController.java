package com.jf.PetApp.infrastructure.controller.auth;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jf.PetApp.application.auth.dto.LoginCommand;
import com.jf.PetApp.application.auth.dto.LoginRequest;
import com.jf.PetApp.application.auth.dto.LoginResponse;
import com.jf.PetApp.application.auth.dto.LoginResult;
import com.jf.PetApp.application.auth.dto.RegisterCommand;
import com.jf.PetApp.application.auth.dto.RegisterResult;
import com.jf.PetApp.application.auth.usecase.LoginUseCase;
import com.jf.PetApp.application.auth.usecase.RegisterUserUseCase;
import com.jf.PetApp.application.auth.usecase.RequestPasswordResetUseCase;
import com.jf.PetApp.application.auth.usecase.ResetPasswordUseCase;
import com.jf.PetApp.presentation.auth.dto.ForgotPasswordRequest;
import com.jf.PetApp.presentation.auth.dto.ForgotPasswordResponse;
import com.jf.PetApp.presentation.auth.dto.RegisterRequest;
import com.jf.PetApp.presentation.auth.dto.RegisterResponse;
import com.jf.PetApp.presentation.auth.dto.ResetPasswordRequest;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/auth")
public class AuthController {

    // Always the same response, whether or not the email belongs to a real account — see
    // RequestPasswordResetUseCase for where that guarantee is actually enforced.
    private static final String FORGOT_PASSWORD_MESSAGE =
            "If an account with that email exists, a password reset link has been sent.";

    private final LoginUseCase loginUseCase;
    private final RegisterUserUseCase registerUserUseCase;
    private final RequestPasswordResetUseCase requestPasswordResetUseCase;
    private final ResetPasswordUseCase resetPasswordUseCase;

    public AuthController(
        LoginUseCase loginUseCase,
        RegisterUserUseCase registerUserUseCase,
        RequestPasswordResetUseCase requestPasswordResetUseCase,
        ResetPasswordUseCase resetPasswordUseCase
    ) {
        this.loginUseCase = loginUseCase;
        this.registerUserUseCase = registerUserUseCase;
        this.requestPasswordResetUseCase = requestPasswordResetUseCase;
        this.resetPasswordUseCase = resetPasswordUseCase;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(
        @Valid @RequestBody LoginRequest request
    ) {
        LoginResult result = loginUseCase.execute(
            new LoginCommand(request.email(), request.password())
        );

        return ResponseEntity.ok(
            new LoginResponse(result.accessToken())
        );
    }

    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> register(
        @Valid @RequestBody RegisterRequest request
    ) {
        RegisterResult result = registerUserUseCase.execute(
            new RegisterCommand(
                request.username(),
                request.email(),
                request.password()
            )
        );

        return ResponseEntity.status(HttpStatus.CREATED)
            .body(new RegisterResponse(
                result.userId(),
                result.email()
            ));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<ForgotPasswordResponse> forgotPassword(
        @Valid @RequestBody ForgotPasswordRequest request
    ) {
        requestPasswordResetUseCase.execute(request.email());
        return ResponseEntity.ok(new ForgotPasswordResponse(FORGOT_PASSWORD_MESSAGE));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<Void> resetPassword(
        @Valid @RequestBody ResetPasswordRequest request
    ) {
        resetPasswordUseCase.execute(request.token(), request.newPassword());
        return ResponseEntity.ok().build();
    }
}
