package com.jf.PetApp.application.mentor.prompt;

import com.jf.PetApp.application.investment.dto.AllocationSliceDTO;
import com.jf.PetApp.application.investment.dto.PortfolioSummaryDTO;
import com.jf.PetApp.application.mentor.dto.MentorClientContextDTO;
import com.jf.PetApp.core.domain.Pet;
import com.jf.PetApp.core.domain.enums.InvestmentType;
import com.jf.PetApp.core.domain.enums.PetSpecieEnum;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MentorSystemPromptBuilderTest {

    private Pet petWith(String name, PetSpecieEnum specie) {
        Pet pet = new Pet();
        pet.setName(name);
        pet.setSpecie(specie);
        return pet;
    }

    @Test
    void build_WithNoPet_UsesGenericPetNamePlaceholder() {
        String prompt = MentorSystemPromptBuilder.build(null, null, null, null, "pt");

        assertTrue(prompt.contains("You are your pet,"));
    }

    @Test
    void build_WithNamedPet_UsesThePetsRealNameAndSpecie() {
        Pet pet = petWith("Rusty", PetSpecieEnum.FOX);

        String prompt = MentorSystemPromptBuilder.build(pet, null, null, null, "pt");

        assertTrue(prompt.contains("You are Rusty,"));
        assertTrue(prompt.contains("- Pet: Rusty (FOX)."));
    }

    @Test
    void build_WithPetWithBlankName_FallsBackToGenericPlaceholder() {
        Pet pet = petWith("   ", PetSpecieEnum.DOG);

        String prompt = MentorSystemPromptBuilder.build(pet, null, null, null, "pt");

        assertTrue(prompt.contains("You are your pet,"));
    }

    @Test
    void build_WithClientLanguage_PrefersClientLanguageOverFallback() {
        MentorClientContextDTO context = new MentorClientContextDTO(null, null, null, "en");

        String prompt = MentorSystemPromptBuilder.build(null, null, null, context, "pt");

        assertTrue(prompt.contains("Respond naturally and conversationally in en."));
    }

    @Test
    void build_WithoutClientLanguage_FallsBackToUsersPreferredLanguage() {
        String prompt = MentorSystemPromptBuilder.build(null, null, null, null, "es");

        assertTrue(prompt.contains("Respond naturally and conversationally in es."));
    }

    @Test
    void build_WithoutClientLanguageOrFallback_DefaultsToPortuguese() {
        String prompt = MentorSystemPromptBuilder.build(null, null, null, null, null);

        assertTrue(prompt.contains("Respond naturally and conversationally in pt."));
    }

    @Test
    void build_WithBlankFallbackLanguage_DefaultsToPortuguese() {
        String prompt = MentorSystemPromptBuilder.build(null, null, null, null, "  ");

        assertTrue(prompt.contains("Respond naturally and conversationally in pt."));
    }

    @Test
    void build_WithNoPortfolio_StatesUserHasNoInvestmentsYet() {
        String prompt = MentorSystemPromptBuilder.build(null, null, null, null, "pt");

        assertTrue(prompt.contains("the user hasn't registered any investments yet"));
    }

    @Test
    void build_WithZeroTotalAssets_TreatedAsNoPortfolio() {
        PortfolioSummaryDTO summary = new PortfolioSummaryDTO(0.0, 0.0, 0.0, 0.0, 0);

        String prompt = MentorSystemPromptBuilder.build(null, summary, null, null, "pt");

        assertTrue(prompt.contains("the user hasn't registered any investments yet"));
    }

    @Test
    void build_WithPortfolio_IncludesRealNumbersInContextBlock() {
        PortfolioSummaryDTO summary = new PortfolioSummaryDTO(1000.0, 1200.0, 200.0, 20.0, 3);

        String prompt = MentorSystemPromptBuilder.build(null, summary, null, null, "pt");

        assertTrue(prompt.contains("Portfolio: 3 asset(s), invested capital 1000.00, current value 1200.00, total gain 200.00 (20.00%)."));
    }

    @Test
    void build_WithAllocation_ListsEachSliceWithItsPercentage() {
        PortfolioSummaryDTO summary = new PortfolioSummaryDTO(1000.0, 1200.0, 200.0, 20.0, 3);
        List<AllocationSliceDTO> allocation = List.of(
                new AllocationSliceDTO(InvestmentType.STOCKS, 800.0, 66.7),
                new AllocationSliceDTO(InvestmentType.FIXED_INCOME, 400.0, 33.3)
        );

        String prompt = MentorSystemPromptBuilder.build(null, summary, allocation, null, "pt");

        assertTrue(prompt.contains("Allocation by asset type:"));
        assertTrue(prompt.contains("STOCKS: 66.7% of the portfolio"));
        assertTrue(prompt.contains("FIXED_INCOME: 33.3% of the portfolio"));
    }

    @Test
    void build_WithEmptyAllocationList_OmitsAllocationSection() {
        String prompt = MentorSystemPromptBuilder.build(null, null, List.of(), null, "pt");

        assertFalse(prompt.contains("Allocation by asset type:"));
    }

    @Test
    void build_WithClientContextFields_IncludesGoalHorizonAndScreen() {
        MentorClientContextDTO context = new MentorClientContextDTO(
                "Retire early", "10+ years", "portfolio_screen", "en");

        String prompt = MentorSystemPromptBuilder.build(null, null, null, context, "pt");

        assertTrue(prompt.contains("User's stated investment goal: Retire early"));
        assertTrue(prompt.contains("User's stated investment horizon: 10+ years"));
        assertTrue(prompt.contains("Currently viewing: portfolio_screen"));
    }

    @Test
    void build_WithBlankClientContextFields_OmitsThoseLines() {
        MentorClientContextDTO context = new MentorClientContextDTO("  ", null, "", "en");

        String prompt = MentorSystemPromptBuilder.build(null, null, null, context, "pt");

        assertFalse(prompt.contains("User's stated investment goal"));
        assertFalse(prompt.contains("User's stated investment horizon"));
        assertFalse(prompt.contains("Currently viewing"));
    }

    @Test
    void build_NeverRecommendsSpecificSecuritiesOrPredictsPrices() {
        // Guards the safety rules block itself stays intact — the prompt's core promise.
        String prompt = MentorSystemPromptBuilder.build(null, null, null, null, "pt");

        assertTrue(prompt.contains("Never recommend buying or selling a specific security."));
        assertTrue(prompt.contains("Never predict prices or promise returns."));
    }
}
