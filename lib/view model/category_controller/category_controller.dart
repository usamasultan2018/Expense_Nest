import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/repository/category_repository.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';
import 'package:flutter/material.dart';

class CategoryController extends ChangeNotifier {
  final CategoryRepository
      categoryRepository; // Dependency injection for category repository
  final TransactionRepository
      transactionRepository; // Dependency injection for transaction repository

  List<CategoryModel> _expenseCategories =
      []; // List to store expense categories
  List<CategoryModel> _incomeCategories = []; // List to store income categories
  String? _selectedCategory; // To store the selected category

  // Constructor for the CategoryController with required repositories
  CategoryController({
    required this.categoryRepository,
    required this.transactionRepository,
  }) {
    fetchExpenseCategories(); // Fetch expense categories on initialization
    fetchIncomeCategories(); // Fetch income categories on initialization
  }

  // Getters for UI access to the categories
  List<CategoryModel> get expenseCategories => _expenseCategories;
  List<CategoryModel> get incomeCategories => _incomeCategories;
  String? get selectedCategory => _selectedCategory;

  // Fetch expense categories from the repository
  Future<void> fetchExpenseCategories() async {
    try {
      _expenseCategories = await categoryRepository
          .fetchExpenseCategories(); // Fetch from category repository
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error in fetching expense categories: $e'); // Log error
      rethrow; // Rethrow error for further handling
    }
  }

  // Fetch income categories from the repository
  Future<void> fetchIncomeCategories() async {
    try {
      _incomeCategories = await categoryRepository
          .fetchIncomeCategories(); // Fetch from category repository
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error in fetching income categories: $e'); // Log error
      rethrow; // Rethrow error for further handling
    }
  }

  // Method to set the selected category and notify listeners
  void setCategory(String category) {
    _selectedCategory = category; // Update selected category
    notifyListeners(); // Notify listeners to update UI
  }
}
