import 'package:expense_tracker/core/components/app_app_bar.dart';
import 'package:expense_tracker/features/dashboard/view/budget/controller/budget_controller.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/add_budget_screen.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/update_budget/update_budget_screen.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/widgets/budget_empty_card.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/widgets/budget_list_item.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/widgets/months_chips.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyController>();

    return Scaffold(
      appBar: AppAppBar.title(
        'Budget',
        actions: [
          IconButton(
            tooltip: 'Add budget',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddBudgetScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<BudgetController>(
        builder: (context, controller, _) {
          return CustomScrollView(
            slivers: [
              // ── Month chips ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 0, 16),
                  child: MonthsChips(
                    months: controller.months,
                    selectedIndex: controller.selectedIndex,
                    onSelect: controller.selectMonth,
                  ),
                ),
              ),

              // ── Loading ───────────────────────────────────────────────────
              if (controller.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )

              // ── Empty state ───────────────────────────────────────────────
              else if (controller.budgets.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: BudgetEmptyCard()),
                )

              // ── Budget list ───────────────────────────────────────────────
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList.builder(
                    itemCount: controller.budgets.length,
                    itemBuilder: (context, index) {
                      final budget = controller.budgets[index];

                      return BudgetListItem(
                        categoryTitle: budget.categoryTitle,
                        categoryColor: budget.categoryColor,
                        categoryIcon: budget.categoryIcon,
                        amount: budget.amount,
                        spent: budget.spent,
                        currencySymbol: currency.symbol,
                        receiveAlert: budget.receiveAlert,
                        alertThresholdPercent: budget.alertThresholdPercent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpdateBudgetScreen(budget: budget),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
