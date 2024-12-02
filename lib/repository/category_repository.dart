import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/repository/base/i_category_repository.dart';

class CategoryRepository implements ICategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  @override
  Future<List<CategoryModel>> fetchCategories(String type) async {
    try {
      final query = _categoriesCollection.where("type", isEqualTo: type);
      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> fetchIncomeCategories() =>
      fetchCategories("income");

  @override
  Future<List<CategoryModel>> fetchExpenseCategories() =>
      fetchCategories("expense");
}
