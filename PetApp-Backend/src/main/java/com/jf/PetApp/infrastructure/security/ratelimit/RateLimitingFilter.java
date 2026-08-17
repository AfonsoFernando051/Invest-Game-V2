package com.jf.PetApp.infrastructure.security.ratelimit;

import java.io.IOException;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.http.MediaType;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Simple in-memory sliding-window rate limiter for the unauthenticated auth endpoints
 * (login/register/forgot-password) that are the natural target for credential-stuffing or
 * account-enumeration abuse. Single-instance app, no distributed state needed — a
 * {@code ConcurrentHashMap} keyed by client IP + path is enough; no new dependency (e.g.
 * Bucket4j/Redis) justified for this scale.
 *
 * Deliberately not general-purpose middleware: only the three paths listed in
 * {@link #LIMITED_PATHS} are limited, everything else passes straight through.
 */
public class RateLimitingFilter extends OncePerRequestFilter {

    private static final Set<String> LIMITED_PATHS = Set.of(
            "/auth/login", "/auth/register", "/auth/forgot-password");

    private static final int MAX_REQUESTS = 5;
    private static final Duration WINDOW = Duration.ofSeconds(60);

    private final ConcurrentHashMap<String, Deque<Instant>> requestLog = new ConcurrentHashMap<>();

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws jakarta.servlet.ServletException, IOException {

        String path = request.getRequestURI();
        if (!LIMITED_PATHS.contains(path)) {
            filterChain.doFilter(request, response);
            return;
        }

        String key = clientIp(request) + ":" + path;
        if (isRateLimited(key)) {
            response.setStatus(429);
            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
            response.getWriter().write(
                    "{\"code\":\"RATE_LIMIT_EXCEEDED\",\"detail\":\"Too many requests. Please try again later.\"}");
            return;
        }

        filterChain.doFilter(request, response);
    }

    private boolean isRateLimited(String key) {
        Instant now = Instant.now();
        Instant windowStart = now.minus(WINDOW);
        Deque<Instant> timestamps = requestLog.computeIfAbsent(key, k -> new ArrayDeque<>());

        // Prune, check, and record must happen as one unit per key, or two concurrent
        // requests for the same client could both read a stale count and both pass — a
        // plain ArrayDeque under a per-key synchronized block is simplest here.
        synchronized (timestamps) {
            while (true) {
                Instant oldest = timestamps.peekFirst();
                if (oldest == null || !oldest.isBefore(windowStart)) {
                    break;
                }
                timestamps.pollFirst();
            }

            if (timestamps.size() >= MAX_REQUESTS) {
                return true;
            }

            timestamps.addLast(now);
            return false;
        }
    }

    private String clientIp(HttpServletRequest request) {
        // X-Forwarded-For is attacker-controllable, but this is a coarse abuse deterrent, not
        // a security boundary — good enough to slow down naive automated attempts behind a
        // reverse proxy without adding proxy-trust configuration.
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return forwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
