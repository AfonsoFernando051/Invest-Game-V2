import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/theme/app_radii.dart';
import 'package:petrimonium/core/theme/app_spacing.dart';
import 'package:petrimonium/core/theme/background_presets.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/chart_legend.dart';
import 'package:petrimonium/core/widgets/cosmic_background.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';
import 'package:petrimonium/core/widgets/tooltip_summary.dart';
import 'package:petrimonium/features/academy/domain/services/compound_interest_calculator.dart';
import 'package:petrimonium/features/portfolio/presentation/widgets/shared/formatters.dart';

/// The Financial Lab's Compound Interest simulator
/// (`docs/ACADEMY_ENGINE.md` §3d, brief §27/28) — sliders drive
/// [CompoundInterestCalculator.simulate] live; the chart and explanatory
/// sentence always reflect the current inputs. No persistence, no XP: a
/// sandbox for building intuition, not a graded activity.
class CompoundInterestLabScreen extends StatefulWidget {
  const CompoundInterestLabScreen({super.key});

  @override
  State<CompoundInterestLabScreen> createState() => _CompoundInterestLabScreenState();
}

class _CompoundInterestLabScreenState extends State<CompoundInterestLabScreen> {
  double _initialAmount = 1000;
  double _monthlyContribution = 200;
  double _annualRatePercent = 8;
  int _years = 10;

  String? _explanationKey;
  Map<String, String> _explanationParams = const {};
  int? _touchedIndex;

  CompoundInterestResult get _result => CompoundInterestCalculator.simulate(
        initialAmount: _initialAmount,
        monthlyContribution: _monthlyContribution,
        annualRatePercent: _annualRatePercent,
        years: _years,
      );

  void _onYearsChanged(double value) {
    final newYears = value.round();
    if (newYears == _years) return;
    setState(() {
      _explanationKey = newYears > _years ? AppStrings.labExplanationIncreaseYears : AppStrings.labExplanationDecreaseYears;
      _explanationParams = {'from': '$_years', 'to': '$newYears'};
      _years = newYears;
    });
  }

  void _onReturnChanged(double value) {
    final rounded = double.parse(value.toStringAsFixed(1));
    if (rounded == _annualRatePercent) return;
    setState(() {
      _explanationKey =
          rounded > _annualRatePercent ? AppStrings.labExplanationIncreaseReturn : AppStrings.labExplanationDecreaseReturn;
      _explanationParams = {'from': _annualRatePercent.toStringAsFixed(1), 'to': rounded.toStringAsFixed(1)};
      _annualRatePercent = rounded;
    });
  }

  void _onInitialAmountChanged(double value) {
    setState(() {
      _initialAmount = value;
      _explanationKey = null;
    });
  }

  void _onMonthlyContributionChanged(double value) {
    setState(() {
      _monthlyContribution = value;
      _explanationKey = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final result = _result;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          Translator.translate(AppStrings.compoundInterestLabTitle),
          style: TextStyle(color: tokens.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
      ),
      body: CosmicBackground(
        intensity: BackgroundIntensity.focus,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputs(tokens),
                const SizedBox(height: AppSpacing.xl),
                _buildSummary(tokens, result),
                const SizedBox(height: AppSpacing.lg),
                _buildChart(tokens, result),
                const SizedBox(height: AppSpacing.lg),
                _buildExplanation(tokens),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputs(AppColorTokens tokens) {
    return GlassCard(
      borderRadius: AppRadii.xl,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sliderRow(
              tokens,
              label: Translator.translate(AppStrings.labInitialAmountLabel),
              valueLabel: PortfolioFormatters.currency(_initialAmount, showCents: false),
              value: _initialAmount,
              min: 0,
              max: 100000,
              divisions: 100,
              onChanged: _onInitialAmountChanged,
            ),
            _sliderRow(
              tokens,
              label: Translator.translate(AppStrings.labMonthlyContributionLabel),
              valueLabel: PortfolioFormatters.currency(_monthlyContribution, showCents: false),
              value: _monthlyContribution,
              min: 0,
              max: 5000,
              divisions: 100,
              onChanged: _onMonthlyContributionChanged,
            ),
            _sliderRow(
              tokens,
              label: Translator.translate(AppStrings.labAnnualReturnLabel),
              valueLabel: '${_annualRatePercent.toStringAsFixed(1)}%',
              value: _annualRatePercent,
              min: 0,
              max: 30,
              divisions: 60,
              onChanged: _onReturnChanged,
            ),
            _sliderRow(
              tokens,
              label: Translator.translate(AppStrings.labYearsLabel),
              valueLabel: '$_years',
              value: _years.toDouble(),
              min: 1,
              max: 40,
              divisions: 39,
              onChanged: _onYearsChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderRow(
    AppColorTokens tokens, {
    required String label,
    required String valueLabel,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: tokens.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            Text(valueLabel, style: TextStyle(color: tokens.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.neonCyan,
            inactiveTrackColor: tokens.textPrimary.withValues(alpha: 0.08),
            thumbColor: AppColors.neonCyan,
            overlayColor: AppColors.neonCyan.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(AppColorTokens tokens, CompoundInterestResult result) {
    return Row(
      children: [
        Expanded(child: _statCard(tokens, AppStrings.labFinalValueLabel, result.finalValue, AppColors.goldenBorder)),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(tokens, AppStrings.labTotalContributionsLabel, result.totalContributions, AppColors.neonCyan),
        ),
        const SizedBox(width: 10),
        Expanded(child: _statCard(tokens, AppStrings.labTotalGrowthLabel, result.totalGrowth, AppColors.neonViolet)),
      ],
    );
  }

  Widget _statCard(AppColorTokens tokens, String labelKey, double value, Color accent) {
    return GlassCard(
      borderColor: accent.withValues(alpha: 0.3),
      borderRadius: 14,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translator.translate(labelKey),
              maxLines: 2,
              style: TextStyle(color: tokens.textTertiary, fontSize: 10, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              PortfolioFormatters.compactCurrency(value),
              style: TextStyle(color: accent, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(AppColorTokens tokens, CompoundInterestResult result) {
    final buckets = result.yearlyBreakdown;
    final contributionsColor = AppColors.neonCyan;
    final growthColor = AppColors.goldenBorder;

    return GlassCard(
      borderRadius: AppRadii.xl,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChartLegend(items: [
              ChartLegendItem(color: contributionsColor, label: Translator.translate(AppStrings.labTotalContributionsLabel)),
              ChartLegendItem(color: growthColor, label: Translator.translate(AppStrings.labTotalGrowthLabel)),
            ]),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 200,
              child: buckets.length < 2
                  ? const SizedBox.shrink()
                  : BarChart(
                      _chartData(buckets, tokens, contributionsColor, growthColor),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    ),
            ),
            if (_touchedIndex != null && _touchedIndex! < buckets.length) ...[
              const SizedBox(height: AppSpacing.md),
              _tooltip(buckets[_touchedIndex!], tokens, contributionsColor, growthColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tooltip(CompoundInterestYearPoint point, AppColorTokens tokens, Color contributionsColor, Color growthColor) {
    final growth = point.value - point.contributions;
    return TooltipSummary(
      accentColor: contributionsColor,
      children: [
        Text(
          Translator.translate(AppStrings.labYearTooltipLabel, params: {'year': '${point.year}'}),
          style: TextStyle(color: tokens.textSecondary, fontSize: 11),
        ),
        Text(
          PortfolioFormatters.currency(point.contributions, showCents: false),
          style: TextStyle(color: contributionsColor, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          '+${PortfolioFormatters.currency(growth, showCents: false)}',
          style: TextStyle(color: growthColor, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  BarChartData _chartData(
    List<CompoundInterestYearPoint> buckets,
    AppColorTokens tokens,
    Color contributionsColor,
    Color growthColor,
  ) {
    final maxY = buckets.last.value * 1.15;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      minY: 0,
      maxY: maxY == 0 ? 1 : maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY == 0 ? 1 : maxY / 4,
        getDrawingHorizontalLine: (_) => FlLine(color: tokens.divider, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            interval: maxY == 0 ? 1 : maxY / 4,
            getTitlesWidget: (value, meta) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                PortfolioFormatters.compactCurrency(value),
                style: TextStyle(color: tokens.textSecondary, fontSize: 9),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: (buckets.length / 6).ceilToDouble().clamp(1, double.infinity),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= buckets.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('${buckets[index].year}', style: TextStyle(color: tokens.textSecondary, fontSize: 9)),
              );
            },
          ),
        ),
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(getTooltipItem: (a, b, c, d) => null),
        touchCallback: (event, response) {
          if (!event.isInterestedForInteractions || response == null || response.spot == null) {
            if (event is FlTapUpEvent || event is FlPanEndEvent || event is FlLongPressEnd) {
              setState(() => _touchedIndex = null);
            }
            return;
          }
          HapticFeedback.selectionClick();
          setState(() => _touchedIndex = response.spot!.touchedBarGroupIndex);
        },
      ),
      barGroups: [
        for (var i = 0; i < buckets.length; i++)
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: buckets[i].value,
                fromY: 0,
                width: 10,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                rodStackItems: [
                  BarChartRodStackItem(0, buckets[i].contributions, contributionsColor.withValues(alpha: i == _touchedIndex ? 1 : 0.85)),
                  BarChartRodStackItem(
                    buckets[i].contributions,
                    buckets[i].value,
                    growthColor.withValues(alpha: i == _touchedIndex ? 1 : 0.85),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildExplanation(AppColorTokens tokens) {
    final key = _explanationKey;
    final text = key == null
        ? Translator.translate(AppStrings.labExplanationInitial)
        : Translator.translate(key, params: _explanationParams);

    return GlassCard(
      borderColor: AppColors.neonViolet.withValues(alpha: 0.3),
      borderRadius: AppRadii.lg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline_rounded, color: AppColors.neonViolet, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: TextStyle(color: tokens.textSecondary, fontSize: 12, height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }
}
