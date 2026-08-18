package com.jf.PetApp.infrastructure.config;

import java.time.Duration;

import org.springframework.boot.restclient.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * Shared RestTemplate for every outbound call to a third-party API (Brapi, Gemini,
 * LibreTranslate). Without an explicit timeout, a slow or hung provider blocks the request
 * thread indefinitely — these values are a deliberate, generous-but-bounded ceiling, not a
 * measurement of any provider's expected latency.
 */
@Configuration
public class HttpClientConfig {

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder
                .connectTimeout(Duration.ofSeconds(5))
                .readTimeout(Duration.ofSeconds(10))
                .build();
    }
}
