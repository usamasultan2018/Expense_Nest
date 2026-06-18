// transaction_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/models/category_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/recurring_toggle.dart';

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String note;
  final TransactionType type;
  final PayMethod payMethod;
  final DateTime dateTime;
  final CategoryModel? category;

  // ── Recurring fields ──────────────────────────────────────────────────────
  final String recurringInterval;
  final DateTime? lastRecurredAt;
  final DateTime? nextDueDate;

  // ── Receipt ───────────────────────────────────────────────────────────────
  final String? receiptUrl;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.note,
    required this.type,
    required this.payMethod,
    required this.dateTime,
    this.category,
    this.recurringInterval = 'never',
    this.lastRecurredAt,
    this.nextDueDate,
    this.receiptUrl,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String? ?? '',
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      payMethod: _payMethodFromString(json['payMethod'] as String?),
      dateTime: _toDateTime(json['dateTime']),
      category: json['category'] != null
          ? CategoryModel.fromMap(json['category'] as Map<String, dynamic>)
          : null,
      recurringInterval: json['recurringInterval'] as String? ?? 'never',
      lastRecurredAt: json['lastRecurredAt'] != null
          ? _toDateTime(json['lastRecurredAt'])
          : null,
      nextDueDate:
          json['nextDueDate'] != null ? _toDateTime(json['nextDueDate']) : null,
      receiptUrl: json['receiptUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'note': note,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'payMethod': payMethod.name,
      'dateTime': Timestamp.fromDate(dateTime),
      'category': category?.toMap(),
      'recurringInterval': recurringInterval,
      'lastRecurredAt':
          lastRecurredAt != null ? Timestamp.fromDate(lastRecurredAt!) : null,
      'nextDueDate':
          nextDueDate != null ? Timestamp.fromDate(nextDueDate!) : null,
      'receiptUrl': receiptUrl,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? note,
    TransactionType? type,
    PayMethod? payMethod,
    DateTime? dateTime,
    CategoryModel? category,
    String? recurringInterval,
    DateTime? lastRecurredAt,
    DateTime? nextDueDate,
    String? receiptUrl,
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
      recurringInterval: recurringInterval ?? this.recurringInterval,
      lastRecurredAt: lastRecurredAt ?? this.lastRecurredAt,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }

  static DateTime? computeNextDueDate(DateTime base, String interval) {
    switch (interval) {
      case 'daily':
        return base.add(const Duration(days: 1));
      case 'weekly':
        return base.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(base.year, base.month + 1, base.day, base.hour,
            base.minute, base.second);
      case 'yearly':
        return DateTime(base.year + 1, base.month, base.day, base.hour,
            base.minute, base.second);
      default:
        return null;
    }
  }

  bool get isDueNow {
    if (recurringInterval == 'never' || nextDueDate == null) return false;
    final now = DateTime.now();
    return !nextDueDate!.isAfter(DateTime(now.year, now.month, now.day));
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  static PayMethod _payMethodFromString(String? value) {
    return PayMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PayMethod.cash,
    );
  }
}
