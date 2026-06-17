import 'package:expense_tracker/core/utils/constant.dart';
import 'package:flutter/material.dart';

class CategoryController extends ChangeNotifier {
 TransactionType _selectedType = TransactionType.income;
  TransactionType get selectedType => _selectedType;

  void changeType(TransactionType type) {
    if (_selectedType == type) return;
    _selectedType = type;
    notifyListeners();
  }
}
