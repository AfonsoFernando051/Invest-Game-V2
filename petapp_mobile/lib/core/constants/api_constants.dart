class ApiConstants {
  // Overridable per build without editing source, e.g.:
  //   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8081   (Android emulator)
  //   flutter build apk --dart-define=API_BASE_URL=https://api.example.com  (prod)
  // Defaults to http://localhost:8081, which works for iOS Simulator/Web but
  // NOT the Android emulator (use 10.0.2.2 there) — see README.md.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8081',
  );

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';

  static const String onboardingQuestionsEndpoint = '/api/onboarding/questions';
  static const String onboardingSubmitEndpoint = '/api/onboarding/submit';
  static const String onboardingStatusEndpoint = '/api/onboarding/status';

  static const String settingsLanguageEndpoint = '/api/settings/language';

  static const String mentorChatEndpoint = '/api/mentor/chat';

  static String learningLessonCompleteEndpoint(String lessonId) => '/api/v1/learning/lessons/$lessonId/complete';
  static const String learningProgressEndpoint = '/api/v1/learning/progress';

  static const String gamificationSummaryEndpoint = '/api/v1/gamification/summary';
  static const String achievementsEndpoint = '/api/v1/achievements';
}
