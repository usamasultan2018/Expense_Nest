import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _categoryRef =>
      _firestore.collection('categories');

  Future<void> createCategory(
    CategoryModel category,
  ) async {
    await _categoryRef.doc(category.id).set(
          category.toMap(),
        );
  }

  Future<List<CategoryModel>> getUserCategories(
    String userId,
  ) async {
    final snapshot = await _categoryRef
        .where('userId', isEqualTo: userId)
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => CategoryModel.fromMap(
            doc.data(),
          ),
        )
        .toList();
  }

  Future<List<CategoryModel>> getCategoriesByType({
    required String userId,
    required String type,
  }) async {
    final snapshot = await _categoryRef
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => CategoryModel.fromMap(
            doc.data(),
          ),
        )
        .toList();
  }

  Future<CategoryModel?> getCategory(
    String categoryId,
  ) async {
    final doc = await _categoryRef.doc(categoryId).get();

    if (!doc.exists) {
      return null;
    }

    return CategoryModel.fromMap(doc.data()!);
  }

  Future<void> updateCategory(
    CategoryModel category,
  ) async {
    await _categoryRef.doc(category.id).update(
          category.toMap(),
        );
  }

  Future<void> deleteCategory(
    String categoryId,
  ) async {
    await _categoryRef.doc(categoryId).delete();
  }
}
