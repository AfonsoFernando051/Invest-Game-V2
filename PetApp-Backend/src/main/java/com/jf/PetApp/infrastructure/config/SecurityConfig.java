package com.jf.PetApp.infrastructure.config;

import com.jf.PetApp.application.auth.port.TokenProvider;
import com.jf.PetApp.application.user.port.UserRepository;
import com.jf.PetApp.infrastructure.security.jwt.JwtAuthenticationFilter;
import com.jf.PetApp.infrastructure.security.ratelimit.RateLimitingFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import java.util.Arrays;
import java.util.List;

@Configuration
public class SecurityConfig {

    // Comma-separated list of allowed origins, environment-specific. Defaults to "*" so local
    // dev keeps working out of the box; application-prod.properties overrides this to the
    // real production domain(s) — never deploy with the wildcard.
    @Value("${app.cors.allowed-origins:*}")
    private String allowedOrigins;

    // Same flag that gates the H2 console itself (application.properties vs
    // application-prod.properties) — the only reason X-Frame-Options was ever disabled was to
    // let the H2 console render in an iframe, so it's disabled only where that console is
    // actually enabled. Everywhere else (including prod) keeps the safe same-origin default.
    @Value("${spring.h2.console.enabled:false}")
    private boolean h2ConsoleEnabled;

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter(
        TokenProvider tokenProvider,
        UserRepository userRepository
    ) {
        return new JwtAuthenticationFilter(tokenProvider, userRepository);
    }

    @Bean
    public RateLimitingFilter rateLimitingFilter() {
        return new RateLimitingFilter();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(
        HttpSecurity http,
        JwtAuthenticationFilter jwtAuthenticationFilter,
        RateLimitingFilter rateLimitingFilter
    ) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .formLogin(form -> form.disable())
            .httpBasic(basic -> basic.disable())
            .logout(logout -> logout.disable())
            .headers(headers -> headers.frameOptions(frame -> {
                if (h2ConsoleEnabled) {
                    frame.disable();
                } else {
                    frame.sameOrigin();
                }
            }))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/**").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(
                jwtAuthenticationFilter,
                UsernamePasswordAuthenticationFilter.class
            )
            // Explicitly ordered ahead of the JWT filter (not just both "before
            // UsernamePasswordAuthenticationFilter", which wouldn't fix their relative order) —
            // a rate-limited request should never reach JWT parsing at all.
            .addFilterBefore(
                rateLimitingFilter,
                JwtAuthenticationFilter.class
            );

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        List<String> origins = Arrays.stream(allowedOrigins.split(","))
                .map(String::trim)
                .filter(origin -> !origin.isEmpty())
                .toList();
        configuration.setAllowedOrigins(origins.isEmpty() ? List.of("*") : origins);
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type"));
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
