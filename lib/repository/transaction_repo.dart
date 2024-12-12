import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');
  final CollectionReference _accountsCollection =
      FirebaseFirestore.instance.collection('accounts');
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  // Fetch transaction counts by type
  Future<Map<String, int>> getTransactionCounts() async {
    try {
      final incomeCount = await _countTransactionsByType('income');
      final expenseCount = await _countTransactionsByType('expense');

      return {
        'income': incomeCount,
        'expense': expenseCount,
      };
    } catch (e) {
      print("Error fetching transaction counts: $e");
      return {'income': 0, 'expense': 0};
    }
  }

  Future<int> _countTransactionsByType(String type) async {
    final snapshot =
        await _transactionsCollection.where('type', isEqualTo: type).get();
    return snapshot.docs.length;
  }

  // Add a new transaction and update the related account
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      DocumentReference ref =
          await _transactionsCollection.add(transaction.toJson());

      await ref.update({"id": ref.id});
      await _updateAccountBalanceOnAdd(
          transaction.userId, transaction.amount, transaction.type);
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  // Delete a transaction and update the account accordingly
  Future<void> deleteTransaction(TransactionModel transaction) async {
    try {
      await _transactionsCollection.doc(transaction.id).delete();
      await _updateAccountBalanceOnDelete(
          transaction.userId, transaction.amount, transaction.type);
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Update an existing transaction and adjust the account balance
  Future<void> updateTransaction(TransactionModel newTransaction) async {
    try {
      final transactionRef = _transactionsCollection.doc(newTransaction.id);

      final oldTransactionSnapshot = await transactionRef.get();
      if (!oldTransactionSnapshot.exists)
        throw Exception("Transaction not found");

      TransactionModel oldTransaction = TransactionModel.fromJson(
          oldTransactionSnapshot.data() as Map<String, dynamic>);

      await transactionRef.update(newTransaction.toJson());
      await _adjustAccountBalanceOnUpdate(oldTransaction, newTransaction);
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  // Fetch all transactions for a specific user
  Stream<List<TransactionModel>> getTransactions(String userId) {
    try {
      return _transactionsCollection
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow;
    }
  }

  // Update account balance after a new transaction is added
  Future<void> _updateAccountBalanceOnAdd(
      String userId, double amount, TransactionType type) async {
    await _updateAccountBalance(userId, amount, type, isAddition: true);
  }

  // Update account balance after a transaction is deleted
  Future<void> _updateAccountBalanceOnDelete(
      String userId, double amount, TransactionType type) async {
    await _updateAccountBalance(userId, amount, type, isAddition: false);
  }

  // Adjust account balance after a transaction is updated
  Future<void> _adjustAccountBalanceOnUpdate(
      TransactionModel oldTransaction, TransactionModel newTransaction) async {
    final userId = newTransaction.userId;
    await _updateAccountBalance(
        userId, oldTransaction.amount, oldTransaction.type,
        isAddition: false);
    await _updateAccountBalance(
        userId, newTransaction.amount, newTransaction.type,
        isAddition: true);
  }

  // Helper method to update account balance based on transaction type and operation
  Future<void> _updateAccountBalance(
      String userId, double amount, TransactionType type,
      {required bool isAddition}) async {
    final accountRef = _accountsCollection.doc(userId);
    try {
      final accountSnapshot = await accountRef.get();
      if (!accountSnapshot.exists) throw Exception("Account not found");

      double currentBalance = (accountSnapshot['balance'] ?? 0).toDouble();
      double totalIncome = (accountSnapshot['totalIncome'] ?? 0).toDouble();
      double totalExpense = (accountSnapshot['totalExpense'] ?? 0).toDouble();

      if (type == TransactionType.income) {
        currentBalance += isAddition ? amount : -amount;
        totalIncome += isAddition ? amount : -amount;
      } else if (type == TransactionType.expense) {
        currentBalance += isAddition ? -amount : amount;
        totalExpense += isAddition ? amount : -amount;
      }

      await accountRef.update({
        'balance': currentBalance,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
      });
    } catch (e) {
      print('Error updating account balance: $e');
      rethrow;
    }
  }

  // Fetch categories by type (income or expense)
  Future<List<Category>> fetchCategories(String type) async {
    try {
      final query = _categoriesCollection.where("type", isEqualTo: type);
      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return Category.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  // Fetch income categories
  Future<List<Category>> fetchIncomeCategories() => fetchCategories("income");

  // Fetch expense categories
  Future<List<Category>> fetchExpenseCategories() => fetchCategories("expense");

  // Fetch income transactions from Firestore
  Stream<List<TransactionModel>> getIncomeTransactions(String userId) {
    return _transactionsCollection
        .where('type', isEqualTo: 'income') // Filter by 'income' type
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Fetch expense transactions from Firestore
  Stream<List<TransactionModel>> getExpenseTransactions(String userId) {
    return _transactionsCollection
        .where('type', isEqualTo: 'expense') // Filter by 'expense' type
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
