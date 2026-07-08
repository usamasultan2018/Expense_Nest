import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/budget_model.dart';
import 'package:expense_tracker/core/models/category_model.dart';
import 'package:expense_tracker/features/dashboard/view/budget/controller/budget_controller.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/constants/budget_form_constants.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/widgets/alert_threshold_card.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/widgets/category_picker_sheet.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/widgets/month_picker_sheet.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/widgets/section_label.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/widgets/select_field.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/data/default_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UpdateBudgetScreen extends StatefulWidget {
  /// The existing budget to edit.
  final BudgetModel budget;

  const UpdateBudgetScreen({super.key, required this.budget});

  @override
  State<UpdateBudgetScreen> createState() => _UpdateBudgetScreenState();
}

class _UpdateBudgetScreenState extends State<UpdateBudgetScreen> {
  late final TextEditingController _amountController;
  final List<CategoryModel> _categories = DefaultCategories.expense;

  late double _amount;
  CategoryModel? _selectedCategory;
  late String? _selectedMonth;
  bool _receiveAlert = true;
  double _alertPercent = 40;

  // ─── helpers ────────────────────────────────────────────────────────────────

  static const Map<int, String> _monthNames = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  static int _monthToNumber(String month) =>
      kMonths.indexOf(month) + 1; // kMonths is 0-indexed Jan→1

  IconData _iconFor(CategoryModel category) =>
      IconData(category.iconCodePoint, fontFamily: 'MaterialIcons');

  bool get _canSave =>
      _amount > 0 && _selectedCategory != null && _selectedMonth != null;

  // ─── lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    final b = widget.budget;
    _amount = b.amount;
    _amountController =
        TextEditingController(text: b.amount == 0 ? '' : b.amount.toString());

    // Pre-select the matching category (match by iconCodePoint & colorValue)
    try {
      _selectedCategory = _categories.firstWhere(
        (c) =>
            c.iconCodePoint == b.categoryIcon &&
            c.colorValue == b.categoryColor,
      );
    } catch (_) {
      _selectedCategory = null;
    }

    _selectedMonth = _monthNames[b.month];

    // Pre-populate alert settings from the stored budget
    _receiveAlert = b.receiveAlert;
    _alertPercent = b.alertThresholdPercent;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // ─── pickers ────────────────────────────────────────────────────────────────

  Future<void> _pickCategory() async {
    final result = await CategoryPickerSheet.show(
      context,
      categories: _categories,
      selected: _selectedCategory,
    );
    if (result != null) setState(() => _selectedCategory = result);
  }

  Future<void> _pickMonth() async {
    final result = await MonthPickerSheet.show(
      context,
      selected: _selectedMonth,
    );
    if (result != null) setState(() => _selectedMonth = result);
  }

  // ─── actions ────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    final controller = context.read<BudgetController>();

    final categoryChanged =
        _selectedCategory!.id != widget.budget.categoryId;

    // If the category changed the old spent amount belongs to the previous
    // category, so reset it to 0. The remaining is also recalculated from
    // transactions by the sync that happens inside updateBudget.
    final newSpent = categoryChanged ? 0.0 : widget.budget.spent;
    final newRemaining = (_amount - newSpent).clamp(0.0, double.infinity);

    final updated = widget.budget.copyWith(
      categoryId: _selectedCategory!.id,
      categoryTitle: _selectedCategory!.title,
      categoryColor: _selectedCategory!.colorValue,
      categoryIcon: _selectedCategory!.iconCodePoint,
      amount: _amount,
      spent: newSpent,
      remaining: newRemaining,
      month: _monthToNumber(_selectedMonth!),
      receiveAlert: _receiveAlert,
      alertThresholdPercent: _alertPercent,
      alertSent: false,
      updatedAt: Timestamp.now(),
    );

    await controller.updateBudget(updated);

    // After saving, re-sync spent from real transactions for the new category
    // so the displayed spent/remaining is immediately accurate.
    if (categoryChanged) {
      await controller.syncSpentForBudget(
        budgetId: updated.id,
        categoryId: updated.categoryId,
        month: updated.month,
        year: updated.year,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete budget?'),
        content: const Text(
          'This will permanently remove the budget. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final controller = context.read<BudgetController>();
      await controller.deleteBudget(widget.budget.id);
      if (mounted) Navigator.pop(context);
    }
  }

  // ─── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final budgetController = context.watch<BudgetController>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: false,
        title: const Text(
          'Edit Budget',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // ── Delete icon ────────────────────────────────────────────────────
          IconButton(
            tooltip: 'Delete budget',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: budgetController.isLoading ? null : _confirmDelete,
          ),
        ],
      ),
      body: Column(
        children: [
          /// Amount header (same coloured block as AddBudgetScreen)
          _AmountHeader(
            controller: _amountController,
            onChanged: (v) => setState(() => _amount = double.tryParse(v) ?? 0),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              color: colorScheme.surface,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Category ─────────────────────────────────────────────
                    const SectionLabel('Category'),
                    const SizedBox(height: 8),
                    SelectField(
                      hint: 'Select category',
                      value: _selectedCategory?.title,
                      leadingIcon: _selectedCategory != null
                          ? _iconFor(_selectedCategory!)
                          : Icons.category_outlined,
                      leadingIconColor: _selectedCategory != null
                          ? Color(_selectedCategory!.colorValue)
                          : null,
                      onTap: _pickCategory,
                    ),

                    const SizedBox(height: 20),

                    // ── Month ─────────────────────────────────────────────────
                    const SectionLabel('Month'),
                    const SizedBox(height: 8),
                    SelectField(
                      hint: 'Select month',
                      value: _selectedMonth,
                      leadingIcon: Icons.calendar_today_rounded,
                      onTap: _pickMonth,
                    ),

                    const SizedBox(height: 28),

                    // ── Alert toggle ──────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Receive alert',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Switch(
                          value: _receiveAlert,
                          onChanged: (v) => setState(() => _receiveAlert = v),
                          activeThumbColor: colorScheme.surface,
                          activeTrackColor: colorScheme.primary,
                        ),
                      ],
                    ),
                    Text(
                      'Get notified when spending reaches a set percentage of your budget.',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: _receiveAlert
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: AlertThresholdCard(
                                percent: _alertPercent,
                                onChanged: (v) =>
                                    setState(() => _alertPercent = v),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 32),

                    // ── Save button ───────────────────────────────────────────
                    _SaveBudgetButton(
                      enabled: _canSave,
                      isLoading: budgetController.isLoading,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Private sub-widgets
// ══════════════════════════════════════════════════════════════════════════════

/// Coloured header with editable amount (identical layout to AddBudgetScreen).
class _AmountHeader extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _AmountHeader({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.primaryContainer,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set limit amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          IntrinsicWidth(
            child: TextField(
              controller: controller,
              autofocus: false,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
              cursorColor: colorScheme.onPrimaryContainer,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                filled: false,
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                ),
                contentPadding: EdgeInsets.zero,
                prefixText: '${currency.symbol} ',
                prefixStyle: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill-shaped "Save changes" submit button.
class _SaveBudgetButton extends StatelessWidget {
  final bool enabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const _SaveBudgetButton({
    required this.enabled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor:
              colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.4),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        onPressed: enabled ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save changes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
