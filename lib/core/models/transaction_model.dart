import 'package:expense_tracker/core/utils/constant.dart';

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String note;
  final TransactionType type;
  final PayMethod payMethod;
  final DateTime dateTime;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.note,
    required this.type,
    required this.payMethod,
    required this.dateTime,
  });

  TransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? note,
    TransactionType? type,
    PayMethod? payMethod,
    DateTime? dateTime,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      type: type ?? this.type,
      payMethod: payMethod ?? this.payMethod,
      dateTime: dateTime ?? this.dateTime,
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
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
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
    );
  }
}
