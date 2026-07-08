import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/core/components/app_app_bar.dart';
import 'package:expense_tracker/core/components/app_toggle.dart';
import 'package:expense_tracker/core/components/category_stat_tile.dart';
import 'package:expense_tracker/core/components/transaction_tile.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/widgets/filter_chip.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:expense_tracker/features/dashboard/view/stats/widgets/chart_type_toggle.dart';
import 'package:expense_tracker/features/dashboard/view/stats/widgets/stat_chart.dart';
import 'package:expense_tracker/features/subscription/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum _TimeFilter { all, year, month }

enum _StatView { transactions, categories }

enum _IncomeExpenseTab { income, expense }

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  _TimeFilter _timeFilter = _TimeFilter.all;
  _StatView _statView = _StatView.transactions;
  ChartType _chartType = ChartType.donut;
  _IncomeExpenseTab _tab = _IncomeExpenseTab.income;

  List<TransactionModel> _filtered(List<TransactionModel> all) {
    final now = DateTime.now();
    return all.where((t) {
      if (_timeFilter == _TimeFilter.year) return t.dateTime.year == now.year;
      if (_timeFilter == _TimeFilter.month) {
        return t.dateTime.year == now.year && t.dateTime.month == now.month;
      }
      return true;
    }).toList();
  }

  Map<String, CatData> _categoryMap(
    List<TransactionModel> txns,
    _IncomeExpenseTab tab,
  ) {
    final type = tab == _IncomeExpenseTab.income
        ? TransactionType.income
        : TransactionType.expense;
    final map = <String, CatData>{};
    for (final t in txns.where((t) => t.type == type && t.category != null)) {
      final key = t.category!.title;
      map[key] = CatData(
        title: key,
        color: t.category!.color,
        icon: t.category!.icon,
        amount: (map[key]?.amount ?? 0) + t.amount,
      );
    }
    return map;
  }

  List<BarEntry> _barEntries(
    List<TransactionModel> txns,
    _IncomeExpenseTab tab,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final type = tab == _IncomeExpenseTab.income
        ? TransactionType.income
        : TransactionType.expense;
    final tabFiltered = txns.where((t) => t.type == type).toList();

    if (_timeFilter == _TimeFilter.month) {
      final Map<int, double> map = {};
      for (final t in tabFiltered) {
        final d = t.dateTime.day;
        map[d] = (map[d] ?? 0) + t.amount;
      }
      final sorted = map.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      return sorted
          .map((e) => BarEntry(label: '${e.key}', value: e.value))
          .toList();
    } else {
      final Map<int, double> map = {};
      for (final t in tabFiltered) {
        final m = t.dateTime.month;
        map[m] = (map[m] ?? 0) + t.amount;
      }
      final sorted = map.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      return sorted
          .map((e) => BarEntry(label: months[e.key - 1], value: e.value))
          .toList();
    }
  }

  // ── Empty state card ───────────────────────────────────────────────────────
  Widget _buildEmptyState(ThemeData theme, ColorScheme cs) {
    final isIncome = _tab == _IncomeExpenseTab.income;
    final filterLabel = switch (_timeFilter) {
      _TimeFilter.all => 'at all',
      _TimeFilter.year => 'this year',
      _TimeFilter.month => 'this month',
    };
    final viewLabel =
        _statView == _StatView.categories ? 'category' : 'transaction';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon bubble
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bar_chart_rounded, size: 32, color: cs.primary),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
              "There is no ${isIncome ? 'income' : 'expense'} data $filterLabel",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = context.watch<TransactionController>();
    final currency = context.watch<CurrencyController>();
    final isPremium =
        context.watch<UserController>().currentUser?.isPremium ?? false;

    final filtered = _filtered(controller.allTransactions);

    final totalIncome = filtered
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final totalExpense = filtered
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    final displayTotal =
        _tab == _IncomeExpenseTab.income ? totalIncome : totalExpense;

    final catMap = _categoryMap(filtered, _tab);
    final catList = catMap.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final catTotal = catList.fold(0.0, (s, c) => s + c.amount);
    final barEntries = _barEntries(filtered, _tab);

    final tabFiltered = filtered
        .where((t) =>
            t.type ==
            (_tab == _IncomeExpenseTab.income
                ? TransactionType.income
                : TransactionType.expense))
        .toList();

    // True when there is nothing to show for the current tab + view combo
    final isEmpty = _statView == _StatView.categories
        ? catList.isEmpty
        : tabFiltered.isEmpty;

    return Scaffold(
      appBar: AppAppBar.title(
        'Analytics',
        actions: [
          IconButton(
            onPressed: () => context.push(RouteName.calender),
            icon: Icon(
              Icons.calendar_month_rounded,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            const SizedBox(height: 10),

            // ── Time filters ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: FiltersChip(
                    label: 'All time',
                    isSelected: _timeFilter == _TimeFilter.all,
                    onTap: () => setState(() => _timeFilter = _TimeFilter.all),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FiltersChip(
                    label: 'This year',
                    isSelected: _timeFilter == _TimeFilter.year,
                    onTap: () => setState(() => _timeFilter = _TimeFilter.year),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FiltersChip(
                    label: 'This month',
                    isSelected: _timeFilter == _TimeFilter.month,
                    onTap: () =>
                        setState(() => _timeFilter = _TimeFilter.month),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── View dropdown ─────────────────────────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<_StatView>(
                  onSelected: (val) => setState(() => _statView = val),
                  color: theme.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(minWidth: 10),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _StatView.transactions,
                      child: Text(
                        'Transactions',
                        style: TextStyle(
                          color: _statView == _StatView.transactions
                              ? colorScheme.primary
                              : null,
                          fontWeight: _statView == _StatView.transactions
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: _StatView.categories,
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          color: _statView == _StatView.categories
                              ? colorScheme.primary
                              : null,
                          fontWeight: _statView == _StatView.categories
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _statView == _StatView.transactions
                              ? 'Transactions'
                              : 'Categories',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Amount + chart type toggle ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currency.symbol}${displayTotal.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                // Hide chart toggle when there is nothing to chart
                if (!isEmpty)
                  ChartTypeToggle(
                    selected: _chartType,
                    onChanged: (val) {
                      if (val == ChartType.bar && !isPremium) {
                        SubscriptionScreen.show(context);
                        return;
                      }
                      setState(() => _chartType = val);
                    },
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Chart OR empty state ───────────────────────────────────────
            if (isEmpty)
              _buildEmptyState(theme, colorScheme)
            else
              StatChart(
                chartType: _chartType,
                isCategory: _statView == _StatView.categories,
                isIncome: _tab == _IncomeExpenseTab.income,
                catList: catList,
                catTotal: catTotal,
                barEntries: barEntries,
                totalIncome: totalIncome,
                totalExpense: totalExpense,
              ),

            const SizedBox(height: 20),

            // ── Income / Expense toggle ───────────────────────────────────
            AppToggle<_IncomeExpenseTab>(
              selectedValue: _tab,
              onChanged: (val) => setState(() => _tab = val),
              options: const [
                ToggleOption(
                  label: 'Income',
                  value: _IncomeExpenseTab.income,
                ),
                ToggleOption(
                  label: 'Expense',
                  value: _IncomeExpenseTab.expense,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Category list (only when not empty) ───────────────────────
            if (_statView == _StatView.categories && !isEmpty) ...[
              ...catList.map((cat) {
                final pct = catTotal > 0 ? (cat.amount / catTotal * 100) : 0.0;
                return CategoryStatTile(
                  title: cat.title,
                  color: cat.color,
                  icon: cat.icon,
                  amount: cat.amount,
                  percentage: pct,
                );
              }),
            ],

            // ── Transaction list (only when not empty) ────────────────────
            if (_statView == _StatView.transactions && !isEmpty) ...[
              ...tabFiltered.map(
                (t) => TransactionTile(
                  transaction: t,
                  onPressed: () => context.push('/edit-transaction', extra: t),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
