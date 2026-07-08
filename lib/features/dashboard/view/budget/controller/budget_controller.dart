import 'package:flutter/material.dart';
import 'package:expense_tracker/core/models/budget_model.dart';
import 'package:expense_tracker/core/repository/budget_repository.dart';

class BudgetController extends ChangeNotifier {
  final BudgetRepository _repository = BudgetRepository();

  bool isLoading = false;

  /// Selected month chip
  int selectedIndex = 0; // 0 = "All"

  /// Month chips
  final List<String> months = const [
    "All",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  /// All budgets from Firestore
  List<BudgetModel> allBudgets = [];

  /// Budgets shown in UI
  List<BudgetModel> budgets = [];

  Future<void> loadBudgets() async {
    isLoading = true;
    notifyListeners();

    allBudgets = await _repository.getBudgets();

    selectMonth(selectedIndex);

    isLoading = false;
    notifyListeners();
  }

  void selectMonth(int index) {
    selectedIndex = index;

    if (index == 0) {
      budgets = List.from(allBudgets);
    } else {
      budgets = allBudgets.where((e) => e.month == index).toList();
    }

    notifyListeners();
  }

  Future<void> addBudget(BudgetModel budget) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.addBudget(budget);
      await loadBudgets();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBudget(BudgetModel budget) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.updateBudget(budget);
      await loadBudgets();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteBudget(id);
      await loadBudgets();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Re-syncs spent/remaining for [budgetId] by summing real expense
  /// transactions for [categoryId] in the given [month]/[year].
  Future<void> syncSpentForBudget({
    required String budgetId,
    required String categoryId,
    required int month,
    required int year,
  }) async {
    try {
      await _repository.syncSpentFromTransactions(
        budgetId: budgetId,
        categoryId: categoryId,
        month: month,
        year: year,
      );
      await loadBudgets();
    } catch (e) {
      // Best-effort — don't block the UI
    }
  }
}
