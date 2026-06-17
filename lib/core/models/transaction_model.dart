import 'package:expense_tracker/core/utils/constant.dart';

import 'package:expense_tracker/core/models/category_model.dart';

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String note;
  final TransactionType type;
  final PayMethod payMethod;
  final DateTime dateTime;

  final CategoryModel? category; // NEW

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.note,
    required this.type,
    required this.payMethod,
    required this.dateTime,
    this.category,
  });
  TransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? note,
    TransactionType? type,
    PayMethod? payMethod,
    DateTime? dateTime,
    CategoryModel? category,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      type: type ?? this.type,
      payMethod: payMethod ?? this.payMethod,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'note': note,
      'type': type.name,
      'payMethod': payMethod.name,
      'dateTime': dateTime.toIso8601String(),
      'category': category?.toMap(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      note: json['note'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      payMethod: PayMethod.values.firstWhere(
        (e) => e.name == json['payMethod'],
        orElse: () => PayMethod.cash,
      ),
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
      category: json['category'] != null
          ? CategoryModel.fromMap(
              Map<String, dynamic>.from(json['category']),
            )
          : null,
    );
  }
}
