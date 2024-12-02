import 'package:expense_tracker/models/category.dart';

abstract class ICategoryRepository {
  // Fetch all categories of a specific type (income or expense)
  Future<List<CategoryModel>> fetchCategories(String type);

  // Fetch income categories
  Future<List<CategoryModel>> fetchIncomeCategories();

  // Fetch expense categories
  Future<List<CategoryModel>> fetchExpenseCategories();
}
