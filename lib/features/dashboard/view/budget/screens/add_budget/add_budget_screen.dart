import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/core/models/budget_model.dart';
import 'package:expense_tracker/core/models/category_model.dart';
import 'package:expense_tracker/features/dashboard/view/budget/controller/budget_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/data/default_categories.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/alert_threshold_card.dart';
import 'widgets/category_picker_sheet.dart';
import 'widgets/month_picker_sheet.dart';
import 'widgets/section_label.dart';
import 'widgets/select_field.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<CategoryModel> _categories = DefaultCategories.expense;

  double _amount = 0;
  CategoryModel? _selectedCategory;
  String? _selectedMonth = _monthName(DateTime.now().month);
  bool _receiveAlert = true;
  double _alertPercent = 40;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _amount > 0 && _selectedCategory != null && _selectedMonth != null;

  IconData _iconFor(CategoryModel category) =>
      IconData(category.iconCodePoint, fontFamily: 'MaterialIcons');

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
          "Add Budget",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
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
                    const SectionLabel("Category"),
                    const SizedBox(height: 8),
                    SelectField(
                      hint: "Select category",
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
                    const SectionLabel("Month"),
                    const SizedBox(height: 8),
                    SelectField(
                      hint: "Select month",
                      value: _selectedMonth,
                      leadingIcon: Icons.calendar_today_rounded,
                      onTap: _pickMonth,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Receive alert",
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
                      "Get notified when spending reaches a set percentage of your budget.",
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
                    _CreateBudgetButton(
                        enabled: _canSave,
                        isLoading: budgetController.isLoading,
                        onPressed: () async {
                          // Gate behind premium
                          final userController =
                              context.read<UserController>();
                          if (userController.currentUser?.isPremium != true) {
                            context.push(RouteName.subscription);
                            return;
                          }

                          final controller = context.read<BudgetController>();

                          final now = DateTime.now();
                          final user = FirebaseAuth.instance.currentUser;

                          if (user == null) return;
                          final budget = BudgetModel(
                            id: '',
                            userId: user.uid,
                            categoryId: _selectedCategory!.id,
                            categoryTitle: _selectedCategory!.title,
                            categoryColor: _selectedCategory!.colorValue,
                            categoryIcon: _selectedCategory!.iconCodePoint,
                            amount: _amount,
                            spent: 0,
                            remaining: _amount,
                            month: _monthToNumber(_selectedMonth!),
                            year: now.year,
                            receiveAlert: _receiveAlert,
                            alertThresholdPercent: _alertPercent,
                            createdAt: Timestamp.now(),
                            updatedAt: Timestamp.now(),
                          );

                          await controller.addBudget(budget);

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _monthToNumber(String month) {
    const months = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    return months[month]!;
  }

  static String _monthName(int month) {
    const names = [
      '', // 1-indexed
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];
    return names[month];
  }
}

/// The big "Kz 0" amount input pinned in the primary-colored header.
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
            "Set limit amount",
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
                hintText: "0",
                hintStyle: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                ),
                contentPadding: EdgeInsets.zero,
                prefixText: "${currency.symbol} ",
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

/// The pill-shaped "Create a budget" submit button.
class _CreateBudgetButton extends StatelessWidget {
  final bool enabled;
  final bool isLoading;

  final VoidCallback onPressed;

  const _CreateBudgetButton(
      {required this.enabled,
      required this.onPressed,
      required this.isLoading});

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
        onPressed: (enabled && !isLoading) ? onPressed : null,
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colorScheme.onPrimary,
                ),
              )
            : const Text(
                "Create a budget",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
