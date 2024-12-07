import 'package:expense_tracker/utils/helpers/constant.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final String note;
  final TransactionType type; // Enum for transaction type
  final PayMethod payMethod; // Enum for payment method
  final String? picture; // Optional image URL
  final DateTime date; // Date of the transaction
  final DateTime time; // Time of the transaction

  TransactionModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.note,
    required this.type,
    required this.payMethod,
    this.picture, // Optional field
    required this.date,
    required this.time,
  });

  // Convert TransactionModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'amount': amount,
      'note': note,
      'type': type.toString().split('.').last,
      'payMethod': payMethod.toString().split('.').last,
      'picture': picture ?? '', // Store an empty string if picture is null
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
    };
  }

  // Create TransactionModel from Firestore data
  static TransactionModel fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      category: json['category'],
      amount: json['amount'],
      note: json['note'],
      type: TransactionType.values
          .firstWhere((e) => e.toString() == 'TransactionType.${json['type']}'),
      payMethod: PayMethod.values
          .firstWhere((e) => e.toString() == 'PayMethod.${json['payMethod']}'),
      picture: json['picture'], // Single image URL
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
    );
  }
}
