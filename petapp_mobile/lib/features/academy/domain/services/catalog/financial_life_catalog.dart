import 'package:flutter/material.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson_step.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';

/// The "Financial Life" school: personal money management before investing —
/// income, expenses, budgeting and conscious spending. Mirrors the shape of
/// the Investor Foundations content in `AcademyCatalog`: three parallel,
/// independently-written (not machine-translated) language tables sharing
/// identical ids, order and icons.
///
/// Only `money_fundamentals` has real lessons today. The remaining six
/// modules are declared with `contentAvailable: false` so the full
/// curriculum shape is visible without shipping unwritten content, exactly
/// like `fixed_income`/`stocks`/etc. in `AcademyCatalog`.
class FinancialLifeCatalog {
  const FinancialLifeCatalog._();

  // ── School ─────────────────────────────────────────────────────────────

  static const School schoolPt = School(
    id: 'financial_life',
    title: 'Vida Financeira',
    description: 'Antes de investir, aprenda a cuidar do seu próprio dinheiro: renda, despesas, orçamento e consumo consciente.',
    icon: Icons.savings_outlined,
    order: 1,
    contentAvailable: true,
  );

  static const School schoolEn = School(
    id: 'financial_life',
    title: 'Financial Life',
    description: 'Before investing, learn to manage your own money: income, expenses, budgeting, and conscious spending.',
    icon: Icons.savings_outlined,
    order: 1,
    contentAvailable: true,
  );

  static const School schoolEs = School(
    id: 'financial_life',
    title: 'Vida Financiera',
    description: 'Antes de invertir, aprende a cuidar tu propio dinero: ingresos, gastos, presupuesto y consumo consciente.',
    icon: Icons.savings_outlined,
    order: 1,
    contentAvailable: true,
  );

  // ── Modules ────────────────────────────────────────────────────────────

  static const List<AcademyModule> modulesPt = [
    AcademyModule(
      id: 'money_fundamentals',
      schoolId: 'financial_life',
      title: 'Fundamentos do Dinheiro',
      description: 'O que é dinheiro, como organizar renda e despesas, necessidades x desejos, orçamento, consumo consciente e reserva de emergência.',
      icon: Icons.payments_outlined,
      order: 1,
      lessonIds: [
        'money_fundamentals_what_is_money',
        'money_fundamentals_income_and_expenses',
        'money_fundamentals_needs_vs_wants',
        'money_fundamentals_organizing_your_money',
        'money_fundamentals_what_is_a_budget',
        'money_fundamentals_building_your_first_budget',
        'money_fundamentals_conscious_consumption',
        'money_fundamentals_financial_goals',
        'money_fundamentals_emergency_funds',
        'money_fundamentals_review',
      ],
      contentAvailable: true,
    ),
    AcademyModule(
      id: 'personal_financial_organization',
      schoolId: 'financial_life',
      title: 'Organização Financeira Pessoal',
      description: 'Fluxo de caixa, controle de despesas e definição de objetivos financeiros para organizar sua vida financeira no dia a dia.',
      icon: Icons.account_balance_wallet_outlined,
      order: 2,
    ),
    AcademyModule(
      id: 'consumption',
      schoolId: 'financial_life',
      title: 'Consumo Consciente',
      description: 'Compras por impulso, inflação do estilo de vida e o custo de oportunidade de cada decisão de consumo.',
      icon: Icons.shopping_bag_outlined,
      order: 3,
    ),
    AcademyModule(
      id: 'credit',
      schoolId: 'financial_life',
      title: 'Crédito',
      description: 'Cartão de crédito, empréstimos e taxas de juros: como o crédito funciona e quanto ele realmente custa.',
      icon: Icons.credit_card_outlined,
      order: 4,
    ),
    AcademyModule(
      id: 'debt_management',
      schoolId: 'financial_life',
      title: 'Gestão de Dívidas',
      description: 'Dívida boa x dívida ruim, estratégias de negociação e caminhos para quitar dívidas.',
      icon: Icons.trending_down,
      order: 5,
    ),
    AcademyModule(
      id: 'financial_planning',
      schoolId: 'financial_life',
      title: 'Planejamento Financeiro',
      description: 'Objetivos de curto, médio e longo prazo, reserva de emergência e planejamento para a aposentadoria.',
      icon: Icons.flag_outlined,
      order: 6,
    ),
    AcademyModule(
      id: 'financial_protection',
      schoolId: 'financial_life',
      title: 'Proteção Financeira',
      description: 'Seguros e outras formas de proteger seu patrimônio contra imprevistos.',
      icon: Icons.health_and_safety_outlined,
      order: 7,
    ),
  ];

  static const List<AcademyModule> modulesEn = [
    AcademyModule(
      id: 'money_fundamentals',
      schoolId: 'financial_life',
      title: 'Money Fundamentals',
      description: 'What money is, how to organize income and expenses, needs vs. wants, budgeting, conscious consumption, and emergency funds.',
      icon: Icons.payments_outlined,
      order: 1,
      lessonIds: [
        'money_fundamentals_what_is_money',
        'money_fundamentals_income_and_expenses',
        'money_fundamentals_needs_vs_wants',
        'money_fundamentals_organizing_your_money',
        'money_fundamentals_what_is_a_budget',
        'money_fundamentals_building_your_first_budget',
        'money_fundamentals_conscious_consumption',
        'money_fundamentals_financial_goals',
        'money_fundamentals_emergency_funds',
        'money_fundamentals_review',
      ],
      contentAvailable: true,
    ),
    AcademyModule(
      id: 'personal_financial_organization',
      schoolId: 'financial_life',
      title: 'Personal Financial Organization',
      description: 'Cash flow, expense tracking, and setting financial goals to organize your day-to-day financial life.',
      icon: Icons.account_balance_wallet_outlined,
      order: 2,
    ),
    AcademyModule(
      id: 'consumption',
      schoolId: 'financial_life',
      title: 'Consumption',
      description: 'Impulse buying, lifestyle inflation, and the opportunity cost behind every spending decision.',
      icon: Icons.shopping_bag_outlined,
      order: 3,
    ),
    AcademyModule(
      id: 'credit',
      schoolId: 'financial_life',
      title: 'Credit',
      description: 'Credit cards, loans, and interest rates: how credit works and what it really costs.',
      icon: Icons.credit_card_outlined,
      order: 4,
    ),
    AcademyModule(
      id: 'debt_management',
      schoolId: 'financial_life',
      title: 'Debt Management',
      description: 'Good debt vs. bad debt, negotiation strategies, and paths to paying off debt.',
      icon: Icons.trending_down,
      order: 5,
    ),
    AcademyModule(
      id: 'financial_planning',
      schoolId: 'financial_life',
      title: 'Financial Planning',
      description: 'Short-, medium- and long-term goals, emergency funds, and retirement planning.',
      icon: Icons.flag_outlined,
      order: 6,
    ),
    AcademyModule(
      id: 'financial_protection',
      schoolId: 'financial_life',
      title: 'Financial Protection',
      description: 'Insurance and other ways to protect your wealth against the unexpected.',
      icon: Icons.health_and_safety_outlined,
      order: 7,
    ),
  ];

  static const List<AcademyModule> modulesEs = [
    AcademyModule(
      id: 'money_fundamentals',
      schoolId: 'financial_life',
      title: 'Fundamentos del Dinero',
      description: 'Qué es el dinero, cómo organizar ingresos y gastos, necesidades vs. deseos, presupuesto, consumo consciente y fondo de emergencia.',
      icon: Icons.payments_outlined,
      order: 1,
      lessonIds: [
        'money_fundamentals_what_is_money',
        'money_fundamentals_income_and_expenses',
        'money_fundamentals_needs_vs_wants',
        'money_fundamentals_organizing_your_money',
        'money_fundamentals_what_is_a_budget',
        'money_fundamentals_building_your_first_budget',
        'money_fundamentals_conscious_consumption',
        'money_fundamentals_financial_goals',
        'money_fundamentals_emergency_funds',
        'money_fundamentals_review',
      ],
      contentAvailable: true,
    ),
    AcademyModule(
      id: 'personal_financial_organization',
      schoolId: 'financial_life',
      title: 'Organización Financiera Personal',
      description: 'Flujo de caja, control de gastos y definición de objetivos financieros para organizar tu vida financiera del día a día.',
      icon: Icons.account_balance_wallet_outlined,
      order: 2,
    ),
    AcademyModule(
      id: 'consumption',
      schoolId: 'financial_life',
      title: 'Consumo',
      description: 'Compras por impulso, inflación del estilo de vida y el costo de oportunidad de cada decisión de consumo.',
      icon: Icons.shopping_bag_outlined,
      order: 3,
    ),
    AcademyModule(
      id: 'credit',
      schoolId: 'financial_life',
      title: 'Crédito',
      description: 'Tarjetas de crédito, préstamos y tasas de interés: cómo funciona el crédito y cuánto cuesta realmente.',
      icon: Icons.credit_card_outlined,
      order: 4,
    ),
    AcademyModule(
      id: 'debt_management',
      schoolId: 'financial_life',
      title: 'Gestión de Deudas',
      description: 'Deuda buena vs. deuda mala, estrategias de negociación y caminos para pagar deudas.',
      icon: Icons.trending_down,
      order: 5,
    ),
    AcademyModule(
      id: 'financial_planning',
      schoolId: 'financial_life',
      title: 'Planificación Financiera',
      description: 'Objetivos de corto, mediano y largo plazo, fondo de emergencia y planificación para la jubilación.',
      icon: Icons.flag_outlined,
      order: 6,
    ),
    AcademyModule(
      id: 'financial_protection',
      schoolId: 'financial_life',
      title: 'Protección Financiera',
      description: 'Seguros y otras formas de proteger tu patrimonio ante imprevistos.',
      icon: Icons.health_and_safety_outlined,
      order: 7,
    ),
  ];

  // ── Lessons — pt ──────────────────────────────────────────────────────

  static const List<Lesson> lessonsPt = [
    Lesson(
      id: 'money_fundamentals_what_is_money',
      moduleId: 'money_fundamentals',
      title: 'O que é Dinheiro?',
      order: 1,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'As três funções do dinheiro',
          body:
              'Dinheiro é qualquer coisa amplamente aceita para trocar por bens e serviços. Ele cumpre três funções: '
              'é meio de troca (todos aceitam receber dinheiro em vez de outro produto), reserva de valor (você pode '
              'guardá-lo e usá-lo depois) e unidade de conta (permite comparar o preço de coisas muito diferentes, '
              'como um corte de cabelo e uma dúzia de ovos). Antes do dinheiro, as pessoas trocavam bens diretamente '
              '— o escambo — mas isso só funciona quando as duas partes querem exatamente o que a outra tem.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Imagine que você corta cabelo e precisa de ovos. No escambo, você só consegue os ovos se encontrar '
              'alguém que cria galinhas e, ao mesmo tempo, precisa cortar o cabelo naquele dia. Com dinheiro, você '
              'corta o cabelo de qualquer cliente, recebe em dinheiro e compra ovos de quem quer que os venda — sem '
              'precisar de uma coincidência de interesses.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Por que o escambo (trocar bens diretamente) é difícil de sustentar em uma economia grande?',
          options: [
            'Porque bens não podem ser trocados entre desconhecidos',
            'Porque exige encontrar alguém que queira exatamente o que você oferece, no momento certo',
            'Porque é ilegal na maioria dos países',
            'Porque bens não têm valor sem dinheiro',
          ],
          correctIndex: 1,
          explanation:
              'O escambo depende dessa "dupla coincidência de desejos" — encontrar alguém que tenha o que você quer '
              'e queira o que você tem. O dinheiro elimina essa exigência, permitindo trocas com qualquer pessoa.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Uma pequena padaria decide pagar seus funcionários com pães e bolos em vez de dinheiro. Qual '
              'problema isso provavelmente cria?',
          options: [
            'Nenhum, pães e bolos também são meios de troca aceitos por qualquer comércio',
            'Os funcionários podem não conseguir usar pães e bolos para pagar aluguel, luz ou outras contas',
            'Isso só seria um problema se a padaria fosse muito pequena',
            'Pães têm reserva de valor melhor que dinheiro',
          ],
          correctIndex: 1,
          explanation:
              'Pães e bolos estragam e não são amplamente aceitos como pagamento em outros lugares — eles falham '
              'como reserva de valor e como meio de troca geral. É exatamente isso que o dinheiro resolve.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'Dinheiro é meio de troca, reserva de valor e unidade de conta.',
            'O escambo exige uma coincidência de interesses difícil de sustentar em escala.',
            'O dinheiro funciona porque é amplamente aceito, durável e fácil de comparar.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_income_and_expenses',
      moduleId: 'money_fundamentals',
      title: 'Renda e Despesas',
      order: 2,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'As duas pontas do seu fluxo de caixa',
          body:
              'Sua vida financeira tem duas pontas: a renda (tudo que entra — salário, freelances, rendimentos) e '
              'as despesas (tudo que sai). Despesas fixas se repetem todo mês com valor parecido, como aluguel ou '
              'plano de celular. Despesas variáveis mudam de valor ou de existência mês a mês, como alimentação '
              'fora de casa ou lazer. Entender essa divisão é o primeiro passo antes de qualquer plano financeiro.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Uma pessoa recebe R\$3.000 por mês. Suas despesas fixas somam R\$1.500 (aluguel, internet, plano de '
              'celular). Suas despesas variáveis em um mês típico somam R\$900 (mercado, transporte, lazer). Isso '
              'deixa R\$600 livres para poupar, investir ou imprevistos naquele mês.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Qual das opções abaixo é um exemplo de despesa variável?',
          options: [
            'Aluguel',
            'Gastos com lazer no fim de semana',
            'Mensalidade da internet',
            'Parcela fixa de um financiamento',
          ],
          correctIndex: 1,
          explanation:
              'Gastos com lazer mudam de valor (e às vezes nem acontecem) de um mês para o outro — por isso são '
              'uma despesa variável, diferente do aluguel ou da internet, que se repetem com valor parecido.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Uma pessoa percebe que sua renda cobre suas despesas fixas, mas no fim do mês nunca sobra dinheiro '
              'e ela não sabe para onde ele foi. Qual é o primeiro passo mais útil?',
          options: [
            'Pedir um aumento de salário imediatamente',
            'Acompanhar por um mês quanto está sendo gasto em despesas variáveis, e onde',
            'Parar de gastar com qualquer coisa que não seja fixa',
            'Assumir que isso é normal e não dá para mudar',
          ],
          correctIndex: 1,
          explanation:
              'Antes de cortar gastos ou buscar mais renda, é preciso enxergar para onde o dinheiro está indo — '
              'normalmente é nas despesas variáveis, que passam despercebidas, que o dinheiro "some".',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'Renda é o que entra; despesas são o que sai — o equilíbrio entre elas é o seu fluxo de caixa.',
            'Despesas fixas se repetem com valor parecido; despesas variáveis mudam mês a mês.',
            'Antes de cortar gastos, é preciso saber exatamente para onde o dinheiro está indo.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_needs_vs_wants',
      moduleId: 'money_fundamentals',
      title: 'Necessidades x Desejos',
      order: 3,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Nem tudo que parece essencial é',
          body:
              'Necessidades são gastos essenciais para viver e trabalhar: moradia, alimentação básica, transporte, '
              'saúde. Desejos são gastos que trazem conforto ou prazer, mas não são indispensáveis: jantar fora, '
              'roupas de marca, o modelo mais novo de celular. Nenhum dos dois é "errado" — mas confundir um desejo '
              'com uma necessidade é o que mais distorce um orçamento, porque faz parecer que não há espaço para '
              'cortar quando na verdade há.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Uma pessoa diz que "precisa" pagar três serviços de streaming diferentes, porque cada um tem uma '
              'série que ela acompanha. Reclassificando com honestidade: assistir séries é um desejo legítimo, mas '
              'manter os três ao mesmo tempo — em vez de revezar um por mês — é uma escolha, não uma necessidade.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Qual das opções abaixo é, para a maioria das pessoas, uma necessidade e não um desejo?',
          options: [
            'Jantar em restaurantes toda semana',
            'Remédio de uso contínuo prescrito por um médico',
            'O lançamento mais recente de um celular',
            'Um segundo carro para uso ocasional',
          ],
          correctIndex: 1,
          explanation:
              'Um remédio de uso contínuo prescrito por um médico é essencial para a saúde — uma necessidade real. '
              'As outras opções trazem conforto ou status, mas normalmente podem ser adiadas ou reduzidas sem '
              'prejuízo direto.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Alguém com um orçamento apertado insiste em manter a academia mais cara da cidade, dizendo que '
              '"precisa" se exercitar. O que vale a pena essa pessoa considerar?',
          options: [
            'Que exercitar-se é uma necessidade, então o valor gasto não importa',
            'Que se exercitar é importante, mas a academia específica e mais cara é uma escolha entre várias '
                'formas possíveis de suprir essa necessidade',
            'Que ela deveria parar de se exercitar completamente',
            'Que academias nunca cabem em um orçamento apertado',
          ],
          correctIndex: 1,
          explanation:
              'A necessidade real por trás do exemplo é "se exercitar" — e existem várias formas de supri-la, com '
              'custos bem diferentes. Separar a necessidade da forma específica (e mais cara) de atendê-la abre '
              'espaço no orçamento sem abrir mão do que importa.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'Necessidades são essenciais; desejos trazem conforto, mas podem ser adiados ou reduzidos.',
            'Confundir desejo com necessidade esconde espaço real de corte no orçamento.',
            'Muitas vezes a necessidade é legítima, mas a forma escolhida de supri-la é que é uma escolha cara.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_organizing_your_money',
      moduleId: 'money_fundamentals',
      title: 'Organizando seu Dinheiro',
      order: 4,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Você não pode mudar o que não vê',
          body:
              'Antes de tentar economizar ou investir, é preciso saber exatamente para onde o dinheiro está indo. '
              'Registrar gastos — em uma planilha, um aplicativo ou até um caderno — revela padrões que a memória '
              'sozinha não capta. Não existe um método "certo": o melhor é o que você realmente vai manter usando.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Duas pessoas com a mesma renda: uma anota todos os gastos em um aplicativo há três meses e sabe '
              'exatamente quanto gasta com delivery; a outra "acha" que gasta pouco com isso, mas nunca verificou. '
              'Quando checa o extrato do cartão, descobre que gastou R\$450 em delivery só no último mês — bem mais '
              'do que imaginava.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Qual é o principal benefício de registrar seus gastos, mesmo antes de tentar economizar?',
          options: [
            'Registrar gastos automaticamente reduz suas despesas',
            'Ver padrões reais de gasto, que a memória sozinha costuma subestimar ou esconder',
            'É exigido por lei',
            'Só serve para quem já tem muito dinheiro',
          ],
          correctIndex: 1,
          explanation:
              'Registrar não corta gastos por si só — mas revela para onde o dinheiro realmente vai, o que costuma '
              'surpreender até quem se considera cuidadoso.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Uma pessoa tenta economizar "de cabeça", sem anotar nada, cortando o que lembra ter gastado. Todo '
              'mês ela erra a previsão do saldo final. O que provavelmente está faltando?',
          options: [
            'Um investimento com retorno mais alto',
            'Um registro real dos gastos, em vez de depender só da memória',
            'Um salário maior',
            'Nada — isso é normal e não há solução',
          ],
          correctIndex: 1,
          explanation:
              'A memória tende a subestimar gastos pequenos e frequentes. Um registro real — mesmo simples — fecha '
              'essa lacuna entre o que a pessoa acha que gasta e o que de fato gasta.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'É preciso ver para onde o dinheiro vai antes de tentar mudar esse destino.',
            'A memória subestima gastos pequenos e recorrentes.',
            'O melhor método de registro é o que você realmente vai manter usando — planilha, app ou caderno.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_what_is_a_budget',
      moduleId: 'money_fundamentals',
      title: 'O que é um Orçamento?',
      order: 5,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Um plano, não uma prisão',
          body:
              'Orçamento é um plano que organiza como sua renda será distribuída entre despesas, poupança e '
              'objetivos — não uma lista de proibições. Um orçamento bem feito dá clareza sobre quanto você pode '
              'gastar em cada área sem comprometer o que é prioridade, em vez de gerar culpa a cada compra.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Uma forma simples de estruturar um orçamento é pensar em três grandes fatias da renda: uma parte '
              'para o essencial (moradia, contas, alimentação), uma parte para o que traz qualidade de vida (lazer, '
              'hobbies) e uma parte reservada para objetivos futuros (poupar, investir, quitar dívidas). As '
              'proporções exatas variam de pessoa para pessoa — o que importa é que as três fatias existam de forma '
              'consciente, em vez de a última sobrar só se der.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Qual é a melhor forma de descrever um orçamento?',
          options: [
            'Uma lista rígida de coisas proibidas de comprar',
            'Um plano que organiza a renda entre despesas, qualidade de vida e objetivos futuros',
            'Uma ferramenta útil apenas para quem já está endividado',
            'Um cálculo que só faz sentido uma vez na vida',
          ],
          correctIndex: 1,
          explanation:
              'Orçamento não é sobre proibir — é sobre decidir com antecedência como a renda será distribuída, '
              'para que os objetivos futuros também tenham espaço garantido, e não só o que sobrar.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Uma pessoa diz que "orçamento é coisa para quem tem pouco dinheiro" e por isso nunca fez um. O que '
              'essa visão deixa de considerar?',
          options: [
            'Ela está certa — quem ganha bem não precisa de orçamento',
            'Um orçamento ajuda a direcionar a renda para objetivos de forma intencional, em qualquer faixa de '
                'renda',
            'Orçamento só serve para controlar dívidas',
            'Orçamento é uma ferramenta ultrapassada',
          ],
          correctIndex: 1,
          explanation:
              'Mesmo com renda alta, sem um plano é comum que os gastos cresçam para preencher tudo o que entra, '
              'sobrando pouco para objetivos de longo prazo — um orçamento ajuda a evitar isso, independentemente '
              'do quanto se ganha.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'Orçamento é um plano de distribuição da renda, não uma lista de proibições.',
            'Um bom orçamento reserva espaço para essenciais, qualidade de vida e objetivos futuros.',
            'Ter uma renda alta não elimina a utilidade de um orçamento.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_building_your_first_budget',
      moduleId: 'money_fundamentals',
      title: 'Construindo seu Primeiro Orçamento',
      order: 6,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Quatro passos simples',
          body:
              'Montar um primeiro orçamento envolve quatro passos: primeiro, liste toda a sua renda mensal; '
              'segundo, liste todas as suas despesas (use os últimos meses como referência, se tiver registros); '
              'terceiro, agrupe as despesas em categorias, como moradia, alimentação e lazer; quarto, defina uma '
              'meta de quanto quer conseguir poupar ou investir todo mês, mesmo que seja um valor pequeno no '
              'início.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Renda mensal: R\$2.800. Despesas listadas e categorizadas: moradia R\$900, alimentação R\$700, '
              'transporte R\$300, lazer R\$300, outras R\$200 — total de R\$2.400. A pessoa define uma meta de poupar '
              'R\$400 por mês, que é exatamente o que sobra depois de cobrir todas as categorias.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Qual é a ordem correta dos passos para montar um primeiro orçamento?',
          options: [
            'Definir a meta de poupança, depois ver quanto sobrou de renda',
            'Listar renda, listar despesas, categorizar, e então definir uma meta de poupança',
            'Categorizar despesas antes mesmo de saber quais são',
            'Não é preciso listar nada, basta uma estimativa geral',
          ],
          correctIndex: 1,
          explanation:
              'A ordem importa: só é possível definir uma meta de poupança realista depois de saber exatamente '
              'quanto entra (renda) e quanto sai (despesas categorizadas).',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Ao montar o orçamento, uma pessoa percebe que suas despesas listadas somam mais do que sua renda '
              'mensal. O que faz mais sentido fazer a seguir?',
          options: [
            'Ignorar a diferença e torcer para que dê certo',
            'Revisar as categorias para identificar onde há espaço para reduzir, antes de assumir mais dívida',
            'Desistir de fazer orçamento, já que não vai funcionar mesmo',
            'Aumentar o limite do cartão de crédito para cobrir a diferença',
          ],
          correctIndex: 1,
          explanation:
              'Um orçamento que não fecha é justamente o sinal mais valioso que ele pode dar — é a oportunidade de '
              'revisar categorias e ajustar antes que a diferença vire dívida.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'Montar um orçamento segue uma ordem: listar renda, listar despesas, categorizar, definir meta de '
                'poupança.',
            'Um orçamento que não fecha é um sinal para revisar categorias, não um motivo para desistir.',
            'Mesmo uma meta de poupança pequena, se realista, é um bom ponto de partida.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_conscious_consumption',
      moduleId: 'money_fundamentals',
      title: 'Consumo Consciente',
      order: 7,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'A pausa antes da compra',
          body:
              'Compras por impulso acontecem quando uma decisão é tomada no calor do momento, muitas vezes ligada '
              'a uma emoção — estresse, tédio, ansiedade — em vez de uma necessidade real. O consumo consciente não '
              'significa nunca comprar por prazer, mas sim criar uma pausa entre o desejo e a compra, para decidir '
              'com mais clareza se aquele gasto realmente vale a pena naquele momento.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Uma pessoa vê um tênis em promoção durante um dia estressante no trabalho e compra na hora, sem '
              'pensar, "para se sentir melhor". Outra pessoa, ao ver o mesmo tênis, anota o item e espera três dias '
              'antes de decidir. Passado esse tempo, ela percebe que já tinha um tênis parecido e opta por não '
              'comprar — economizando o valor para outro objetivo.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'O que caracteriza uma compra por impulso?',
          options: [
            'Qualquer compra feita em uma loja física',
            'Uma decisão tomada rapidamente, muitas vezes ligada a uma emoção, sem reflexão sobre a real '
                'necessidade',
            'Qualquer compra acima de determinado valor',
            'Uma compra planejada com antecedência',
          ],
          correctIndex: 1,
          explanation:
              'O que define a compra por impulso não é o valor gasto, mas a ausência de reflexão — a decisão nasce '
              'da emoção do momento, não de uma avaliação sobre se aquilo é realmente prioridade.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Uma pessoa quer reduzir compras por impulso, mas não quer parar de se presentear de vez em quando. '
              'Qual estratégia atende aos dois objetivos?',
          options: [
            'Nunca mais comprar nada que não seja essencial',
            'Criar uma regra pessoal, como esperar 48 horas antes de compras não planejadas, mantendo espaço no '
                'orçamento para prazeres ocasionais',
            'Comprar por impulso apenas em promoções, já que "é mais barato"',
            'Deletar todos os aplicativos de compra, sem outra estratégia',
          ],
          correctIndex: 1,
          explanation:
              'Consumo consciente não é privação total — é criar um espaço de reflexão antes da compra e, ao '
              'mesmo tempo, reservar deliberadamente uma parte do orçamento para prazeres, para que eles sejam uma '
              'escolha, não um impulso.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'Compras por impulso costumam nascer de emoções do momento, não de uma necessidade real.',
            'Uma pausa entre o desejo e a compra ajuda a decidir com mais clareza.',
            'Consumo consciente não é nunca comprar por prazer — é fazer isso de forma deliberada.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_financial_goals',
      moduleId: 'money_fundamentals',
      title: 'Objetivos Financeiros',
      order: 8,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'De "quero economizar mais" a um plano de verdade',
          body:
              'Objetivos financeiros podem ser de curto prazo (até 1 ano, como uma viagem), médio prazo (1 a 5 '
              'anos, como um carro) ou longo prazo (mais de 5 anos, como a aposentadoria). Um objetivo vago, como '
              '"quero economizar mais", raramente vira ação concreta. Um objetivo específico — com valor e prazo '
              'definidos — dá um alvo claro para o seu orçamento mirar.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Em vez de dizer "quero economizar mais", uma pessoa define: "quero juntar R\$6.000 em 12 meses para '
              'uma reserva de emergência". Isso significa guardar R\$500 por mês — um número que ela pode comparar '
              'diretamente com o que sobra no seu orçamento e ajustar se necessário.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt:
              'O que torna um objetivo financeiro mais útil do que uma intenção vaga como "quero economizar '
              'mais"?',
          options: [
            'O fato de ser um objetivo de longo prazo',
            'Ter um valor e um prazo definidos, que permitem calcular quanto guardar por mês',
            'O objetivo estar relacionado a investimentos',
            'Ser um número redondo, como R\$1.000',
          ],
          correctIndex: 1,
          explanation:
              'Um valor e um prazo transformam a intenção em um número mensal concreto — é isso que permite '
              'comparar o objetivo com o orçamento real e saber se ele é viável.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Uma pessoa define como objetivo: "juntar R\$4.800 em 12 meses". Ao calcular, percebe que precisaria '
              'guardar R\$400 por mês, mas seu orçamento só permite R\$250. O que faz mais sentido revisar?',
          options: [
            'Nada, é só continuar tentando guardar R\$400 mesmo sem sobrar esse valor',
            'O prazo do objetivo, o valor total, ou onde reduzir despesas — para alinhar o objetivo à realidade '
                'do orçamento',
            'Desistir do objetivo por completo',
            'Contrair uma dívida para cobrir a diferença',
          ],
          correctIndex: 1,
          explanation:
              'Quando o número mensal necessário não cabe no orçamento, o objetivo (valor, prazo) ou o orçamento '
              '(despesas) precisam ser revisados — de preferência antes de simplesmente tentar forçar algo que não '
              'é sustentável.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'Objetivos financeiros podem ser de curto, médio ou longo prazo.',
            'Um objetivo com valor e prazo definidos vira um número mensal concreto para guardar.',
            'Quando o número não cabe no orçamento, é hora de revisar o objetivo ou as despesas — não de ignorar '
                'a diferença.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_emergency_funds',
      moduleId: 'money_fundamentals',
      title: 'Reserva de Emergência',
      order: 9,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Um colchão para imprevistos',
          body:
              'A reserva de emergência é uma quantia guardada especificamente para cobrir imprevistos — perda de '
              'renda, um conserto urgente, uma despesa médica inesperada — sem precisar recorrer a dívidas. Uma '
              'referência comum é guardar entre 3 e 6 meses de despesas essenciais, embora o número ideal dependa '
              'da estabilidade da sua renda. O mais importante não é onde esse dinheiro fica exatamente, mas que '
              'ele esteja em algo com liquidez alta — ou seja, fácil e rápido de resgatar sem perdas, já que você '
              'não sabe quando vai precisar dele.',
        ),
        ExampleStep(
          title: 'Na prática',
          body:
              'Duas pessoas perdem o emprego no mesmo mês. Uma tinha 4 meses de despesas guardados em algo de '
              'fácil acesso e consegue cobrir suas contas enquanto procura uma nova renda, sem se endividar. A '
              'outra não tinha reserva alguma e precisa usar o cartão de crédito para pagar aluguel e contas '
              'básicas, entrando em um ciclo de dívida com juros altos logo no primeiro mês sem renda.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Por que a liquidez é uma característica tão importante para a reserva de emergência especificamente?',
          options: [
            'Porque emergências acontecem em datas previsíveis',
            'Porque você não sabe quando vai precisar do dinheiro, e precisa poder acessá-lo rapidamente e sem '
                'perdas',
            'Porque investimentos líquidos sempre rendem mais',
            'A liquidez não importa para esse tipo de reserva',
          ],
          correctIndex: 1,
          explanation:
              'O propósito da reserva de emergência é estar disponível exatamente quando um imprevisto acontece — '
              'que, por definição, não tem data marcada. Por isso, liquidez importa mais, para essa reserva '
              'específica, do que buscar o maior retorno possível.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Uma pessoa tem R\$5.000 guardados e está decidindo entre manter tudo como reserva de emergência ou '
              'colocar boa parte em algo que rende mais, mas que demora dias para resgatar sem perdas. O que vale '
              'a pena considerar antes de decidir?',
          options: [
            'Que reserva de emergência não precisa de liquidez, só de bom retorno',
            'Que, se todo o dinheiro ficar difícil de resgatar rapidamente, um imprevisto pode forçá-la a '
                'recorrer a dívidas mesmo tendo esse valor guardado',
            'Que emergências nunca acontecem, então não há motivo para se preocupar',
            'Que qualquer valor guardado já é suficiente, independentemente de onde está',
          ],
          correctIndex: 1,
          explanation:
              'Ter R\$5.000 "guardados" não ajuda em uma emergência se o dinheiro não puder ser acessado '
              'rapidamente quando necessário — o valor da reserva de emergência está tanto na quantia quanto na '
              'facilidade de resgate.',
        ),
        SummaryStep(
          title: 'O que você aprendeu',
          takeaways: [
            'A reserva de emergência cobre imprevistos sem precisar recorrer a dívidas.',
            'Uma referência comum é entre 3 e 6 meses de despesas essenciais.',
            'Liquidez importa mais nessa reserva do que buscar o maior retorno possível, porque você não escolhe '
                'quando vai precisar dela.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_review',
      moduleId: 'money_fundamentals',
      title: 'Revisão',
      order: 10,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Juntando as peças',
          body:
              'Você já passou por conceitos que se conectam: o que é dinheiro e por que ele existe, como organizar '
              'renda e despesas, a diferença entre necessidades e desejos, como registrar seus gastos, o que é um '
              'orçamento e como montar um, consumo consciente, objetivos financeiros específicos e a reserva de '
              'emergência. Juntas, essas ideias formam a base para administrar bem o próprio dinheiro — antes '
              'mesmo de pensar em investir.',
        ),
        ExampleStep(
          title: 'Juntando tudo',
          body:
              'Marina recebe R\$3.500 por mês. Ela começou a registrar seus gastos em um aplicativo e percebeu que '
              'gastava R\$400 por mês em compras por impulso — muitas vezes coisas que confundia com necessidades. '
              'Ela montou um orçamento simples, definiu o objetivo de juntar R\$6.000 em 12 meses (R\$500 por mês) '
              'para uma reserva de emergência, e passou a esperar 48 horas antes de qualquer compra não planejada. '
              'Depois de alguns meses, sua reserva está crescendo de forma consistente, guardada em algo fácil de '
              'resgatar caso ela precise.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt:
              'No exemplo de Marina, o que a ajudou a descobrir que gastava R\$400 por mês em compras por impulso, '
              'algo que ela não percebia antes?',
          options: [
            'Ter aumentado o limite do cartão de crédito',
            'Registrar seus gastos, em vez de confiar apenas na memória',
            'Ter parado de trabalhar',
            'Ter contratado mais serviços de streaming',
          ],
          correctIndex: 1,
          explanation:
              'Foi o hábito de registrar os gastos que revelou o padrão real de consumo por impulso de Marina — '
              'sem esse registro, esse valor provavelmente continuaria passando despercebido, como acontece com a '
              'maioria das pessoas que nunca acompanharam seus gastos.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Marina definiu o objetivo de juntar R\$6.000 em 12 meses para sua reserva de emergência. Por que '
              'faz sentido que esse dinheiro fique em algo fácil de resgatar, em vez de em algo que rende mais mas '
              'demora dias para sacar?',
          options: [
            'Porque reserva de emergência não deveria render nada',
            'Porque ela não sabe quando vai precisar desse dinheiro, e um imprevisto pode exigir acesso rápido a '
                'ele',
            'Porque não faz diferença nenhuma onde esse dinheiro fica',
            'Porque investimentos de fácil resgate são sempre proibidos para reserva de emergência',
          ],
          correctIndex: 1,
          explanation:
              'A função da reserva de emergência é estar disponível quando um imprevisto acontece — e imprevistos '
              'não avisam com antecedência. Por isso a liquidez, e não o retorno, é a prioridade para esse dinheiro '
              'específico.',
        ),
        SummaryStep(
          title: 'Módulo concluído!',
          takeaways: [
            'Dinheiro existe para facilitar trocas, guardar valor e comparar preços.',
            'Organizar renda, despesas e registrar gastos é a base antes de qualquer objetivo financeiro.',
            'Separar necessidades de desejos ajuda a encontrar espaço real no orçamento.',
            'Um orçamento é um plano — não uma proibição — e objetivos específicos (valor + prazo) o tornam '
                'acionável.',
            'A reserva de emergência prioriza liquidez, porque imprevistos não têm data marcada.',
          ],
        ),
      ],
    ),
  ];

  // ── Lessons — en ──────────────────────────────────────────────────────

  static const List<Lesson> lessonsEn = [
    Lesson(
      id: 'money_fundamentals_what_is_money',
      moduleId: 'money_fundamentals',
      title: 'What Is Money?',
      order: 1,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: "Money's three jobs",
          body:
              "Money is anything widely accepted in exchange for goods and services. It does three jobs: it's a "
              'medium of exchange (everyone agrees to accept it instead of some other item), a store of value (you '
              'can hold onto it and use it later), and a unit of account (it lets you compare the price of very '
              'different things, like a haircut and a dozen eggs). Before money, people traded goods directly — '
              "bartering — but that only works when both sides happen to want exactly what the other one has.",
        ),
        ExampleStep(
          title: 'In practice',
          body:
              "Imagine you're a barber and you need eggs. With barter, you only get the eggs if you find someone "
              "who raises chickens and also happens to need a haircut that same day. With money, you cut any "
              "customer's hair, get paid in cash, and buy eggs from whoever sells them — no coincidence of "
              "interests required.",
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Why is bartering (trading goods directly) hard to sustain in a large economy?',
          options: [
            "Because goods can't be exchanged between strangers",
            'Because it requires finding someone who wants exactly what you offer, at the right time',
            "Because it's illegal in most countries",
            'Because goods have no value without money',
          ],
          correctIndex: 1,
          explanation:
              'Barter depends on this so-called "double coincidence of wants" — finding someone who has what you '
              'want and wants what you have. Money removes that requirement, letting you trade with anyone.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt: 'A small bakery decides to pay its employees in bread and cakes instead of money. What problem does this likely create?',
          options: [
            'None — bread and cakes are also mediums of exchange accepted everywhere',
            'Employees may not be able to use bread and cakes to pay rent, electricity, or other bills',
            'This would only be a problem if the bakery were very small',
            'Bread stores value better than money',
          ],
          correctIndex: 1,
          explanation:
              "Bread and cakes go stale and aren't widely accepted as payment elsewhere — they fail as a store of "
              "value and as a general medium of exchange. That's exactly what money solves.",
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'Money is a medium of exchange, a store of value, and a unit of account.',
            "Barter requires a coincidence of interests that's hard to sustain at scale.",
            'Money works because it\'s widely accepted, durable, and easy to compare.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_income_and_expenses',
      moduleId: 'money_fundamentals',
      title: 'Income and Expenses',
      order: 2,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'The two ends of your cash flow',
          body:
              'Your financial life has two ends: income (everything coming in — salary, freelance work, returns) '
              'and expenses (everything going out). Fixed expenses repeat every month at a similar amount, like '
              "rent or a phone plan. Variable expenses change in amount, or don't happen every month, like eating "
              'out or entertainment. Understanding this split is the first step before any financial plan.',
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'Someone earns R\$3,000 a month. Their fixed expenses add up to R\$1,500 (rent, internet, phone '
              'plan). Their variable expenses in a typical month add up to R\$900 (groceries, transportation, '
              'entertainment). That leaves R\$600 free to save, invest, or handle unexpected costs that month.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Which of the following is an example of a variable expense?',
          options: [
            'Rent',
            'Weekend entertainment spending',
            'Monthly internet bill',
            'A fixed loan installment',
          ],
          correctIndex: 1,
          explanation:
              "Entertainment spending changes in amount (and sometimes doesn't happen at all) from one month to "
              "the next — that's what makes it a variable expense, unlike rent or internet, which repeat at a "
              "similar amount.",
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              "Someone notices their income covers their fixed expenses, but at the end of the month there's "
              "never anything left over, and they don't know where it went. What's the most useful first step?",
          options: [
            'Ask for a raise immediately',
            'Track for a month how much is being spent on variable expenses, and where',
            "Stop spending on anything that isn't fixed",
            "Assume this is normal and can't be changed",
          ],
          correctIndex: 1,
          explanation:
              "Before cutting spending or chasing more income, you need to see where the money is actually going "
              '— it\'s usually the variable expenses, which go unnoticed, where money quietly "disappears".',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'Income is what comes in; expenses are what goes out — the balance between them is your cash flow.',
            'Fixed expenses repeat at a similar amount; variable expenses change month to month.',
            'Before cutting spending, you need to know exactly where the money is going.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_needs_vs_wants',
      moduleId: 'money_fundamentals',
      title: 'Needs vs. Wants',
      order: 3,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: "Not everything that feels essential is",
          body:
              "Needs are essential spending to live and work: housing, basic food, transportation, healthcare. "
              "Wants are spending that brings comfort or pleasure, but isn't indispensable: eating out, "
              'brand-name clothes, the newest phone model. Neither is "wrong" — but mistaking a want for a need '
              "is what distorts a budget the most, because it makes it seem like there's no room to cut when "
              "there actually is.",
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'Someone says they "need" three different streaming subscriptions, because each one has a show '
              'they follow. Reclassifying honestly: watching shows is a legitimate want, but keeping all three at '
              'once — instead of rotating one per month — is a choice, not a need.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Which of the following is, for most people, a need rather than a want?',
          options: [
            'Eating at restaurants every week',
            'A medication prescribed by a doctor for ongoing treatment',
            'The latest phone release',
            'A second car for occasional use',
          ],
          correctIndex: 1,
          explanation:
              'A doctor-prescribed medication for ongoing treatment is essential for health — a genuine need. The '
              'other options bring comfort or status, but can usually be postponed or scaled back without direct '
              'harm.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Someone on a tight budget insists on keeping the most expensive gym in town, saying they "need" to '
              "exercise. What's worth this person considering?",
          options: [
            "That exercising is a need, so the amount spent doesn't matter",
            'That exercising matters, but this specific, pricier gym is one choice among several ways to meet '
                'that need',
            'That they should stop exercising entirely',
            'That gyms never fit into a tight budget',
          ],
          correctIndex: 1,
          explanation:
              'The real need behind the example is "exercise" — and there are several ways to meet it, at very '
              'different costs. Separating the need from the specific (and pricier) way of meeting it opens up '
              'room in the budget without giving up what matters.',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'Needs are essential; wants bring comfort, but can be postponed or scaled back.',
            'Mistaking a want for a need hides real room to cut in a budget.',
            "Often the underlying need is legitimate — it's the chosen, pricier way of meeting it that's the "
                'real choice.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_organizing_your_money',
      moduleId: 'money_fundamentals',
      title: 'Organizing Your Money',
      order: 4,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: "You can't change what you don't see",
          body:
              "Before trying to save or invest, you need to know exactly where your money is going. Tracking your "
              'spending — in a spreadsheet, an app, or even a notebook — reveals patterns that memory alone '
              'misses. There\'s no single "right" method: the best one is whichever you\'ll actually keep using.',
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'Two people with the same income: one has logged every expense in an app for three months and knows '
              'exactly how much they spend on delivery food; the other "thinks" they spend little on it, but has '
              'never checked. When they check their card statement, they find they spent R\$450 on delivery last '
              'month alone — far more than they imagined.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: "What's the main benefit of tracking your spending, even before trying to save anything?",
          options: [
            'Tracking spending automatically reduces your expenses',
            'Seeing real spending patterns, which memory alone tends to underestimate or hide',
            "It's legally required",
            "It's only useful for people who already have a lot of money",
          ],
          correctIndex: 1,
          explanation:
              "Tracking doesn't cut spending by itself — but it reveals where the money is actually going, which "
              'usually surprises even people who consider themselves careful.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Someone tries to save "by memory," without writing anything down, cutting whatever they recall '
              'spending on. Every month they misjudge their final balance. What\'s most likely missing?',
          options: [
            'An investment with a higher return',
            'An actual record of spending, instead of relying only on memory',
            'A higher salary',
            'Nothing — this is normal and there is no fix',
          ],
          correctIndex: 1,
          explanation:
              'Memory tends to underestimate small, frequent expenses. An actual record — even a simple one — '
              'closes the gap between what someone thinks they spend and what they actually spend.',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'You need to see where the money goes before you can try to change that.',
            'Memory underestimates small, recurring expenses.',
            "The best tracking method is whichever one you'll actually keep using — spreadsheet, app, or "
                'notebook.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_what_is_a_budget',
      moduleId: 'money_fundamentals',
      title: 'What Is a Budget?',
      order: 5,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'A plan, not a prison',
          body:
              "A budget is a plan that organizes how your income gets split between expenses, savings, and goals "
              "— not a list of things you're banned from buying. A well-built budget gives you clarity on how "
              'much you can spend in each area without compromising what matters most, instead of triggering '
              'guilt with every purchase.',
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'One simple way to structure a budget is to think of income as three broad slices: one for '
              'essentials (housing, bills, food), one for quality of life (entertainment, hobbies), and one set '
              'aside for future goals (saving, investing, paying off debt). The exact proportions vary from '
              "person to person — what matters is that all three slices exist on purpose, instead of the last "
              "one only getting whatever happens to be left over.",
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: "What's the best way to describe a budget?",
          options: [
            "A strict list of things you're not allowed to buy",
            'A plan that organizes income between expenses, quality of life, and future goals',
            'A tool only useful for people already in debt',
            'A calculation that only makes sense once in a lifetime',
          ],
          correctIndex: 1,
          explanation:
              "A budget isn't about banning things — it's about deciding ahead of time how income will be split, "
              "so future goals also get guaranteed room, instead of only whatever's left over.",
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Someone says "budgets are for people who don\'t have much money" and has never made one because of '
              'it. What does this view miss?',
          options: [
            "They're right — high earners don't need a budget",
            'A budget helps direct income toward goals intentionally, at any income level',
            'Budgets only exist to control debt',
            'Budgeting is an outdated tool',
          ],
          correctIndex: 1,
          explanation:
              "Even with a high income, without a plan it's common for spending to grow to fill whatever comes "
              'in, leaving little room for long-term goals — a budget helps prevent that, regardless of how much '
              'someone earns.',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'A budget is a plan for distributing income, not a list of bans.',
            'A good budget sets aside room for essentials, quality of life, and future goals.',
            "Having a high income doesn't remove the usefulness of a budget.",
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_building_your_first_budget',
      moduleId: 'money_fundamentals',
      title: 'Building Your First Budget',
      order: 6,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Four simple steps',
          body:
              'Building a first budget involves four steps: first, list all your monthly income; second, list all '
              'your expenses (use the last few months as a reference, if you have records); third, group expenses '
              'into categories, like housing, food, and entertainment; fourth, set a target for how much you want '
              "to save or invest each month, even if it's a small amount at first.",
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'Monthly income: R\$2,800. Expenses listed and categorized: housing R\$900, food R\$700, '
              'transportation R\$300, entertainment R\$300, other R\$200 — totaling R\$2,400. This person sets a '
              "target of saving R\$400 a month, exactly what's left after covering every category.",
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: "What's the correct order of steps for building a first budget?",
          options: [
            'Set a savings target, then see how much income is left',
            'List income, list expenses, categorize them, then set a savings target',
            'Categorize expenses before even knowing what they are',
            "No need to list anything — a rough estimate is enough",
          ],
          correctIndex: 1,
          explanation:
              'Order matters: you can only set a realistic savings target after knowing exactly how much comes in '
              '(income) and how much goes out (categorized expenses).',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'While building a budget, someone realizes their listed expenses add up to more than their monthly '
              'income. What makes the most sense to do next?',
          options: [
            'Ignore the gap and hope it works out',
            'Review the categories to find room to cut, before taking on more debt',
            "Give up on budgeting since it clearly won't work",
            'Raise the credit card limit to cover the difference',
          ],
          correctIndex: 1,
          explanation:
              "A budget that doesn't balance is exactly the most valuable signal it can give you — it's the "
              'chance to review categories and adjust before the gap turns into debt.',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'Building a budget follows an order: list income, list expenses, categorize, set a savings target.',
            "A budget that doesn't balance is a signal to review categories, not a reason to give up.",
            'Even a small savings target, if realistic, is a good starting point.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_conscious_consumption',
      moduleId: 'money_fundamentals',
      title: 'Conscious Consumption',
      order: 7,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'The pause before the purchase',
          body:
              'Impulse purchases happen when a decision is made in the heat of the moment, often tied to an '
              "emotion — stress, boredom, anxiety — rather than a real need. Conscious consumption doesn't mean "
              'never buying for pleasure; it means building a pause between wanting something and buying it, so '
              'you can decide more clearly whether that spending is actually worth it right now.',
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'Someone sees sneakers on sale during a stressful day at work and buys them on the spot, without '
              'thinking, "to feel better." Another person, seeing the same sneakers, notes the item down and '
              'waits three days before deciding. After that time, they realize they already own a similar pair '
              'and choose not to buy — saving that money for something else.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'What characterizes an impulse purchase?',
          options: [
            'Any purchase made in a physical store',
            'A decision made quickly, often tied to an emotion, without reflecting on the real need',
            'Any purchase above a certain amount',
            'A purchase planned ahead of time',
          ],
          correctIndex: 1,
          explanation:
              "What defines an impulse purchase isn't the amount spent, but the lack of reflection — the decision "
              "comes from the emotion of the moment, not an assessment of whether it's actually a priority.",
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              "Someone wants to cut down on impulse purchases, but doesn't want to stop treating themselves "
              'occasionally. Which strategy meets both goals?',
          options: [
            "Never buy anything that isn't essential again",
            'Set a personal rule, like waiting 48 hours before unplanned purchases, while keeping room in the '
                'budget for occasional treats',
            'Only buy on impulse during sales, since "it\'s cheaper"',
            'Delete every shopping app, with no other strategy',
          ],
          correctIndex: 1,
          explanation:
              "Conscious consumption isn't total deprivation — it's building in a moment of reflection before "
              'buying, while also deliberately setting aside part of the budget for treats, so they become a '
              'choice, not an impulse.',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'Impulse purchases usually come from emotions in the moment, not a real need.',
            'A pause between wanting something and buying it helps you decide more clearly.',
            "Conscious consumption isn't about never buying for pleasure — it's about doing so on purpose.",
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_financial_goals',
      moduleId: 'money_fundamentals',
      title: 'Financial Goals',
      order: 8,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'From "I want to save more" to an actual plan',
          body:
              'Financial goals can be short-term (up to 1 year, like a trip), medium-term (1 to 5 years, like a '
              'car), or long-term (more than 5 years, like retirement). A vague goal, like "I want to save more," '
              'rarely turns into concrete action. A specific goal — with a set amount and a set date — gives your '
              'budget a clear target to aim for.',
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'Instead of saying "I want to save more," someone sets: "I want to save R\$6,000 in 12 months for '
              'an emergency fund." That means setting aside R\$500 a month — a number they can directly compare '
              'against what\'s left in their budget and adjust if needed.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'What makes a financial goal more useful than a vague intention like "I want to save more"?',
          options: [
            "The fact that it's a long-term goal",
            'Having a set amount and a set date, which let you calculate how much to save each month',
            'The goal being related to investing',
            'Being a round number, like R\$1,000',
          ],
          correctIndex: 1,
          explanation:
              "An amount and a date turn the intention into a concrete monthly number — that's what lets you "
              "compare the goal against your actual budget and know if it's realistic.",
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Someone sets a goal: "save R\$4,800 in 12 months." Doing the math, they realize they\'d need to set '
              'aside R\$400 a month, but their budget only allows for R\$250. What makes the most sense to revisit?',
          options: [
            "Nothing — just keep trying to save R\$400 even without having that much left over",
            "The goal's timeline, its total amount, or where to cut expenses — to align the goal with the real "
                'budget',
            'Give up on the goal entirely',
            'Take on debt to cover the difference',
          ],
          correctIndex: 1,
          explanation:
              "When the required monthly number doesn't fit the budget, either the goal (amount, timeline) or the "
              'budget (expenses) needs revisiting — ideally before simply trying to force something unsustainable.',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'Financial goals can be short-, medium-, or long-term.',
            'A goal with a set amount and date becomes a concrete monthly number to save.',
            "When the number doesn't fit the budget, it's time to revisit the goal or the expenses — not ignore "
                'the gap.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_emergency_funds',
      moduleId: 'money_fundamentals',
      title: 'Emergency Funds',
      order: 9,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'A cushion for the unexpected',
          body:
              "An emergency fund is money set aside specifically to cover the unexpected — losing your income, an "
              'urgent repair, a surprise medical bill — without having to turn to debt. A common rule of thumb is '
              "setting aside 3 to 6 months of essential expenses, though the ideal number depends on how stable "
              "your income is. What matters most isn't exactly where this money sits, but that it's in something "
              "highly liquid — meaning easy and fast to withdraw without losses, since you don't know when you'll "
              "need it.",
        ),
        ExampleStep(
          title: 'In practice',
          body:
              'Two people lose their jobs in the same month. One had 4 months of expenses saved somewhere easy to '
              'access, and covers their bills while looking for new income, without going into debt. The other '
              'had no fund at all and has to use a credit card to pay rent and basic bills, falling into a '
              'high-interest debt spiral right in the first month without income.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: 'Why is liquidity such an important feature specifically for an emergency fund?',
          options: [
            'Because emergencies happen on predictable dates',
            "Because you don't know when you'll need the money, and need to be able to access it quickly and "
                'without losses',
            'Because liquid investments always earn more',
            "Liquidity doesn't matter for this type of fund",
          ],
          correctIndex: 1,
          explanation:
              'The whole purpose of an emergency fund is being available exactly when something unexpected '
              "happens — which, by definition, has no set date. That's why liquidity matters more, for this "
              'specific fund, than chasing the highest possible return.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Someone has R\$5,000 saved and is deciding between keeping it all as their emergency fund or '
              'moving most of it into something that earns more, but takes days to withdraw without losses. '
              "What's worth considering before deciding?",
          options: [
            "That an emergency fund doesn't need liquidity, only a good return",
            'That if all the money becomes hard to access quickly, an emergency could force them into debt even '
                'with that amount saved',
            "That emergencies never actually happen, so there's no need to worry",
            'That any amount saved is enough, regardless of where it sits',
          ],
          correctIndex: 1,
          explanation:
              'Having R\$5,000 "saved" doesn\'t help in an emergency if the money can\'t be accessed quickly when '
              'needed — the value of an emergency fund lies as much in how easily it can be withdrawn as in the '
              'amount itself.',
        ),
        SummaryStep(
          title: 'What you learned',
          takeaways: [
            'An emergency fund covers the unexpected without needing to turn to debt.',
            'A common rule of thumb is 3 to 6 months of essential expenses.',
            "Liquidity matters more for this fund than chasing the highest return, because you don't choose when "
                "you'll need it.",
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_review',
      moduleId: 'money_fundamentals',
      title: 'Review',
      order: 10,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Putting the pieces together',
          body:
              "You've now covered ideas that connect to each other: what money is and why it exists, how to "
              'organize income and expenses, the difference between needs and wants, how to track your spending, '
              'what a budget is and how to build one, conscious consumption, specific financial goals, and the '
              'emergency fund. Together, these ideas form the foundation for managing your own money well — even '
              'before thinking about investing.',
        ),
        ExampleStep(
          title: 'Putting it all together',
          body:
              'Marina earns R\$3,500 a month. She started tracking her spending in an app and realized she was '
              'spending R\$400 a month on impulse purchases — often things she confused with needs. She built a '
              'simple budget, set a goal of saving R\$6,000 in 12 months (R\$500 a month) for an emergency fund, '
              'and started waiting 48 hours before any unplanned purchase. A few months in, her fund is growing '
              'steadily, kept somewhere easy to withdraw if she needs it.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt:
              "In Marina's example, what helped her discover she was spending R\$400 a month on impulse "
              "purchases, something she hadn't noticed before?",
          options: [
            'Raising her credit card limit',
            'Tracking her spending, instead of relying only on memory',
            'Stopping work',
            'Signing up for more streaming services',
          ],
          correctIndex: 1,
          explanation:
              "It was the habit of tracking spending that revealed Marina's real pattern of impulse purchases — "
              'without that record, that amount would likely have kept going unnoticed, as it does for most '
              'people who never track their spending.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              "Marina set a goal of saving R\$6,000 in 12 months for her emergency fund. Why does it make sense "
              'for that money to sit somewhere easy to withdraw, instead of somewhere that earns more but takes '
              'days to cash out?',
          options: [
            "Because an emergency fund shouldn't earn anything at all",
            "Because she doesn't know when she'll need that money, and an emergency could require quick access "
                'to it',
            'Because it makes no difference where that money sits',
            'Because easy-to-withdraw investments are always banned for emergency funds',
          ],
          correctIndex: 1,
          explanation:
              "The whole point of an emergency fund is being available when something unexpected happens — and "
              "the unexpected doesn't give advance notice. That's why liquidity, not return, is the priority for "
              'this specific money.',
        ),
        SummaryStep(
          title: 'Module complete!',
          takeaways: [
            'Money exists to make trade easier, store value, and let you compare prices.',
            'Organizing income and expenses, and tracking spending, is the foundation before any financial goal.',
            'Separating needs from wants helps you find real room in a budget.',
            'A budget is a plan — not a ban — and specific goals (amount + date) make it actionable.',
            "An emergency fund prioritizes liquidity, because the unexpected has no set date.",
          ],
        ),
      ],
    ),
  ];

  // ── Lessons — es ──────────────────────────────────────────────────────

  static const List<Lesson> lessonsEs = [
    Lesson(
      id: 'money_fundamentals_what_is_money',
      moduleId: 'money_fundamentals',
      title: '¿Qué es el Dinero?',
      order: 1,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Las tres funciones del dinero',
          body:
              'El dinero es cualquier cosa ampliamente aceptada para intercambiar por bienes y servicios. Cumple '
              'tres funciones: es medio de intercambio (todos aceptan recibirlo en lugar de otro producto), '
              'reserva de valor (puedes guardarlo y usarlo después) y unidad de cuenta (permite comparar el '
              'precio de cosas muy distintas, como un corte de cabello y una docena de huevos). Antes del dinero, '
              'las personas intercambiaban bienes directamente — el trueque —, pero eso solo funciona cuando '
              'ambas partes quieren exactamente lo que la otra tiene.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Imagina que cortas cabello y necesitas huevos. Con el trueque, solo consigues los huevos si '
              'encuentras a alguien que críe gallinas y que, además, necesite cortarse el cabello ese mismo día. '
              'Con dinero, le cortas el cabello a cualquier cliente, recibes dinero y compras huevos a quien sea '
              'que los venda — sin necesitar una coincidencia de intereses.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Por qué es difícil sostener el trueque (intercambiar bienes directamente) en una economía grande?',
          options: [
            'Porque los bienes no pueden intercambiarse entre desconocidos',
            'Porque exige encontrar a alguien que quiera exactamente lo que ofreces, en el momento justo',
            'Porque es ilegal en la mayoría de los países',
            'Porque los bienes no tienen valor sin dinero',
          ],
          correctIndex: 1,
          explanation:
              'El trueque depende de esta "doble coincidencia de deseos" — encontrar a alguien que tenga lo que '
              'quieres y quiera lo que tienes. El dinero elimina ese requisito, permitiendo intercambios con '
              'cualquier persona.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt: 'Una pequeña panadería decide pagarle a sus empleados con pan y pasteles en lugar de dinero. ¿Qué problema probablemente genera esto?',
          options: [
            'Ninguno, el pan y los pasteles también son medios de intercambio aceptados en cualquier comercio',
            'Los empleados podrían no poder usar pan y pasteles para pagar el alquiler, la luz u otras cuentas',
            'Esto solo sería un problema si la panadería fuera muy pequeña',
            'El pan tiene mejor reserva de valor que el dinero',
          ],
          correctIndex: 1,
          explanation:
              'El pan y los pasteles se echan a perder y no son ampliamente aceptados como pago en otros lugares '
              '— fallan como reserva de valor y como medio de intercambio general. Eso es exactamente lo que '
              'resuelve el dinero.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'El dinero es medio de intercambio, reserva de valor y unidad de cuenta.',
            'El trueque exige una coincidencia de intereses difícil de sostener a gran escala.',
            'El dinero funciona porque es ampliamente aceptado, duradero y fácil de comparar.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_income_and_expenses',
      moduleId: 'money_fundamentals',
      title: 'Ingresos y Gastos',
      order: 2,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Los dos extremos de tu flujo de caja',
          body:
              'Tu vida financiera tiene dos extremos: los ingresos (todo lo que entra — salario, trabajos '
              'independientes, rendimientos) y los gastos (todo lo que sale). Los gastos fijos se repiten cada '
              'mes con un valor similar, como el alquiler o el plan de celular. Los gastos variables cambian de '
              'valor o de existencia mes a mes, como comer fuera de casa u ocio. Entender esta división es el '
              'primer paso antes de cualquier plan financiero.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Una persona recibe R\$3.000 al mes. Sus gastos fijos suman R\$1.500 (alquiler, internet, plan de '
              'celular). Sus gastos variables en un mes típico suman R\$900 (mercado, transporte, ocio). Eso le '
              'deja R\$600 libres para ahorrar, invertir o imprevistos ese mes.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Cuál de las siguientes opciones es un ejemplo de gasto variable?',
          options: [
            'Alquiler',
            'Gastos de ocio del fin de semana',
            'Mensualidad de internet',
            'Cuota fija de un préstamo',
          ],
          correctIndex: 1,
          explanation:
              'Los gastos de ocio cambian de valor (y a veces ni siquiera ocurren) de un mes a otro — por eso son '
              'un gasto variable, a diferencia del alquiler o internet, que se repiten con un valor similar.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Una persona nota que sus ingresos cubren sus gastos fijos, pero al final del mes nunca le sobra '
              'dinero y no sabe adónde se fue. ¿Cuál es el primer paso más útil?',
          options: [
            'Pedir un aumento de salario de inmediato',
            'Registrar durante un mes cuánto se está gastando en gastos variables, y en qué',
            'Dejar de gastar en todo lo que no sea fijo',
            'Asumir que esto es normal y no se puede cambiar',
          ],
          correctIndex: 1,
          explanation:
              'Antes de recortar gastos o buscar más ingresos, hay que ver adónde está yendo el dinero — '
              'normalmente es en los gastos variables, que pasan desapercibidos, donde el dinero "desaparece".',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'Los ingresos son lo que entra; los gastos son lo que sale — el equilibrio entre ambos es tu flujo '
                'de caja.',
            'Los gastos fijos se repiten con un valor similar; los variables cambian mes a mes.',
            'Antes de recortar gastos, hay que saber exactamente adónde está yendo el dinero.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_needs_vs_wants',
      moduleId: 'money_fundamentals',
      title: 'Necesidades vs. Deseos',
      order: 3,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'No todo lo que parece esencial lo es',
          body:
              'Las necesidades son gastos esenciales para vivir y trabajar: vivienda, alimentación básica, '
              'transporte, salud. Los deseos son gastos que aportan comodidad o placer, pero no son '
              'indispensables: cenar fuera, ropa de marca, el modelo más nuevo de celular. Ninguno de los dos '
              'está "mal" — pero confundir un deseo con una necesidad es lo que más distorsiona un presupuesto, '
              'porque hace parecer que no hay espacio para recortar cuando en realidad sí lo hay.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Alguien dice que "necesita" pagar tres servicios de streaming diferentes, porque cada uno tiene '
              'una serie que sigue. Reclasificando con honestidad: ver series es un deseo legítimo, pero mantener '
              'los tres al mismo tiempo — en vez de alternar uno por mes — es una elección, no una necesidad.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Cuál de las siguientes opciones es, para la mayoría de las personas, una necesidad y no un deseo?',
          options: [
            'Cenar en restaurantes cada semana',
            'Un medicamento de uso continuo recetado por un médico',
            'El lanzamiento más reciente de un celular',
            'Un segundo auto para uso ocasional',
          ],
          correctIndex: 1,
          explanation:
              'Un medicamento de uso continuo recetado por un médico es esencial para la salud — una necesidad '
              'real. Las demás opciones aportan comodidad o estatus, pero normalmente pueden posponerse o '
              'reducirse sin un perjuicio directo.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Alguien con un presupuesto ajustado insiste en mantener el gimnasio más caro de la ciudad, '
              'diciendo que "necesita" ejercitarse. ¿Qué vale la pena que esa persona considere?',
          options: [
            'Que ejercitarse es una necesidad, así que el monto gastado no importa',
            'Que ejercitarse es importante, pero ese gimnasio específico y más caro es una elección entre varias '
                'formas posibles de cubrir esa necesidad',
            'Que debería dejar de ejercitarse por completo',
            'Que los gimnasios nunca caben en un presupuesto ajustado',
          ],
          correctIndex: 1,
          explanation:
              'La necesidad real detrás del ejemplo es "ejercitarse" — y existen varias formas de cubrirla, con '
              'costos muy distintos. Separar la necesidad de la forma específica (y más cara) de cubrirla abre '
              'espacio en el presupuesto sin renunciar a lo que importa.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'Las necesidades son esenciales; los deseos aportan comodidad, pero pueden posponerse o reducirse.',
            'Confundir un deseo con una necesidad esconde espacio real para recortar en el presupuesto.',
            'Muchas veces la necesidad es legítima, pero la forma elegida de cubrirla es la que resulta cara.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_organizing_your_money',
      moduleId: 'money_fundamentals',
      title: 'Organizando tu Dinero',
      order: 4,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'No puedes cambiar lo que no ves',
          body:
              'Antes de intentar ahorrar o invertir, hay que saber exactamente adónde está yendo el dinero. '
              'Registrar los gastos — en una hoja de cálculo, una aplicación o incluso un cuaderno — revela '
              'patrones que la memoria por sí sola no capta. No existe un método "correcto": el mejor es el que '
              'realmente vas a seguir usando.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Dos personas con el mismo ingreso: una anota todos sus gastos en una aplicación desde hace tres '
              'meses y sabe exactamente cuánto gasta en delivery; la otra "cree" que gasta poco en eso, pero '
              'nunca lo verificó. Al revisar el estado de cuenta de su tarjeta, descubre que gastó R\$450 en '
              'delivery solo el último mes — mucho más de lo que imaginaba.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Cuál es el principal beneficio de registrar tus gastos, incluso antes de intentar ahorrar?',
          options: [
            'Registrar los gastos reduce automáticamente tus gastos',
            'Ver patrones reales de gasto, que la memoria sola suele subestimar u ocultar',
            'Es exigido por ley',
            'Solo sirve para quien ya tiene mucho dinero',
          ],
          correctIndex: 1,
          explanation:
              'Registrar no recorta gastos por sí solo — pero revela adónde va realmente el dinero, algo que '
              'suele sorprender incluso a quienes se consideran cuidadosos.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Alguien intenta ahorrar "de memoria", sin anotar nada, recortando lo que recuerda haber gastado. '
              'Cada mes se equivoca en el cálculo de su saldo final. ¿Qué probablemente le falta?',
          options: [
            'Una inversión con mayor retorno',
            'Un registro real de los gastos, en lugar de depender solo de la memoria',
            'Un salario mayor',
            'Nada — esto es normal y no tiene solución',
          ],
          correctIndex: 1,
          explanation:
              'La memoria tiende a subestimar los gastos pequeños y frecuentes. Un registro real — incluso '
              'simple — cierra esa brecha entre lo que la persona cree que gasta y lo que realmente gasta.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'Hay que ver adónde va el dinero antes de intentar cambiar ese destino.',
            'La memoria subestima los gastos pequeños y recurrentes.',
            'El mejor método de registro es el que realmente vas a seguir usando — hoja de cálculo, aplicación o '
                'cuaderno.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_what_is_a_budget',
      moduleId: 'money_fundamentals',
      title: '¿Qué es un Presupuesto?',
      order: 5,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Un plan, no una prisión',
          body:
              'Un presupuesto es un plan que organiza cómo se distribuirán tus ingresos entre gastos, ahorro y '
              'objetivos — no una lista de prohibiciones. Un presupuesto bien hecho da claridad sobre cuánto '
              'puedes gastar en cada área sin comprometer lo que es prioritario, en lugar de generar culpa con '
              'cada compra.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Una forma simple de estructurar un presupuesto es pensar en tres grandes porciones del ingreso: '
              'una parte para lo esencial (vivienda, cuentas, alimentación), una parte para lo que aporta calidad '
              'de vida (ocio, pasatiempos) y una parte reservada para objetivos futuros (ahorrar, invertir, pagar '
              'deudas). Las proporciones exactas varían de persona a persona — lo importante es que las tres '
              'porciones existan de forma consciente, en lugar de que la última quede solo con lo que sobre.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Cuál es la mejor forma de describir un presupuesto?',
          options: [
            'Una lista rígida de cosas prohibidas para comprar',
            'Un plan que organiza el ingreso entre gastos, calidad de vida y objetivos futuros',
            'Una herramienta útil solo para quien ya está endeudado',
            'Un cálculo que solo tiene sentido una vez en la vida',
          ],
          correctIndex: 1,
          explanation:
              'Un presupuesto no se trata de prohibir — se trata de decidir con anticipación cómo se distribuirá '
              'el ingreso, para que los objetivos futuros también tengan un espacio garantizado, y no solo lo '
              'que sobre.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Alguien dice que "el presupuesto es cosa de quien tiene poco dinero" y por eso nunca hizo uno. '
              '¿Qué deja de considerar esta visión?',
          options: [
            'Tiene razón — quien gana bien no necesita presupuesto',
            'Un presupuesto ayuda a dirigir el ingreso hacia objetivos de forma intencional, en cualquier nivel '
                'de ingreso',
            'El presupuesto solo sirve para controlar deudas',
            'El presupuesto es una herramienta anticuada',
          ],
          correctIndex: 1,
          explanation:
              'Incluso con un ingreso alto, sin un plan es común que los gastos crezcan para llenar todo lo que '
              'entra, dejando poco espacio para objetivos de largo plazo — un presupuesto ayuda a evitar eso, sin '
              'importar cuánto se gane.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'Un presupuesto es un plan de distribución del ingreso, no una lista de prohibiciones.',
            'Un buen presupuesto reserva espacio para lo esencial, la calidad de vida y los objetivos futuros.',
            'Tener un ingreso alto no elimina la utilidad de un presupuesto.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_building_your_first_budget',
      moduleId: 'money_fundamentals',
      title: 'Construyendo tu Primer Presupuesto',
      order: 6,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Cuatro pasos simples',
          body:
              'Armar un primer presupuesto implica cuatro pasos: primero, lista todo tu ingreso mensual; segundo, '
              'lista todos tus gastos (usa los últimos meses como referencia, si tienes registros); tercero, '
              'agrupa los gastos en categorías, como vivienda, alimentación y ocio; cuarto, define una meta de '
              'cuánto quieres lograr ahorrar o invertir cada mes, aunque sea un monto pequeño al principio.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Ingreso mensual: R\$2.800. Gastos listados y categorizados: vivienda R\$900, alimentación R\$700, '
              'transporte R\$300, ocio R\$300, otros R\$200 — un total de R\$2.400. La persona define una meta de '
              'ahorrar R\$400 al mes, que es exactamente lo que sobra después de cubrir todas las categorías.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Cuál es el orden correcto de los pasos para armar un primer presupuesto?',
          options: [
            'Definir la meta de ahorro, y después ver cuánto ingreso sobró',
            'Listar ingresos, listar gastos, categorizarlos, y luego definir una meta de ahorro',
            'Categorizar los gastos antes incluso de saber cuáles son',
            'No hace falta listar nada, basta con una estimación general',
          ],
          correctIndex: 1,
          explanation:
              'El orden importa: solo es posible definir una meta de ahorro realista después de saber exactamente '
              'cuánto entra (ingreso) y cuánto sale (gastos categorizados).',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Al armar el presupuesto, alguien nota que sus gastos listados suman más que su ingreso mensual. '
              '¿Qué tiene más sentido hacer a continuación?',
          options: [
            'Ignorar la diferencia y esperar que salga bien',
            'Revisar las categorías para identificar dónde hay espacio para reducir, antes de asumir más deuda',
            'Desistir de hacer un presupuesto, ya que de todos modos no va a funcionar',
            'Aumentar el límite de la tarjeta de crédito para cubrir la diferencia',
          ],
          correctIndex: 1,
          explanation:
              'Un presupuesto que no cierra es justamente la señal más valiosa que puede dar — es la oportunidad '
              'de revisar categorías y ajustar antes de que la diferencia se convierta en deuda.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'Armar un presupuesto sigue un orden: listar ingresos, listar gastos, categorizar, definir meta de '
                'ahorro.',
            'Un presupuesto que no cierra es una señal para revisar categorías, no un motivo para desistir.',
            'Incluso una meta de ahorro pequeña, si es realista, es un buen punto de partida.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_conscious_consumption',
      moduleId: 'money_fundamentals',
      title: 'Consumo Consciente',
      order: 7,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'La pausa antes de comprar',
          body:
              'Las compras por impulso ocurren cuando una decisión se toma en el calor del momento, muchas veces '
              'ligada a una emoción — estrés, aburrimiento, ansiedad — en lugar de una necesidad real. El consumo '
              'consciente no significa nunca comprar por placer, sino crear una pausa entre el deseo y la compra, '
              'para decidir con más claridad si ese gasto realmente vale la pena en ese momento.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Alguien ve unas zapatillas en oferta durante un día estresante en el trabajo y las compra en el '
              'acto, sin pensar, "para sentirse mejor". Otra persona, al ver las mismas zapatillas, anota el '
              'artículo y espera tres días antes de decidir. Pasado ese tiempo, se da cuenta de que ya tenía unas '
              'parecidas y decide no comprarlas — ahorrando ese dinero para otro objetivo.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Qué caracteriza a una compra por impulso?',
          options: [
            'Cualquier compra hecha en una tienda física',
            'Una decisión tomada rápidamente, muchas veces ligada a una emoción, sin reflexionar sobre la '
                'necesidad real',
            'Cualquier compra por encima de cierto monto',
            'Una compra planeada con anticipación',
          ],
          correctIndex: 1,
          explanation:
              'Lo que define una compra por impulso no es el monto gastado, sino la ausencia de reflexión — la '
              'decisión nace de la emoción del momento, no de una evaluación sobre si eso es realmente una '
              'prioridad.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Alguien quiere reducir las compras por impulso, pero no quiere dejar de darse un gusto de vez en '
              'cuando. ¿Qué estrategia cumple ambos objetivos?',
          options: [
            'No volver a comprar nada que no sea esencial',
            'Crear una regla personal, como esperar 48 horas antes de compras no planeadas, manteniendo espacio '
                'en el presupuesto para gustos ocasionales',
            'Comprar por impulso solo en ofertas, ya que "es más barato"',
            'Eliminar todas las aplicaciones de compra, sin ninguna otra estrategia',
          ],
          correctIndex: 1,
          explanation:
              'El consumo consciente no es privación total — es crear un espacio de reflexión antes de comprar y, '
              'al mismo tiempo, reservar deliberadamente una parte del presupuesto para gustos, para que sean una '
              'elección, no un impulso.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'Las compras por impulso suelen nacer de emociones del momento, no de una necesidad real.',
            'Una pausa entre el deseo y la compra ayuda a decidir con más claridad.',
            'El consumo consciente no es nunca comprar por placer — es hacerlo de forma deliberada.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_financial_goals',
      moduleId: 'money_fundamentals',
      title: 'Objetivos Financieros',
      order: 8,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'De "quiero ahorrar más" a un plan de verdad',
          body:
              'Los objetivos financieros pueden ser de corto plazo (hasta 1 año, como un viaje), mediano plazo '
              '(1 a 5 años, como un auto) o largo plazo (más de 5 años, como la jubilación). Un objetivo vago, '
              'como "quiero ahorrar más", rara vez se convierte en una acción concreta. Un objetivo específico '
              '— con un monto y un plazo definidos — le da a tu presupuesto un blanco claro al cual apuntar.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'En vez de decir "quiero ahorrar más", alguien define: "quiero juntar R\$6.000 en 12 meses para un '
              'fondo de emergencia". Eso significa guardar R\$500 al mes — un número que puede comparar '
              'directamente con lo que le sobra en su presupuesto y ajustar si es necesario.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Qué hace que un objetivo financiero sea más útil que una intención vaga como "quiero ahorrar más"?',
          options: [
            'El hecho de ser un objetivo de largo plazo',
            'Tener un monto y un plazo definidos, que permiten calcular cuánto ahorrar cada mes',
            'Que el objetivo esté relacionado con inversiones',
            'Ser un número redondo, como R\$1.000',
          ],
          correctIndex: 1,
          explanation:
              'Un monto y un plazo transforman la intención en un número mensual concreto — es eso lo que '
              'permite comparar el objetivo con el presupuesto real y saber si es viable.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Alguien define como objetivo: "juntar R\$4.800 en 12 meses". Al calcular, se da cuenta de que '
              'necesitaría guardar R\$400 al mes, pero su presupuesto solo permite R\$250. ¿Qué tiene más sentido '
              'revisar?',
          options: [
            'Nada, solo hay que seguir intentando guardar R\$400 aunque no sobre ese monto',
            'El plazo del objetivo, el monto total, o dónde reducir gastos — para alinear el objetivo con la '
                'realidad del presupuesto',
            'Desistir del objetivo por completo',
            'Contraer una deuda para cubrir la diferencia',
          ],
          correctIndex: 1,
          explanation:
              'Cuando el número mensual necesario no cabe en el presupuesto, hay que revisar el objetivo (monto, '
              'plazo) o el presupuesto (gastos) — preferiblemente antes de simplemente intentar forzar algo que '
              'no es sostenible.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'Los objetivos financieros pueden ser de corto, mediano o largo plazo.',
            'Un objetivo con monto y plazo definidos se convierte en un número mensual concreto para ahorrar.',
            'Cuando el número no cabe en el presupuesto, es hora de revisar el objetivo o los gastos — no de '
                'ignorar la diferencia.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_emergency_funds',
      moduleId: 'money_fundamentals',
      title: 'Fondo de Emergencia',
      order: 9,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Un colchón para los imprevistos',
          body:
              'El fondo de emergencia es una cantidad guardada específicamente para cubrir imprevistos — pérdida '
              'de ingresos, una reparación urgente, un gasto médico inesperado — sin tener que recurrir a deudas. '
              'Una referencia común es guardar entre 3 y 6 meses de gastos esenciales, aunque el número ideal '
              'depende de la estabilidad de tu ingreso. Lo más importante no es exactamente dónde está ese '
              'dinero, sino que esté en algo con alta liquidez — es decir, fácil y rápido de retirar sin '
              'pérdidas, ya que no sabes cuándo lo vas a necesitar.',
        ),
        ExampleStep(
          title: 'En la práctica',
          body:
              'Dos personas pierden su empleo el mismo mes. Una tenía 4 meses de gastos guardados en algo de '
              'fácil acceso y logra cubrir sus cuentas mientras busca un nuevo ingreso, sin endeudarse. La otra '
              'no tenía ningún fondo y necesita usar la tarjeta de crédito para pagar el alquiler y las cuentas '
              'básicas, entrando en un ciclo de deuda con intereses altos ya en el primer mes sin ingresos.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt: '¿Por qué la liquidez es una característica tan importante específicamente para el fondo de emergencia?',
          options: [
            'Porque las emergencias ocurren en fechas predecibles',
            'Porque no sabes cuándo vas a necesitar el dinero, y necesitas poder acceder a él rápidamente y sin '
                'pérdidas',
            'Porque las inversiones líquidas siempre rinden más',
            'La liquidez no importa para este tipo de fondo',
          ],
          correctIndex: 1,
          explanation:
              'El propósito del fondo de emergencia es estar disponible exactamente cuando ocurre un imprevisto '
              '— que, por definición, no tiene fecha marcada. Por eso la liquidez importa más, para este fondo '
              'específico, que buscar el mayor retorno posible.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Alguien tiene R\$5.000 guardados y está decidiendo entre mantener todo como fondo de emergencia o '
              'poner buena parte en algo que rinde más, pero que tarda días en retirarse sin pérdidas. ¿Qué vale '
              'la pena considerar antes de decidir?',
          options: [
            'Que el fondo de emergencia no necesita liquidez, solo buen retorno',
            'Que, si todo el dinero queda difícil de retirar rápidamente, un imprevisto podría obligarla a '
                'recurrir a deudas aunque tenga ese monto guardado',
            'Que las emergencias nunca ocurren, así que no hay motivo de preocupación',
            'Que cualquier monto guardado ya es suficiente, sin importar dónde esté',
          ],
          correctIndex: 1,
          explanation:
              'Tener R\$5.000 "guardados" no ayuda en una emergencia si el dinero no puede retirarse rápidamente '
              'cuando se necesita — el valor del fondo de emergencia está tanto en el monto como en la facilidad '
              'de retirarlo.',
        ),
        SummaryStep(
          title: 'Lo que aprendiste',
          takeaways: [
            'El fondo de emergencia cubre imprevistos sin tener que recurrir a deudas.',
            'Una referencia común es entre 3 y 6 meses de gastos esenciales.',
            'La liquidez importa más en este fondo que buscar el mayor retorno posible, porque no eliges cuándo '
                'lo vas a necesitar.',
          ],
        ),
      ],
    ),
    Lesson(
      id: 'money_fundamentals_review',
      moduleId: 'money_fundamentals',
      title: 'Revisión',
      order: 10,
      xpReward: 20,
      steps: [
        ExplanationStep(
          title: 'Uniendo las piezas',
          body:
              'Ya viste conceptos que se conectan entre sí: qué es el dinero y por qué existe, cómo organizar '
              'ingresos y gastos, la diferencia entre necesidades y deseos, cómo registrar tus gastos, qué es un '
              'presupuesto y cómo armar uno, el consumo consciente, los objetivos financieros específicos y el '
              'fondo de emergencia. Juntas, estas ideas forman la base para administrar bien tu propio dinero — '
              'incluso antes de pensar en invertir.',
        ),
        ExampleStep(
          title: 'Uniendo todo',
          body:
              'Marina recibe R\$3.500 al mes. Empezó a registrar sus gastos en una aplicación y notó que gastaba '
              'R\$400 al mes en compras por impulso — muchas veces cosas que confundía con necesidades. Armó un '
              'presupuesto simple, definió el objetivo de juntar R\$6.000 en 12 meses (R\$500 al mes) para un '
              'fondo de emergencia, y comenzó a esperar 48 horas antes de cualquier compra no planeada. Después '
              'de algunos meses, su fondo crece de forma constante, guardado en algo fácil de retirar en caso de '
              'necesitarlo.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.microExercise,
          prompt:
              'En el ejemplo de Marina, ¿qué la ayudó a descubrir que gastaba R\$400 al mes en compras por '
              'impulso, algo que antes no notaba?',
          options: [
            'Haber aumentado el límite de la tarjeta de crédito',
            'Registrar sus gastos, en lugar de confiar solo en la memoria',
            'Haber dejado de trabajar',
            'Haber contratado más servicios de streaming',
          ],
          correctIndex: 1,
          explanation:
              'Fue el hábito de registrar los gastos lo que reveló el patrón real de compras por impulso de '
              'Marina — sin ese registro, ese monto probablemente seguiría pasando desapercibido, como ocurre '
              'con la mayoría de las personas que nunca hicieron seguimiento de sus gastos.',
        ),
        ChoiceQuestionStep(
          framing: ChoiceStepFraming.apply,
          prompt:
              'Marina definió el objetivo de juntar R\$6.000 en 12 meses para su fondo de emergencia. ¿Por qué '
              'tiene sentido que ese dinero esté en algo fácil de retirar, en lugar de en algo que rinde más '
              'pero tarda días en retirarse?',
          options: [
            'Porque el fondo de emergencia no debería rendir nada',
            'Porque ella no sabe cuándo va a necesitar ese dinero, y un imprevisto puede exigir acceso rápido a '
                'él',
            'Porque no hace ninguna diferencia dónde esté ese dinero',
            'Porque las inversiones de fácil retiro siempre están prohibidas para el fondo de emergencia',
          ],
          correctIndex: 1,
          explanation:
              'La función del fondo de emergencia es estar disponible cuando ocurre un imprevisto — y los '
              'imprevistos no avisan con anticipación. Por eso la liquidez, y no el retorno, es la prioridad para '
              'ese dinero específico.',
        ),
        SummaryStep(
          title: '¡Módulo completado!',
          takeaways: [
            'El dinero existe para facilitar intercambios, guardar valor y comparar precios.',
            'Organizar ingresos y gastos, y registrar los gastos, es la base antes de cualquier objetivo '
                'financiero.',
            'Separar necesidades de deseos ayuda a encontrar espacio real en el presupuesto.',
            'Un presupuesto es un plan — no una prohibición — y los objetivos específicos (monto + plazo) lo '
                'hacen accionable.',
            'El fondo de emergencia prioriza la liquidez, porque los imprevistos no tienen fecha marcada.',
          ],
        ),
      ],
    ),
  ];
}
