import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/base/i_trasaction_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:expense_tracker/utils/helpers/constant.dart';

class TransactionRepository implements ITransactionRepository {
  final CollectionReference _transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');
  final CollectionReference _accountsCollection =
      FirebaseFirestore.instance.collection('accounts');

  @override
  Future<Map<String, int>> getTransactionCounts() async {
    try {
      final incomeCount = await _countTransactionsByType('income');
      final expenseCount = await _countTransactionsByType('expense');
      return {'income': incomeCount, 'expense': expenseCount};
    } catch (e) {
      print("Error fetching transaction counts: $e");
      rethrow;
    }
  }

  Future<int> _countTransactionsByType(String type) async {
    final snapshot =
        await _transactionsCollection.where('type', isEqualTo: type).get();
    return snapshot.docs.length;
  }

  @override
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

  @override
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

  @override
  Future<void> updateTransaction(TransactionModel newTransaction) async {
    try {
      final transactionRef = _transactionsCollection.doc(newTransaction.id);
      final oldTransactionSnapshot = await transactionRef.get();
      if (!oldTransactionSnapshot.exists) {
        throw Exception("Transaction not found");
      }

      TransactionModel oldTransaction = TransactionModel.fromJson(
          oldTransactionSnapshot.data() as Map<String, dynamic>);

      await transactionRef.update(newTransaction.toJson());
      await _adjustAccountBalanceOnUpdate(oldTransaction, newTransaction);
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  @override
  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _transactionsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> _updateAccountBalanceOnAdd(
      String userId, double amount, TransactionType type) async {
    await _updateAccountBalance(userId, amount, type, isAddition: true);
  }

  Future<void> _updateAccountBalanceOnDelete(
      String userId, double amount, TransactionType type) async {
    await _updateAccountBalance(userId, amount, type, isAddition: false);
  }

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

  @override
  Future<void> addImageToTransaction(
      String transactionId, String imageUrl) async {
    try {
      await _transactionsCollection
          .doc(transactionId)
          .update({'imageUrl': imageUrl});
    } catch (e) {
      print('Error adding image to transaction: $e');
      rethrow;
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    try {
      String fileName =
          'transactions/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageReference = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = storageReference.putFile(image);

      await uploadTask.whenComplete(() => null);

      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  @override
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

  @override
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
