import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:expense_tracker/features/dashboard/view/stats/widgets/chart_type_toggle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatData {
  final String title;
  final Color color;
  final IconData icon;
  final double amount;
  const CatData({
    required this.title,
    required this.color,
    required this.icon,
    required this.amount,
  });
}

class BarEntry {
  final String label;
  final double value;
  const BarEntry({required this.label, required this.value});
}

class StatChart extends StatelessWidget {
  final ChartType chartType;
  final bool isCategory;
  final bool isIncome;
  final List<CatData> catList;
  final double catTotal;
  final List<BarEntry> barEntries;
  final double totalIncome;
  final double totalExpense;

  const StatChart({
    super.key,
    required this.chartType,
    required this.isCategory,
    required this.isIncome,
    required this.catList,
    required this.catTotal,
    required this.barEntries,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ✅ reads currency reactively
    final currency = context.watch<CurrencyController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCategory
          ? _buildCategoryChart(catList, catTotal, colorScheme, theme)
          : _buildTransactionChart(colorScheme, theme, currency.symbol),
    );
  }

  Widget _buildCategoryChart(
      List<CatData> cats, double total, ColorScheme cs, ThemeData theme) {
    if (cats.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No data')));
    }

    if (chartType == ChartType.donut) {
      return SizedBox(
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              sections: cats.map((c) {
                final pct = total > 0 ? c.amount / total * 100 : 0.0;
                return PieChartSectionData(
                  color: c.color,
                  value: c.amount,
                  title: '${pct.toStringAsFixed(1)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              }).toList(),
            )),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cats.first.title,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor)),
                Text(
                  '${(cats.first.amount / total * 100).toStringAsFixed(1)}%',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (chartType == ChartType.bar) {
      return SizedBox(
        height: 220,
        child: BarChart(BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: _bottomTitles(
              (i) => i < cats.length
                  ? (cats[i].title.length > 5
                      ? cats[i].title.substring(0, 5)
                      : cats[i].title)
                  : '',
              theme),
          barGroups: cats.asMap().entries.map((e) {
            return BarChartGroupData(x: e.key, barRods: [
              BarChartRodData(
                  toY: e.value.amount,
                  color: e.value.color,
                  width: 18,
                  borderRadius: BorderRadius.circular(6)),
            ]);
          }).toList(),
        )),
      );
    }

    return SizedBox(
      height: 220,
      child: LineChart(LineChartData(
        gridData: _gridData(theme),
        borderData: FlBorderData(show: false),
        titlesData: _bottomTitles(
            (i) => i < cats.length
                ? (cats[i].title.length > 4
                    ? cats[i].title.substring(0, 4)
                    : cats[i].title)
                : '',
            theme),
        lineBarsData: [
          LineChartBarData(
            spots: cats
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.amount))
                .toList(),
            isCurved: true,
            color: cs.primary,
            barWidth: 3,
            dotData: FlDotData(
              getDotPainter: (_, __, ___, i) => FlDotCirclePainter(
                radius: 4,
                color: cats[i].color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
                show: true, color: cs.primary.withValues(alpha: 0.08)),
          ),
        ],
      )),
    );
  }

  // ✅ currencySymbol passed in as param (StatChart is a StatelessWidget
  //    so we can't call context.watch inside a helper — we pass it from build)
  Widget _buildTransactionChart(
      ColorScheme cs, ThemeData theme, String currencySymbol) {
    if (barEntries.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No data')));
    }

    final barColor = isIncome ? cs.primary : cs.error;
    final displayTotal = isIncome ? totalIncome : totalExpense;

    if (chartType == ChartType.donut) {
      return SizedBox(
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              sections: [
                PieChartSectionData(
                  color: barColor,
                  value: displayTotal > 0 ? displayTotal : 1,
                  title: displayTotal > 0 ? '100%' : '',
                  radius: 50,
                  titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            )),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isIncome ? 'Income' : 'Expense',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
                Text(
                  // ✅ dynamic symbol instead of hardcoded "PKR"
                  '$currencySymbol${displayTotal.toStringAsFixed(0)}',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (chartType == ChartType.bar) {
      return SizedBox(
        height: 220,
        child: BarChart(BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          groupsSpace: 12,
          titlesData: _bottomTitles(
              (i) => i < barEntries.length ? barEntries[i].label : '', theme),
          barGroups: barEntries.asMap().entries.map((e) {
            return BarChartGroupData(x: e.key, barRods: [
              BarChartRodData(
                  toY: e.value.value,
                  color: barColor,
                  width: 16,
                  borderRadius: BorderRadius.circular(6)),
            ]);
          }).toList(),
        )),
      );
    }

    return SizedBox(
      height: 220,
      child: LineChart(LineChartData(
        gridData: _gridData(theme),
        borderData: FlBorderData(show: false),
        titlesData: _bottomTitles(
            (i) => i < barEntries.length ? barEntries[i].label : '', theme),
        lineBarsData: [
          _lineBar(
            barEntries
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            barColor,
          ),
        ],
      )),
    );
  }

  FlGridData _gridData(ThemeData theme) => FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: theme.dividerColor.withValues(alpha: 0.2),
          strokeWidth: 1,
        ),
      );

  FlTitlesData _bottomTitles(String Function(int) label, ThemeData theme) =>
      FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (val, _) {
              final l = label(val.toInt());
              if (l.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(l,
                    style: TextStyle(fontSize: 10, color: theme.hintColor)),
              );
            },
          ),
        ),
      );

  LineChartBarData _lineBar(List<FlSpot> spots, Color color) =>
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 3,
        dotData: const FlDotData(show: false),
        belowBarData:
            BarAreaData(show: true, color: color.withValues(alpha: 0.08)),
      );
}
