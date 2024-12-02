import 'dart:io';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/utils/helpers/image_picker.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/utils/helpers/trasaction_filter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  List<File> images = [];
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

  void pickSingleImage() async {
    File? image =
        await CustomImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      images.add(image);
      notifyListeners();
    }
  }

  void removeImageAtIndex(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index); // Removes the image at the specified index
      notifyListeners(); // Notify listeners to update the UI
    }
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
      // Step 1: Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (var image in images) {
        final imageUrl =
            await transactionRepository.uploadImagesToFirebase(image);
        imageUrls.add(imageUrl);
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
        pictures: imageUrls, // Include uploaded image URLs
      );

      // Step 3: Add the transaction to Firestore
      await transactionRepository.addTransaction(transaction);

      // Step 4: Show success message and pop the screen
      SnackbarUtil.showSuccessSnackbar(
          context, AppLocalizations.of(context)!.transactionAddedSuccessfully);
      Navigator.pop(context);
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
      List<String> imageUrls = [];
      for (var image in images) {
        final imageUrl =
            await transactionRepository.uploadImagesToFirebase(image);
        imageUrls.add(imageUrl);
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
        pictures: imageUrls, // Updated images for the transaction
      );

      await transactionRepository.updateTransaction(updatedTransaction);
      SnackbarUtil.showSuccessSnackbar(context,
          AppLocalizations.of(context)!.transactionUpdatedSuccessfully);
      Navigator.pop(context);
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

    // Clear the current images before adding new ones
    images.clear();

    // Check if pictures is not null or empty before iterating
    if (transaction.pictures != null && transaction.pictures!.isNotEmpty) {
      // Load the first image from the list of URLs stored in the transaction's pictures field
      String imageUrl = transaction.pictures!.first;

      // Convert image URL to a File (this can be done via downloading or using a file path)
      File image = await downloadImage(imageUrl);
      images.add(image);
    }

    notifyListeners();
  }

// Helper function to download an image from Firebase Storage
  Future<File> downloadImage(String imageUrl) async {
    try {
      final imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      final tempFile = File(
          '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.writeToFile(tempFile);
      return tempFile;
    } catch (e) {
      throw Exception("Failed to download image: $e");
    }
  }
}
