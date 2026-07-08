import 'package:expense_tracker/core/models/budget_model.dart';

abstract class IBudgetRepository {
  /// Add a new budget
  Future<void> addBudget(BudgetModel budget);

  /// Update an existing budget
  Future<void> updateBudget(BudgetModel budget);

  /// Delete a budget
  Future<void> deleteBudget(String id);

  /// Fetch all budgets for the user
  Future<List<BudgetModel>> getBudgets();

  /// Get a budget for a specific category/month/year
  Future<BudgetModel?> getBudgetByCategory(
    String categoryId,
    int month,
    int year,
  );

  /// Update spent amount
  /// Update spent amount and return true if a new alert was triggered
  Future<bool> updateSpentAmount(
    String budgetId,
    double spent,
  );
}
