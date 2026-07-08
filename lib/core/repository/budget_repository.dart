import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/budget_model.dart';
import 'package:expense_tracker/core/repository/base/i_budget_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetRepository implements IBudgetRepository {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _budgetCollection =
      FirebaseFirestore.instance.collection("budgets");

  @override
  Future<void> addBudget(BudgetModel budget) async {
    final doc = await _budgetCollection.add(budget.toJson());

    await doc.update({
      "id": doc.id,
    });
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _budgetCollection.doc(budget.id).update(budget.toJson());
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _budgetCollection.doc(id).delete();
  }

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final userId = _auth.currentUser!.uid;

    final snapshot =
        await _budgetCollection.where("userId", isEqualTo: userId).get();

    return snapshot.docs
        .map((e) => BudgetModel.fromJson(
              e.data() as Map<String, dynamic>,
            ))
        .toList();
  }

  @override
  Future<BudgetModel?> getBudgetByCategory(
    String categoryId,
    int month,
    int year,
  ) async {
    final userId = _auth.currentUser!.uid;

    final snapshot = await _budgetCollection
        .where("userId", isEqualTo: userId)
        .where("categoryId", isEqualTo: categoryId)
        .where("month", isEqualTo: month)
        .where("year", isEqualTo: year)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return BudgetModel.fromJson(
      snapshot.docs.first.data() as Map<String, dynamic>,
    );
  }

  @override
  Future<bool> updateSpentAmount(
    String budgetId,
    double spent,
  ) async {
    final ref = _budgetCollection.doc(budgetId);

    final doc = await ref.get();

    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;

    final amount = (data["amount"] ?? 0).toDouble();
    final receiveAlert = data["receiveAlert"] ?? true;
    final alertThresholdPercent =
        (data["alertThresholdPercent"] ?? 40).toDouble();
    final currentAlertSent = data["alertSent"] ?? false;

    bool newAlertSent = currentAlertSent;
    bool triggeredNow = false;

    if (receiveAlert) {
      final thresholdAmount = amount * (alertThresholdPercent / 100);
      if (spent >= thresholdAmount) {
        newAlertSent = true;
        // If it wasn't already sent, we are triggering it RIGHT NOW
        if (!currentAlertSent) {
          triggeredNow = true;
        }
      } else {
        newAlertSent = false;
      }
    }

    await ref.update({
      "spent": spent,
      "remaining": amount - spent,
      "alertSent": newAlertSent,
      "updatedAt": Timestamp.now(),
    });

    return triggeredNow;
  }

  /// Queries real expense transactions for [categoryId] in [month]/[year]
  /// and updates the budget's spent/remaining accordingly.
  Future<void> syncSpentFromTransactions({
    required String budgetId,
    required String categoryId,
    required int month,
    required int year,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final transactionsCollection =
        FirebaseFirestore.instance.collection('transactions');

    final snapshot = await transactionsCollection
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'expense')
        .where('category.id', isEqualTo: categoryId)
        .get();

    // Filter by month/year in-memory (Firestore doesn't support DateTime queries
    // on nested timestamps without composite indexes).
    double totalSpent = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['dateTime'];
      if (ts == null) continue;
      final dt = (ts as Timestamp).toDate();
      if (dt.month == month && dt.year == year) {
        totalSpent += (data['amount'] ?? 0).toDouble();
      }
    }

    await updateSpentAmount(budgetId, totalSpent);
  }
}
