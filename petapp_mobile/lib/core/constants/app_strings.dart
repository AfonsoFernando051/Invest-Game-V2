class AppStrings {
  AppStrings._();

  static const String welcomeBack = "welcomeBack";
  static const String loginToContinue = "loginToContinue";
  static const String emailOrUserHint = "emailOrUserHint";
  static const String passwordHint = "passwordHint";
  static const String forgotPassword = "forgotPassword";
  static const String noAccountSignUp = "noAccountSignUp";
  static const String loginButton = "loginButton";

  // Signup
  static const String createAccount = "createAccount";
  static const String fillDetails = "fillDetails";
  static const String nameHint = "nameHint";
  static const String confirmPasswordHint = "confirmPasswordHint";
  static const String signupButton = "signupButton";
  static const String alreadyHaveAccount = "alreadyHaveAccount";

  // Forgot / reset password
  static const String forgotPasswordTitle = "forgotPasswordTitle";
  static const String forgotPasswordSubtitle = "forgotPasswordSubtitle";
  static const String forgotPasswordEmailHint = "forgotPasswordEmailHint";
  static const String forgotPasswordSendButton = "forgotPasswordSendButton";
  static const String forgotPasswordConfirmationMessage = "forgotPasswordConfirmationMessage";
  static const String forgotPasswordHaveCodeLink = "forgotPasswordHaveCodeLink";
  static const String resetPasswordTitle = "resetPasswordTitle";
  static const String resetPasswordSubtitle = "resetPasswordSubtitle";
  static const String resetPasswordTokenHint = "resetPasswordTokenHint";
  static const String resetPasswordNewPasswordHint = "resetPasswordNewPasswordHint";
  static const String resetPasswordSubmitButton = "resetPasswordSubmitButton";
  static const String resetPasswordSuccessMessage = "resetPasswordSuccessMessage";
  static const String resetPasswordMismatchError = "resetPasswordMismatchError";
  static const String resetPasswordFieldsRequiredError = "resetPasswordFieldsRequiredError";

  // Onboarding
  static const String pleaseAnswerAllQuestions = "pleaseAnswerAllQuestions";
  static const String onboardingFailed = "onboardingFailed";
  static const String noQuestionsAvailable = "noQuestionsAvailable";
  static const String failedToLoadQuestions = "failedToLoadQuestions";

  // Pet configuration
  // Reserved for the future persistent Companion Home screen — the
  // onboarding "meet your pet" step below uses `meetPetTitle` instead so the
  // two screens don't share a title before Companion Home exists.
  static const String petProfileTitle = "petProfileTitle";
  static const String failedToSavePet = "failedToSavePet";

  // Meet Your Pet (onboarding)
  static const String meetPetTitle = "meetPetTitle";
  static const String meetPetGreeting = "meetPetGreeting";
  static const String meetPetIntro = "meetPetIntro";
  static const String meetPetNeedName = "meetPetNeedName";
  static const String meetPetSpeciesPrompt = "meetPetSpeciesPrompt";
  static const String meetPetContinue = "meetPetContinue";
  static const String meetPetPreviewTitle = "meetPetPreviewTitle";
  static const String meetPetPreviewCelebrate = "meetPetPreviewCelebrate";
  static const String meetPetPreviewLearn = "meetPetPreviewLearn";
  static const String meetPetPreviewRemember = "meetPetPreviewRemember";

  // Name Your Pet (onboarding)
  static const String namePetTitle = "namePetTitle";
  static const String namePetPrompt = "namePetPrompt";
  static const String namePetHint = "namePetHint";
  static const String namePetContinue = "namePetContinue";
  static const String namePetReaction = "namePetReaction";
  static const String namePetRequiredError = "namePetRequiredError";

  // Financial Goal (onboarding)
  static const String financialGoalTitle = "financialGoalTitle";
  static const String financialGoalSubtitle = "financialGoalSubtitle";
  static const String financialGoalContinue = "financialGoalContinue";

  // Onboarding — shared chrome (Skip/Next reused by Welcome, Academy and
  // Gamification intro screens; Goal/Horizon reuse onboardingNext too).
  static const String onboardingSkip = "onboardingSkip";
  static const String onboardingNext = "onboardingNext";

  // Welcome (onboarding)
  static const String welcomeHeadline = "welcomeHeadline";
  static const String welcomeSubheadline = "welcomeSubheadline";
  static const String welcomeBody = "welcomeBody";
  static const String welcomeCta = "welcomeCta";

  // Academy intro (onboarding)
  static const String academyIntroTitle = "academyIntroTitle";
  static const String academyIntroSubtitle = "academyIntroSubtitle";
  static const String academyIntroBody = "academyIntroBody";
  static const String academyIntroXpBadge = "academyIntroXpBadge";

  // Gamification intro (onboarding)
  static const String gamificationIntroTitle = "gamificationIntroTitle";
  static const String gamificationIntroSubtitle = "gamificationIntroSubtitle";
  static const String onboardingLevelBadge = "onboardingLevelBadge";

  // Mission reward card — shared by Gamification intro and Journey Ready
  static const String missionCompleteLabel = "missionCompleteLabel";
  static const String missionCompoundInterestTitle = "missionCompoundInterestTitle";

  // Time Horizon (onboarding)
  static const String timeHorizonTitle = "timeHorizonTitle";
  static const String timeHorizonSubtitle = "timeHorizonSubtitle";

  // Journey Ready (onboarding — replaces the old Tutorial's final step)
  static const String journeyReadyTitle = "journeyReadyTitle";
  static const String journeyReadySubtitle = "journeyReadySubtitle";
  static const String journeyReadyGoalLabel = "journeyReadyGoalLabel";
  static const String journeyReadyPathLabel = "journeyReadyPathLabel";
  static const String journeyReadyPathValue = "journeyReadyPathValue";
  static const String journeyReadyCompanionLabel = "journeyReadyCompanionLabel";
  static const String journeyReadyProgressLabel = "journeyReadyProgressLabel";
  static const String journeyReadyFirstMissionLabel = "journeyReadyFirstMissionLabel";
  static const String journeyReadyCta = "journeyReadyCta";

  // Portfolio choice (onboarding — optional portfolio connection)
  static const String portfolioChoiceTitle = "portfolioChoiceTitle";
  static const String portfolioChoiceBody = "portfolioChoiceBody";
  static const String portfolioChoiceFootnote = "portfolioChoiceFootnote";
  static const String importPortfolioButton = "importPortfolioButton";
  static const String addManuallyButton = "addManuallyButton";
  static const String skipForNowButton = "skipForNowButton";
  static const String importComingSoonTitle = "importComingSoonTitle";
  static const String importComingSoonBody = "importComingSoonBody";
  static const String okButton = "okButton";

  // Home — portfolio-not-connected placeholder & suggested actions
  static const String portfolioNotConnectedTitle = "portfolioNotConnectedTitle";
  static const String portfolioNotConnectedBody = "portfolioNotConnectedBody";
  static const String connectInvestmentsButton = "connectInvestmentsButton";
  static const String suggestedActionsTitle = "suggestedActionsTitle";
  static const String suggestedActionCompleteLesson = "suggestedActionCompleteLesson";
  static const String suggestedActionTodayMission = "suggestedActionTodayMission";
  static const String suggestedActionLearnDividends = "suggestedActionLearnDividends";
  static const String suggestedActionFirstQuiz = "suggestedActionFirstQuiz";
  static const String suggestedActionInvestorProfile = "suggestedActionInvestorProfile";
  static const String comingSoonSnack = "comingSoonSnack";

  // Portfolio reminder (gentle nudge after skipping)
  static const String portfolioReminderMessage = "portfolioReminderMessage";
  static const String portfolioReminderCta = "portfolioReminderCta";
  static const String portfolioReminderDismiss = "portfolioReminderDismiss";

  // Settings — companion / rename pet
  static const String companionSectionTitle = "companionSectionTitle";
  static const String renamePetLabel = "renamePetLabel";
  static const String renamePetButton = "renamePetButton";
  static const String renamePetDialogTitle = "renamePetDialogTitle";
  static const String renamePetSuccess = "renamePetSuccess";

  // Settings
  static const String settingsTitle = "settingsTitle";
  static const String settingsSubtitle = "settingsSubtitle";
  static const String languageSectionTitle = "languageSectionTitle";
  static const String languagePt = "languagePt";
  static const String languageEn = "languageEn";
  static const String languageEs = "languageEs";
  static const String languageUpdated = "languageUpdated";
  static const String appearanceSectionTitle = "appearanceSectionTitle";
  static const String appearanceLightLabel = "appearanceLightLabel";
  static const String appearanceLightDescription = "appearanceLightDescription";
  static const String appearanceDarkLabel = "appearanceDarkLabel";
  static const String appearanceDarkDescription = "appearanceDarkDescription";
  static const String appearanceSystemLabel = "appearanceSystemLabel";
  static const String appearanceSystemDescription = "appearanceSystemDescription";
  static const String appearanceUpdated = "appearanceUpdated";
  static const String notificationsSectionTitle = "notificationsSectionTitle";
  static const String dailyMissionReminders = "dailyMissionReminders";
  static const String achievementAlerts = "achievementAlerts";
  static const String privacySectionTitle = "privacySectionTitle";
  static const String showOnRankings = "showOnRankings";
  static const String accountSectionTitle = "accountSectionTitle";
  static const String logoutButton = "logoutButton";
  static const String logoutConfirmTitle = "logoutConfirmTitle";
  static const String logoutConfirmMessage = "logoutConfirmMessage";
  static const String cancelButton = "cancelButton";

  // Dashboard
  static const String levelUpAchieved = "levelUpAchieved";

  // Academy — UI chrome only; curriculum content (module/lesson text) lives
  // in AcademyCatalog itself, keyed off Translator.currentLanguage the same
  // way this map is, since it's domain content, not generic UI copy.
  static const String academyLevelLabel = "academyLevelLabel";
  static const String academyXpEarnedLabel = "academyXpEarnedLabel";
  static const String academyContinueSectionLabel = "academyContinueSectionLabel";
  static const String academyXpToCompleteLabel = "academyXpToCompleteLabel";
  static const String academyStartLessonButton = "academyStartLessonButton";
  static const String academyModulesSectionLabel = "academyModulesSectionLabel";
  static const String academyLessonsSectionLabel = "academyLessonsSectionLabel";
  static const String academyLessonsProgressLabel = "academyLessonsProgressLabel";
  static const String academyLessonCompleteTitle = "academyLessonCompleteTitle";
  static const String academyXpPill = "academyXpPill";
  static const String academyContinueButton = "academyContinueButton";
  static const String academyConcludeButton = "academyConcludeButton";
  static const String academyBackToAcademyButton = "academyBackToAcademyButton";
  static const String academyModuleStatusCompleted = "academyModuleStatusCompleted";
  static const String academyModuleStatusInProgress = "academyModuleStatusInProgress";
  static const String academyModuleStatusAvailable = "academyModuleStatusAvailable";
  static const String academyModuleStatusLocked = "academyModuleStatusLocked";
  static const String academyModuleStatusComingSoon = "academyModuleStatusComingSoon";
  static const String academyMicroExerciseLabel = "academyMicroExerciseLabel";
  static const String academyApplyLabel = "academyApplyLabel";
  static const String academyCorrectFeedbackTitle = "academyCorrectFeedbackTitle";
  static const String academyIncorrectFeedbackTitle = "academyIncorrectFeedbackTitle";

  // Academy — School layer (journey view, mastery, Knowledge Progress)
  static const String academySchoolsSectionLabel = "academySchoolsSectionLabel";
  static const String academyDomainsSectionLabel = "academyDomainsSectionLabel";
  static const String academyMasterySectionLabel = "academyMasterySectionLabel";
  static const String academyMasteryPercentLabel = "academyMasteryPercentLabel";
  static const String academyKnowledgeLevelLabel = "academyKnowledgeLevelLabel";

  // Academy — real Mastery (performance-based, distinct from Progress/completion above)
  static const String academyProgressLabel = "academyProgressLabel";
  static const String academyRealMasteryLabel = "academyRealMasteryLabel";
  static const String masteryTierExploring = "masteryTierExploring";
  static const String masteryTierUnderstanding = "masteryTierUnderstanding";
  static const String masteryTierApplying = "masteryTierApplying";
  static const String masteryTierMastering = "masteryTierMastering";

  // Academy — Recommended For You + Review
  static const String academyRecommendedSectionLabel = "academyRecommendedSectionLabel";
  static const String academyRecommendationContinueReason = "academyRecommendationContinueReason";
  static const String academyRecommendationReviewReason = "academyRecommendationReviewReason";
  static const String academyReviewCardTitle = "academyReviewCardTitle";
  static const String academyReviewCardSubtitle = "academyReviewCardSubtitle";
  static const String academyReviewStartButton = "academyReviewStartButton";
  static const String academyReviewEmptyState = "academyReviewEmptyState";

  // Academy — Financial Lab
  static const String financialLabSectionLabel = "financialLabSectionLabel";
  static const String financialLabTitle = "financialLabTitle";
  static const String financialLabSubtitle = "financialLabSubtitle";
  static const String compoundInterestLabTitle = "compoundInterestLabTitle";
  static const String compoundInterestLabSubtitle = "compoundInterestLabSubtitle";
  static const String labComingSoon = "labComingSoon";
  static const String inflationLabTitle = "inflationLabTitle";
  static const String fixedIncomeLabTitle = "fixedIncomeLabTitle";
  static const String diversificationLabTitle = "diversificationLabTitle";
  static const String portfolioLabTitle = "portfolioLabTitle";
  static const String labInitialAmountLabel = "labInitialAmountLabel";
  static const String labMonthlyContributionLabel = "labMonthlyContributionLabel";
  static const String labAnnualReturnLabel = "labAnnualReturnLabel";
  static const String labYearsLabel = "labYearsLabel";
  static const String labFinalValueLabel = "labFinalValueLabel";
  static const String labTotalContributionsLabel = "labTotalContributionsLabel";
  static const String labTotalGrowthLabel = "labTotalGrowthLabel";
  static const String labExplanationIncreaseYears = "labExplanationIncreaseYears";
  static const String labExplanationDecreaseYears = "labExplanationDecreaseYears";
  static const String labExplanationIncreaseReturn = "labExplanationIncreaseReturn";
  static const String labExplanationDecreaseReturn = "labExplanationDecreaseReturn";
  static const String labExplanationInitial = "labExplanationInitial";
  static const String labYearTooltipLabel = "labYearTooltipLabel";

  // Dashboard — AppBar / bottom navigation shell
  static const String appBarPlayerNamedGreeting = "appBarPlayerNamedGreeting";
  static const String appBarPlayerGenericGreeting = "appBarPlayerGenericGreeting";
  static const String profileTooltip = "profileTooltip";
  static const String notificationsTooltip = "notificationsTooltip";
  static const String logoutTooltip = "logoutTooltip";
  static const String navHome = "navHome";
  static const String navWallet = "navWallet";
  static const String navPassiveIncome = "navPassiveIncome";
  static const String navAcademy = "navAcademy";
  static const String navMentor = "navMentor";

  // Home redesign — learning-first hierarchy (docs/PRODUCT_VISION.md §8)
  static const String homeContinueLearningEyebrow = "homeContinueLearningEyebrow";
  static const String homeContinueLearningCta = "homeContinueLearningCta";
  static const String homeAllLessonsCompleteTitle = "homeAllLessonsCompleteTitle";
  static const String homeAllLessonsCompleteBody = "homeAllLessonsCompleteBody";
  static const String homeExploreAcademyCta = "homeExploreAcademyCta";
  static const String homeLevelProgressLabel = "homeLevelProgressLabel";
  static const String homeNextEvolutionLabel = "homeNextEvolutionLabel";
  static const String homeMaxEvolutionLabel = "homeMaxEvolutionLabel";
  static const String homeKnowledgeMapLabel = "homeKnowledgeMapLabel";
  static const String homeViewFullAcademyCta = "homeViewFullAcademyCta";
  static const String homePortfolioBridgeLabel = "homePortfolioBridgeLabel";
  static const String homePortfolioBridgeApplyMessage = "homePortfolioBridgeApplyMessage";
  static const String homeViewPortfolioCta = "homeViewPortfolioCta";
  static const String homeAnswerInvestorProfileLink = "homeAnswerInvestorProfileLink";

  // Level tiers — motivational milestone names, never a competence
  // certification (docs/PRODUCT_VISION.md §9; docs/FEATURES.md "Levels").
  static const String levelTierBeginner = "levelTierBeginner";
  static const String levelTierLearner = "levelTierLearner";
  static const String levelTierExplorer = "levelTierExplorer";
  static const String levelTierInvestor = "levelTierInvestor";
  static const String levelTierAnalyst = "levelTierAnalyst";
  static const String levelTierStrategist = "levelTierStrategist";
  static const String levelTierSpecialist = "levelTierSpecialist";

  // Knowledge Progress tiers — curriculum-completion track, deliberately
  // distinct from the Game Level tiers above (docs/PRODUCT_VISION.md §9).
  static const String knowledgeLevelAbsoluteBeginner = "knowledgeLevelAbsoluteBeginner";
  static const String knowledgeLevelFinancialApprentice = "knowledgeLevelFinancialApprentice";
  static const String knowledgeLevelFinancialOrganizer = "knowledgeLevelFinancialOrganizer";
  static const String knowledgeLevelFinancialProtector = "knowledgeLevelFinancialProtector";
  static const String knowledgeLevelBeginnerInvestor = "knowledgeLevelBeginnerInvestor";
  static const String knowledgeLevelInvestor = "knowledgeLevelInvestor";
  static const String knowledgeLevelAnalyst = "knowledgeLevelAnalyst";
  static const String knowledgeLevelWealthBuilder = "knowledgeLevelWealthBuilder";
  static const String knowledgeLevelFinancialStrategist = "knowledgeLevelFinancialStrategist";
  static const String knowledgeLevelFinancialMaster = "knowledgeLevelFinancialMaster";

  // Persistent pet companion — global header, speech bubble, interaction sheet
  static const String companionHeaderTooltip = "companionHeaderTooltip";
  static const String companionDismissTooltip = "companionDismissTooltip";
  static const String companionInteractionTitle = "companionInteractionTitle";
  static const String companionInteractionSubtitle = "companionInteractionSubtitle";
  static const String companionInteractionLearn = "companionInteractionLearn";
  static const String companionInteractionPortfolio = "companionInteractionPortfolio";
  static const String companionInteractionProgress = "companionInteractionProgress";
  static const String companionActionContinue = "companionActionContinue";
  static const String companionActionViewPortfolio = "companionActionViewPortfolio";
  static const String companionActionViewProgress = "companionActionViewProgress";
  static const String companionHomeXpToNextLevel = "companionHomeXpToNextLevel";
  static const String companionAcademyContinueLesson = "companionAcademyContinueLesson";
  static const String companionAcademyReviewDue = "companionAcademyReviewDue";
  static const String companionPortfolioDiversified = "companionPortfolioDiversified";
  static const String companionMentorNudge = "companionMentorNudge";
  static const String companionProfileSummary = "companionProfileSummary";
  static const String companionEventLessonCompleted = "companionEventLessonCompleted";
  static const String companionEventXpGained = "companionEventXpGained";
  static const String companionEventLevelUp = "companionEventLevelUp";
  static const String companionEventAchievementUnlocked = "companionEventAchievementUnlocked";
  static const String companionEventEvolved = "companionEventEvolved";
  static const String companionEventDifficultyDetected = "companionEventDifficultyDetected";
  static const String companionEventSchoolMastered = "companionEventSchoolMastered";

  // Portfolio — wealth/proventos evolution cards (chart legend labels)
  static const String wealthLegendPatrimony = "wealthLegendPatrimony";
  static const String wealthLegendInvested = "wealthLegendInvested";
  static const String wealthLegendAppliedValue = "wealthLegendAppliedValue";
  static const String wealthLegendCapitalGain = "wealthLegendCapitalGain";
  static const String proventosLegendReceived = "proventosLegendReceived";
  static const String proventosLegendExpected = "proventosLegendExpected";

  // Portfolio — shared empty/error states
  static const String noAssetsRegisteredYet = "noAssetsRegisteredYet";
  static const String retryButtonLabel = "retryButtonLabel";

  // Mentor
  static const String mentorClearConversationTitle = "mentorClearConversationTitle";
  static const String mentorClearConversationConfirm = "mentorClearConversationConfirm";
  static const String clearButton = "clearButton";

  // Investment configuration
  static const String initialPortfolioTitle = "initialPortfolioTitle";

  // Portfolio summary card (investment feature)
  static const String portfolioCardTitle = "portfolioCardTitle";

  // Profile
  static const String profileTitle = "profileTitle";

  // Asset details — pet teacher widget
  static const String petTeacherAskMentor = "petTeacherAskMentor";
  static const String petTeacherOwnedGreeting = "petTeacherOwnedGreeting";
  static const String petTeacherNotOwnedGreeting = "petTeacherNotOwnedGreeting";
}
