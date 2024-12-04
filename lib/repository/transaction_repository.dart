import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/base/i_trasaction_repository.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TransactionRepository implements ITransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  @override
  Future<void> addImagesToTransaction(
      String transactionId, List<String> imageUrls) async {
    try {
      // Get a reference to the transaction document
      DocumentReference transactionRef =
          _transactionsCollection.doc(transactionId);

      // Update the transaction with the list of image URLs
      await transactionRef.update({
        'imageUrls': FieldValue.arrayUnion(
            imageUrls), // Adds the image URLs to the 'imageUrls' field
      });
    } catch (e) {
      print('Error adding images to transaction: $e');
      rethrow;
    }
  }

  // Uploads images to Firebase Storage and returns a list of download URLs
  Future<String> uploadImagesToFirebase(File image) async {
    try {
      // Generate a unique file name for each image
      String fileName =
          'transactions/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image to Firebase Storage
      final storageReference = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = storageReference.putFile(image);

      // Wait for the upload to complete
      await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded image
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl; // Return the download URL
    } catch (e) {
      throw Exception('Image upload faild: $e');
    }
  }
}
