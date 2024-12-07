import 'package:expense_tracker/models/transaction.dart';

abstract class ITransactionRepository {
  // Fetch transaction counts by type
  Future<Map<String, int>> getTransactionCounts();

  // Add a new transaction
  Future<void> addTransaction(TransactionModel transaction);

  // Delete a transaction
  Future<void> deleteTransaction(TransactionModel transaction);

  // Update an existing transaction
  Future<void> updateTransaction(TransactionModel newTransaction);

  // Fetch all transactions for a specific user
  Stream<List<TransactionModel>> getTransactions(String userId);

  // Fetch income transactions for a specific user
  Stream<List<TransactionModel>> getIncomeTransactions(String userId);

  // Fetch expense transactions for a specific user
  Stream<List<TransactionModel>> getExpenseTransactions(String userId);

  // Add a list of images to Firebase associated with a transaction
  Future<void> addImageToTransaction(String transactionId, String imageUrl);
}
