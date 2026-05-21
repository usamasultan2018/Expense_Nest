import 'package:expense_tracker/core/models/transaction_model.dart';

abstract class ITransactionRepository {
  // Fetch transaction counts by type
  Future<Map<String, int>> getTransactionCounts(String userId);

  // Add a new transaction
  Future<void> addTransaction(TransactionModel transaction);

  // Delete a transaction
  Future<void> deleteTransaction(TransactionModel transaction);

  // Update an existing transaction
  Future<void> updateTransaction(TransactionModel newTransaction);

  // Fetch all transactions for a specific user
  Future<List<TransactionModel>> getTransactions(String userId);

  // Fetch income transactions for a specific user
  Future<List<TransactionModel>> getIncomeTransactions(String userId);

  // Fetch expense transactions for a specific user
  Future<List<TransactionModel>> getExpenseTransactions(String userId);

  // Add a list of images to Firebase associated with a transaction
  Future<void> addImageToTransaction(String transactionId, String imageUrl);
}
