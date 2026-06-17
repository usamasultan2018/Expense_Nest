import 'package:expense_tracker/core/models/category_model.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/repository/transaction_repository.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/core/utils/date.dart';
import 'package:expense_tracker/core/utils/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionController extends ChangeNotifier {
  TransactionController({required this.transactionRepository}) {
    loadTransactions();
    dateEditingController.text =
        DateTimeUtils.formatDateMonthDayYear(_selectedDate);
  }

  final TransactionRepository transactionRepository;

  // Controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateEditingController = TextEditingController();

  // Loading States
  bool isLoading = false;
  bool isLoadingTransactions = false;
  bool isDeleting = false;

  // Error State
  String? _error;
  String? get error => _error;

  // Transaction List
  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> get allTransactions => _allTransactions;

  // Computed Getters
  double get totalIncome => _allTransactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _allTransactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  // Form State
  TransactionType selectedType = TransactionType.income;
  PayMethod selectedPaymentMethod = PayMethod.cash;
  DateTime _selectedDate = DateTime.now();

  // =========================
  // Load Transactions
  // =========================
// Inside CategoryController — add these:

  CategoryModel? _selectedCategory;
  CategoryModel? get selectedCategory => _selectedCategory;

  void selectCategory(CategoryModel cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      _error = 'User not logged in';
      _allTransactions = [];
      notifyListeners();
      return;
    }

    isLoadingTransactions = true;
    _error = null;
    notifyListeners();

    try {
      _allTransactions = await transactionRepository.getTransactions(uid);
    } catch (e) {
      _error = e.toString();
      _allTransactions = [];
    } finally {
      isLoadingTransactions = false;
      notifyListeners();
    }
  }

  // =========================
  // Transaction Type
  // =========================

  void setType(TransactionType type) {
    selectedType = type;
    notifyListeners();
  }

  // =========================
  // Payment Method
  // =========================

  void updatePaymentMethod(PayMethod method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  // =========================
  // Date Picker
  // =========================

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _selectedDate = picked;
      dateEditingController.text =
          DateTimeUtils.formatDateMonthDayYear(_selectedDate);
      notifyListeners();
    }
  }

  // =========================
  // Create Transaction
  // =========================

  Future<void> createNewTransaction(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      SnackbarUtil.showErrorSnackbar(context, 'User not logged in');
      return;
    }
    if (_selectedCategory == null) {
      SnackbarUtil.showErrorSnackbar(
        context,
        'Please select a category',
      );
      return;
    }

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      SnackbarUtil.showErrorSnackbar(context, 'Please enter a valid amount');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final transaction = TransactionModel(
        id: '',
        userId: uid,
        amount: amount,
        note: noteController.text.trim(),
        type: selectedType,
        payMethod: selectedPaymentMethod,
        dateTime: _selectedDate,
        category: selectedCategory,
      );

      await transactionRepository.addTransaction(transaction);
      resetForm();
      await loadTransactions();

      if (context.mounted) {
        SnackbarUtil.showSuccessSnackbar(
          context,
          'Transaction added successfully',
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(context, e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // Update Transaction
  // =========================

  Future<void> modifyTransaction(
    BuildContext context,
    TransactionModel originalTransaction,
  ) async {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      SnackbarUtil.showErrorSnackbar(context, 'Please enter a valid amount');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final updatedTransaction = originalTransaction.copyWith(
        amount: amount,
        note: noteController.text.trim(),
        type: selectedType,
        payMethod: selectedPaymentMethod,
        dateTime: _selectedDate,
        category: _selectedCategory,
      );

      await transactionRepository.updateTransaction(updatedTransaction);
      await loadTransactions();

      if (context.mounted) {
        SnackbarUtil.showSuccessSnackbar(
          context,
          'Transaction updated successfully',
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(context, e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // Delete Transaction
  // =========================
  Future<void> deleteTransaction(
    BuildContext context,
    TransactionModel transaction,
  ) async {
    isDeleting = true;
    notifyListeners();

    try {
      await transactionRepository.deleteTransaction(
        transaction,
      );

      await loadTransactions();

      if (context.mounted) {
        SnackbarUtil.showSuccessSnackbar(
          context,
          'Transaction deleted successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          e.toString(),
        );
      }
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  // =========================
  // Prepare for Editing
  // =========================
  void prepareForEditing(TransactionModel transaction) {
    selectedType = transaction.type;
    selectedPaymentMethod = transaction.payMethod;
    amountController.text = transaction.amount.toString();
    noteController.text = transaction.note;
    _selectedDate = transaction.dateTime;

    _selectedCategory = transaction.category;

    dateEditingController.text =
        DateTimeUtils.formatDateMonthDayYear(_selectedDate);

    notifyListeners();
  }
  // =========================
  // Reset Form
  // =========================

  void resetForm() {
    amountController.clear();
    noteController.clear();

    _selectedCategory = null;

    selectedType = TransactionType.income;
    selectedPaymentMethod = PayMethod.cash;
    _selectedDate = DateTime.now();

    dateEditingController.text =
        DateTimeUtils.formatDateMonthDayYear(_selectedDate);

    notifyListeners();
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    dateEditingController.dispose();
    super.dispose();
  }
}
