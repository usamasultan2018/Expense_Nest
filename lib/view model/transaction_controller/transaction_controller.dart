import 'dart:io';

import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/helpers/image_picker.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/transaction_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TransactionRepository transactionRepository;
  List<Category> _expenseCategories = [];
  List<Category> _incomeCategories = [];

  PayMethod? selectedPaymentMethod;

  // Get all job roles for UI (Dropdown, etc.)

  void updatePaymentMethod(PayMethod? method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  String? _selectedCategory;
  List<File> images = []; // List to store picked images

  TransactionType _selectedType =
      TransactionType.income; // Define transaction type here
  TransactionType _selectedTransactionType =
      TransactionType.income; // Ensure this is defined

  bool _isLoading = false;

  String _searchQuery = '';
  String _selectedTimePeriod = 'All Time';

  List<PayMethod> get payMethods => PayMethod.values;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateEditingController = TextEditingController();

  TransactionController({required this.transactionRepository}) {
    dateEditingController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    fetchExpenseCategories();
    fetchIncomeCategories();
  }

  // Getters for UI access
  String? get selectedCategory => _selectedCategory;
  List<Category> get expenseCategories => _expenseCategories;
  List<Category> get incomeCategories => _incomeCategories;
  TransactionType get selectedType => _selectedType;
  bool get isLoading => _isLoading;
  String get selectedTimePeriod => _selectedTimePeriod;
  String get searchQuery => _searchQuery;
  TransactionType get selectedTransactionType => _selectedTransactionType;

  // Setters to update state and notify listeners
  set selectedTimePeriod(String value) {
    _selectedTimePeriod = value;
    notifyListeners();
  }

  set searchQuery(String value) {
    _searchQuery = value.toLowerCase();
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      dateEditingController.text =
          DateFormat('dd-MM-yyyy').format(selectedDate);
      notifyListeners(); // Notify listeners about the change
    }
  }

  void setType(TransactionType type) {
    _selectedType = type;
    notifyListeners();
  }

  void setTransactionType(TransactionType type) {
    _selectedTransactionType = type;
    notifyListeners(); // Notify listeners so that UI can reflect the change
  }

  Stream<List<TransactionModel>> get transactionsStream =>
      transactionRepository.getTransactions(_auth.currentUser!.uid);

  void pickSingleImage() async {
    File? image =
        await CustomImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      images.add(image);
      notifyListeners();
    }
  }

  Future<void> createNewTransaction(BuildContext context) async {
    if (amountController.text.isEmpty ||
        _selectedCategory == null ||
        noteController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.pleaseFillAllFields);
      throw Exception(AppLocalizations.of(context)!.invalidInputData);
    }

    _isLoading = true;
    notifyListeners();

    try {
      final transaction = TransactionModel(
        id: "",
        userId: _auth.currentUser!.uid,
        category: _selectedCategory!,
        amount: double.parse(amountController.text),
        note: noteController.text,
        type: _selectedType,
        date: DateFormat('dd-MM-yyyy').parse(dateEditingController.text),
        time: DateTime.now(),
        payMethod: selectedPaymentMethod!,
      );

      await transactionRepository.addTransaction(transaction);
      SnackbarUtil.showSuccessSnackbar(
          context, AppLocalizations.of(context)!.transactionAddedSuccessfully);
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> modifyTransaction(
      BuildContext context, String transactionId) async {
    if (amountController.text.isEmpty ||
        _selectedCategory == null ||
        noteController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.pleaseFillAllFields);
      throw Exception(AppLocalizations.of(context)!.invalidInputData);
    }

    _isLoading = true;
    notifyListeners();

    try {
      final updatedTransaction = TransactionModel(
        id: transactionId,
        userId: _auth.currentUser!.uid,
        category: _selectedCategory!,
        amount: double.parse(amountController.text),
        note: noteController.text,
        type: _selectedType,
        date: DateFormat('dd-MM-yyyy').parse(dateEditingController.text),
        time: DateTime.now(),
        payMethod: selectedPaymentMethod!,
      );

      await transactionRepository.updateTransaction(updatedTransaction);
      SnackbarUtil.showSuccessSnackbar(context,
          AppLocalizations.of(context)!.transactionUpdatedSuccessfully);
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(
          context,
          AppLocalizations.of(context)!.errorMessage(
            "{error}",
          ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<TransactionModel> filterTransactions(
      List<TransactionModel> transactions) {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (_selectedTimePeriod) {
      case "This Year":
        startDate = DateTime(now.year);
        endDate = DateTime(now.year + 1);
        break;
      case "This Month":
        startDate = DateTime(now.year, now.month);
        endDate = DateTime(now.year, now.month + 1);
        break;
      case "This Week":
        startDate = now.subtract(Duration(days: now.weekday));
        endDate = startDate.add(Duration(days: 7));
        break;
      case "Yesterday":
        startDate = DateTime(now.year, now.month, now.day - 1);
        endDate = DateTime(now.year, now.month, now.day)
            .subtract(Duration(seconds: 1));
        break;
      case "Today":
        startDate = now.subtract(Duration(
            hours: now.hour, minutes: now.minute, seconds: now.second));
        endDate = DateTime(now.year, now.month, now.day + 1);
        break;
      case "All Time":
      default:
        return transactions
            .where((transaction) =>
                transaction.note.toLowerCase().contains(_searchQuery))
            .toList();
    }

    return transactions
        .where((transaction) {
          DateTime transactionDate = transaction.date;
          return transactionDate.isAfter(startDate) &&
              transactionDate.isBefore(endDate);
        })
        .where((transaction) =>
            transaction.note.toLowerCase().contains(_searchQuery))
        .toList();
  }

  Future<void> fetchExpenseCategories() async {
    try {
      _expenseCategories = await transactionRepository.fetchExpenseCategories();
      notifyListeners(); // Notify listeners after fetching data
    } catch (e) {
      print('Error in fetching expense categories: $e');
      rethrow;
    }
  }

  Future<void> fetchIncomeCategories() async {
    try {
      _incomeCategories = await transactionRepository.fetchIncomeCategories();
      notifyListeners(); // Notify listeners after fetching data
    } catch (e) {
      print('Error in fetching income categories: $e');
      rethrow;
    }
  }

  List<TransactionModel> filterTransactionsByType(
      List<TransactionModel> transactions, TransactionType type) {
    return transactions
        .where((transaction) => transaction.type == type)
        .toList();
  }

  Stream<List<TransactionModel>> getTransactionsByType(TransactionType type) {
    if (type == TransactionType.income) {
      return transactionRepository
          .getIncomeTransactions(_auth.currentUser!.uid);
    } else {
      return transactionRepository
          .getExpenseTransactions(_auth.currentUser!.uid);
    }
  }

  void loadTransactionForEditing(TransactionModel transaction) {
    // Ensure controllers are properly updated with the transaction data
    amountController.text = transaction.amount.toString();
    noteController.text = transaction.note; // Handle null note gracefully
    _selectedCategory = transaction.category; // Handle null category gracefully
    dateEditingController.text = DateFormat('dd-MM-yyyy')
        .format(transaction.date); // Format and load the date
    _selectedType = transaction.type; // Ensure type is not null
    selectedPaymentMethod =
        transaction.payMethod; // Set payment method from transaction
    notifyListeners(); // Notify listeners after updating fields
  }
}
