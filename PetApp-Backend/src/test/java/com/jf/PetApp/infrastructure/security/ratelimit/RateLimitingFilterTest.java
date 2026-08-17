package com.jf.PetApp.infrastructure.security.ratelimit;

import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.PrintWriter;
import java.io.StringWriter;

import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class RateLimitingFilterTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private FilterChain filterChain;

    private RateLimitingFilter filter;

    @BeforeEach
    void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        filter = new RateLimitingFilter();
        when(response.getWriter()).thenReturn(new PrintWriter(new StringWriter()));
    }

    @Test
    void doFilterInternal_PathNotRateLimited_AlwaysPassesThrough() throws Exception {
        when(request.getRequestURI()).thenReturn("/api/investments/quote/PETR4");
        when(request.getRemoteAddr()).thenReturn("10.0.0.1");

        for (int i = 0; i < 20; i++) {
            filter.doFilterInternal(request, response, filterChain);
        }

        verify(filterChain, times(20)).doFilter(request, response);
        verify(response, never()).setStatus(429);
    }

    @Test
    void doFilterInternal_UpToLimitRequestsFromSameIp_AllPassThrough() throws Exception {
        when(request.getRequestURI()).thenReturn("/auth/login");
        when(request.getRemoteAddr()).thenReturn("10.0.0.2");

        for (int i = 0; i < 5; i++) {
            filter.doFilterInternal(request, response, filterChain);
        }

        verify(filterChain, times(5)).doFilter(request, response);
        verify(response, never()).setStatus(429);
    }

    @Test
    void doFilterInternal_ExceedingLimit_Returns429AndStopsChain() throws Exception {
        when(request.getRequestURI()).thenReturn("/auth/login");
        when(request.getRemoteAddr()).thenReturn("10.0.0.3");

        for (int i = 0; i < 5; i++) {
            filter.doFilterInternal(request, response, filterChain);
        }
        filter.doFilterInternal(request, response, filterChain);

        verify(response).setStatus(429);
        // The 6th, rejected call never reaches downstream filters/controllers.
        verify(filterChain, times(5)).doFilter(request, response);
    }

    @Test
    void doFilterInternal_DifferentIpsOnSamePath_TrackedIndependently() throws Exception {
        when(request.getRequestURI()).thenReturn("/auth/register");

        when(request.getRemoteAddr()).thenReturn("10.0.0.4");
        for (int i = 0; i < 5; i++) {
            filter.doFilterInternal(request, response, filterChain);
        }
        when(request.getRemoteAddr()).thenReturn("10.0.0.5");
        filter.doFilterInternal(request, response, filterChain);

        verify(response, never()).setStatus(429);
        verify(filterChain, times(6)).doFilter(request, response);
    }

    @Test
    void doFilterInternal_DifferentPathsForSameIp_TrackedIndependently() throws Exception {
        when(request.getRemoteAddr()).thenReturn("10.0.0.6");

        when(request.getRequestURI()).thenReturn("/auth/login");
        for (int i = 0; i < 5; i++) {
            filter.doFilterInternal(request, response, filterChain);
        }
        when(request.getRequestURI()).thenReturn("/auth/forgot-password");
        filter.doFilterInternal(request, response, filterChain);

        verify(response, never()).setStatus(429);
    }

    @Test
    void doFilterInternal_UsesXForwardedForOverRemoteAddrWhenPresent() throws Exception {
        when(request.getRequestURI()).thenReturn("/auth/login");
        when(request.getHeader("X-Forwarded-For")).thenReturn("203.0.113.5, 10.0.0.1");

        for (int i = 0; i < 5; i++) {
            filter.doFilterInternal(request, response, filterChain);
        }
        filter.doFilterInternal(request, response, filterChain);

        verify(response).setStatus(429);
        verify(request, never()).getRemoteAddr();
    }
}
