package com.jf.PetApp.infrastructure.external;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class JavaMailPasswordResetMailerAdapterTest {

    @SuppressWarnings("unchecked")
    private ObjectProvider<JavaMailSender> providerReturning(JavaMailSender sender) {
        ObjectProvider<JavaMailSender> provider = mock(ObjectProvider.class);
        when(provider.getIfAvailable()).thenReturn(sender);
        return provider;
    }

    @Test
    void sendPasswordResetEmail_WhenNoMailSenderBeanAvailable_LogsInsteadOfThrowing() {
        // Mirrors the real dev scenario: spring.mail.host blank means Boot never creates a
        // JavaMailSender bean at all, so the ObjectProvider resolves to null.
        JavaMailPasswordResetMailerAdapter adapter =
                new JavaMailPasswordResetMailerAdapter(providerReturning(null));

        // Must not throw — this is the dev-friendly fallback the plan calls for.
        adapter.sendPasswordResetEmail("investor@test.com", "raw-token-value");
    }

    @Test
    void sendPasswordResetEmail_WhenMailSenderAvailable_SendsARealMessage() {
        JavaMailSender mailSender = mock(JavaMailSender.class);
        JavaMailPasswordResetMailerAdapter adapter =
                new JavaMailPasswordResetMailerAdapter(providerReturning(mailSender));
        ReflectionTestUtils.setField(adapter, "fromAddress", "noreply@petapp.test");

        adapter.sendPasswordResetEmail("investor@test.com", "raw-token-value");

        ArgumentCaptor<SimpleMailMessage> captor = ArgumentCaptor.forClass(SimpleMailMessage.class);
        verify(mailSender).send(captor.capture());
        SimpleMailMessage sent = captor.getValue();
        assertTrue(sent.getTo() != null && sent.getTo()[0].equals("investor@test.com"));
        assertTrue(sent.getFrom().equals("noreply@petapp.test"));
        assertTrue(sent.getText().contains("raw-token-value"));
    }

    @Test
    void sendPasswordResetEmail_WhenMailSenderAvailable_NeverLogsTheFallbackPath() {
        JavaMailSender mailSender = mock(JavaMailSender.class);
        JavaMailPasswordResetMailerAdapter adapter =
                new JavaMailPasswordResetMailerAdapter(providerReturning(mailSender));

        adapter.sendPasswordResetEmail("investor@test.com", "raw-token-value");

        verify(mailSender).send(any(SimpleMailMessage.class));
    }
}
