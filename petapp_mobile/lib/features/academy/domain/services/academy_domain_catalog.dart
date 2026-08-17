import 'package:flutter/material.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_domain.dart';

/// The 8 "Escolas" grouping the 19 [School]s declared in [AcademyCatalog]
/// into broader areas of knowledge (see `docs/DECISIONS.md` DECISION-019 and
/// `docs/ACADEMY_ENGINE.md` §3c). Every existing school belongs to exactly
/// one domain here — this is purely an additional navigation layer, so no
/// school/module/lesson id, content, or progress is affected by it.
///
/// Mirrors [AcademyCatalog]'s pattern: a plain catalog-of-defs, one static
/// table per language, switched by `Translator.currentLanguage`.
class AcademyDomainCatalog {
  const AcademyDomainCatalog._();

  static List<AcademyDomain> get domains {
    return switch (Translator.currentLanguage) {
      'en' => _domainsEn,
      'es' => _domainsEs,
      _ => _domainsPt,
    };
  }

  static AcademyDomain? domainById(String id) {
    for (final domain in domains) {
      if (domain.id == id) return domain;
    }
    return null;
  }

  /// The domain a given school belongs to, if any. Every school declared in
  /// `AcademyCatalog.schools` is expected to resolve here — enforced by
  /// `academy_domain_catalog_test.dart`.
  static AcademyDomain? domainForSchool(String schoolId) {
    for (final domain in domains) {
      if (domain.schoolIds.contains(schoolId)) return domain;
    }
    return null;
  }

  static const List<AcademyDomain> _domainsPt = [
    AcademyDomain(
      id: 'financial_education',
      title: 'Educação Financeira',
      description: 'Aprenda a cuidar do seu dinheiro antes de começar a investir.',
      icon: Icons.savings_outlined,
      order: 1,
      schoolIds: ['financial_life', 'financial_fundamentals', 'financial_behavior'],
    ),
    AcademyDomain(
      id: 'investing',
      title: 'Investimentos',
      description: 'Como funcionam os investimentos e os principais tipos de ativos.',
      icon: Icons.show_chart,
      order: 2,
      schoolIds: [
        'investment_fundamentals',
        'fixed_income',
        'equities',
        'funds_etfs_fiis',
        'crypto_assets',
        'international_investing',
      ],
    ),
    AcademyDomain(
      id: 'analysis_valuation',
      title: 'Análise e Valuation',
      description: 'Aprenda a analisar ativos e empresas para decidir melhor.',
      icon: Icons.query_stats_outlined,
      order: 3,
      schoolIds: ['fundamental_analysis', 'valuation'],
    ),
    AcademyDomain(
      id: 'portfolio_wealth',
      title: 'Carteira e Patrimônio',
      description: 'Construa, acompanhe e proteja seu patrimônio no longo prazo.',
      icon: Icons.account_balance_outlined,
      order: 4,
      schoolIds: ['portfolio_wealth_management', 'risk_management', 'retirement_pension'],
    ),
    AcademyDomain(
      id: 'macro_markets',
      title: 'Macroeconomia e Mercados',
      description: 'O contexto econômico que influencia os seus investimentos.',
      icon: Icons.public,
      order: 5,
      schoolIds: ['macroeconomics_markets'],
    ),
    AcademyDomain(
      id: 'taxation_regulation',
      title: 'Tributação e Regulação',
      description: 'Como regras tributárias e regulatórias afetam seus investimentos.',
      icon: Icons.gavel_outlined,
      order: 6,
      schoolIds: ['taxation'],
    ),
    AcademyDomain(
      id: 'advanced_markets',
      title: 'Mercados Avançados',
      description: 'Instrumentos e estratégias avançadas — para quando você estiver pronto.',
      icon: Icons.speed_outlined,
      order: 7,
      schoolIds: ['derivatives_advanced_markets', 'trading'],
    ),
    AcademyDomain(
      id: 'simulations_practice',
      title: 'Simulações e Prática',
      description: 'Cenários reais para aplicar o que você aprendeu.',
      icon: Icons.explore_outlined,
      order: 8,
      schoolIds: ['real_life_simulations'],
    ),
  ];

  static const List<AcademyDomain> _domainsEn = [
    AcademyDomain(
      id: 'financial_education',
      title: 'Financial Education',
      description: 'Learn to take care of your money before you start investing.',
      icon: Icons.savings_outlined,
      order: 1,
      schoolIds: ['financial_life', 'financial_fundamentals', 'financial_behavior'],
    ),
    AcademyDomain(
      id: 'investing',
      title: 'Investing',
      description: 'How investing works and the main types of assets.',
      icon: Icons.show_chart,
      order: 2,
      schoolIds: [
        'investment_fundamentals',
        'fixed_income',
        'equities',
        'funds_etfs_fiis',
        'crypto_assets',
        'international_investing',
      ],
    ),
    AcademyDomain(
      id: 'analysis_valuation',
      title: 'Analysis & Valuation',
      description: 'Learn to analyze assets and companies to decide better.',
      icon: Icons.query_stats_outlined,
      order: 3,
      schoolIds: ['fundamental_analysis', 'valuation'],
    ),
    AcademyDomain(
      id: 'portfolio_wealth',
      title: 'Portfolio & Wealth',
      description: 'Build, track and protect your wealth over the long run.',
      icon: Icons.account_balance_outlined,
      order: 4,
      schoolIds: ['portfolio_wealth_management', 'risk_management', 'retirement_pension'],
    ),
    AcademyDomain(
      id: 'macro_markets',
      title: 'Macroeconomics & Markets',
      description: 'The economic backdrop that shapes your investments.',
      icon: Icons.public,
      order: 5,
      schoolIds: ['macroeconomics_markets'],
    ),
    AcademyDomain(
      id: 'taxation_regulation',
      title: 'Taxation & Regulation',
      description: 'How tax and regulatory rules affect your investments.',
      icon: Icons.gavel_outlined,
      order: 6,
      schoolIds: ['taxation'],
    ),
    AcademyDomain(
      id: 'advanced_markets',
      title: 'Advanced Markets',
      description: 'Advanced instruments and strategies — for when you\'re ready.',
      icon: Icons.speed_outlined,
      order: 7,
      schoolIds: ['derivatives_advanced_markets', 'trading'],
    ),
    AcademyDomain(
      id: 'simulations_practice',
      title: 'Simulations & Practice',
      description: 'Real-world scenarios to apply what you\'ve learned.',
      icon: Icons.explore_outlined,
      order: 8,
      schoolIds: ['real_life_simulations'],
    ),
  ];

  static const List<AcademyDomain> _domainsEs = [
    AcademyDomain(
      id: 'financial_education',
      title: 'Educación Financiera',
      description: 'Aprende a cuidar tu dinero antes de empezar a invertir.',
      icon: Icons.savings_outlined,
      order: 1,
      schoolIds: ['financial_life', 'financial_fundamentals', 'financial_behavior'],
    ),
    AcademyDomain(
      id: 'investing',
      title: 'Inversiones',
      description: 'Cómo funcionan las inversiones y los principales tipos de activos.',
      icon: Icons.show_chart,
      order: 2,
      schoolIds: [
        'investment_fundamentals',
        'fixed_income',
        'equities',
        'funds_etfs_fiis',
        'crypto_assets',
        'international_investing',
      ],
    ),
    AcademyDomain(
      id: 'analysis_valuation',
      title: 'Análisis y Valuation',
      description: 'Aprende a analizar activos y empresas para decidir mejor.',
      icon: Icons.query_stats_outlined,
      order: 3,
      schoolIds: ['fundamental_analysis', 'valuation'],
    ),
    AcademyDomain(
      id: 'portfolio_wealth',
      title: 'Cartera y Patrimonio',
      description: 'Construye, sigue y protege tu patrimonio a largo plazo.',
      icon: Icons.account_balance_outlined,
      order: 4,
      schoolIds: ['portfolio_wealth_management', 'risk_management', 'retirement_pension'],
    ),
    AcademyDomain(
      id: 'macro_markets',
      title: 'Macroeconomía y Mercados',
      description: 'El contexto económico que influye en tus inversiones.',
      icon: Icons.public,
      order: 5,
      schoolIds: ['macroeconomics_markets'],
    ),
    AcademyDomain(
      id: 'taxation_regulation',
      title: 'Tributación y Regulación',
      description: 'Cómo las reglas tributarias y regulatorias afectan tus inversiones.',
      icon: Icons.gavel_outlined,
      order: 6,
      schoolIds: ['taxation'],
    ),
    AcademyDomain(
      id: 'advanced_markets',
      title: 'Mercados Avanzados',
      description: 'Instrumentos y estrategias avanzadas — para cuando estés listo.',
      icon: Icons.speed_outlined,
      order: 7,
      schoolIds: ['derivatives_advanced_markets', 'trading'],
    ),
    AcademyDomain(
      id: 'simulations_practice',
      title: 'Simulaciones y Práctica',
      description: 'Escenarios reales para aplicar lo que has aprendido.',
      icon: Icons.explore_outlined,
      order: 8,
      schoolIds: ['real_life_simulations'],
    ),
  ];
}
