import 'dart:io';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/utils/helpers/image_picker.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/utils/helpers/trasaction_filter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../category_controller/category_controller.dart';

class TransactionController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TransactionRepository transactionRepository;
  final CategoryController categoryController;

  PayMethod? selectedPaymentMethod;
  String? _selectedCategory;
  File? images;
  String imageUrlTrasaction = "";
  TransactionType _selectedType = TransactionType.income;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedTimePeriod = 'All Time';

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateEditingController = TextEditingController();

  TransactionController({
    required this.transactionRepository,
    required this.categoryController,
  }) {
    dateEditingController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  // Getters for UI
  String? get selectedCategory => _selectedCategory;
  TransactionType get selectedType => _selectedType;
  bool get isLoading => _isLoading;
  String get selectedTimePeriod => _selectedTimePeriod;
  String get searchQuery => _searchQuery;

  List<CategoryModel> get expenseCategories =>
      categoryController.expenseCategories;
  List<CategoryModel> get incomeCategories =>
      categoryController.incomeCategories;
  List<PayMethod> get payMethods => PayMethod.values;
  Stream<List<TransactionModel>> get transactionsStream =>
      transactionRepository.getTransactions(_auth.currentUser!.uid);

  // Setters with notifyListeners
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

  void updatePaymentMethod(PayMethod? method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  void setType(TransactionType type) {
    _selectedType = type;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); // Notify listeners when the search query changes
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
      notifyListeners();
    }
  }

  void pickImageGallery() async {
    File? image =
        await CustomImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      images = image;
      notifyListeners();
    }
  }

  void pickImageCamera() async {
    File? image = await CustomImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      images = image;
      notifyListeners();
    }
  }

  void removeImage() {
    images = null; // Clear the image
    imageUrlTrasaction = "";
    notifyListeners();
  }

  Future<void> createNewTransaction(BuildContext context) async {
    if (amountController.text.isEmpty ||
        _selectedCategory == null ||
        noteController.text.isEmpty ||
        selectedPaymentMethod == null) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.pleaseFillAllFields);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      String imageUrl = '';
      if (images != null) {
        imageUrl = await transactionRepository.uploadImageToFirebase(images!);
      }

      // Step 2: Create the transaction object
      final transaction = TransactionModel(
        id: "", // Will be assigned by Firestore during creation
        userId: _auth.currentUser!.uid,
        category: _selectedCategory!,
        amount: double.parse(amountController.text),
        note: noteController.text,
        type: _selectedType,
        date: DateFormat('dd-MM-yyyy').parse(dateEditingController.text),
        time: DateTime.now(),
        payMethod: selectedPaymentMethod!,
        picture: imageUrl,
      );

      // Step 3: Add the transaction to Firestore
      await transactionRepository.addTransaction(transaction);

      // Step 4: Show success message and pop the screen
      SnackbarUtil.showSuccessSnackbar(
          context, AppLocalizations.of(context)!.transactionAddedSuccessfully);
      Navigator.pop(context);
      images = null;
    } catch (e) {
      // Handle errors during transaction creation or image upload
      SnackbarUtil.showErrorSnackbar(context, e.toString());
    } finally {
      // Reset the loading state
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> modifyTransaction(
      BuildContext context, String transactionId) async {
    if (amountController.text.isEmpty ||
        _selectedCategory == null ||
        noteController.text.isEmpty ||
        selectedPaymentMethod == null) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.pleaseFillAllFields);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      String imageUrl = '';
      if (images != null) {
        imageUrl = await transactionRepository.uploadImageToFirebase(images!);
      }

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
        picture: imageUrl, // Updated images for the transaction
      );

      await transactionRepository.updateTransaction(updatedTransaction);
      SnackbarUtil.showSuccessSnackbar(context,
          AppLocalizations.of(context)!.transactionUpdatedSuccessfully);
      Navigator.pop(context);
      images = null;
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<TransactionModel> filterTransactions(
      List<TransactionModel> transactions) {
    return TransactionFiltering.filterTransactions(
      transactions,
      _selectedTimePeriod,
      _searchQuery,
    );
  }

  List<TransactionModel> filterTransactionsByType(
      List<TransactionModel> transactions, TransactionType type) {
    return TransactionFiltering.filterByType(transactions, type);
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

  void loadTransactionForEditing(TransactionModel transaction) async {
    amountController.text = transaction.amount.toString();
    noteController.text = transaction.note;
    _selectedCategory = transaction.category;
    dateEditingController.text =
        DateFormat('dd-MM-yyyy').format(transaction.date);
    _selectedType = transaction.type;
    selectedPaymentMethod = transaction.payMethod;
    if (transaction.picture!.isNotEmpty) {
      // If the picture URL is provided, assign it.
      imageUrlTrasaction = transaction.picture!;
    } else {
      imageUrlTrasaction = ''; // Reset if no image
    }

    notifyListeners();
  }
}
