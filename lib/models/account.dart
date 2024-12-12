import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String userId;
  final String accountName;
  final double balance;
  final double totalIncome;
  final double totalExpense;
  final Timestamp createdAt;

  // Constructor
  AccountModel({
    required this.userId,
    required this.accountName,
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
    required this.createdAt,
  });

  // Factory constructor to create an AccountModel from Firestore document
  factory AccountModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AccountModel(
      userId: data['userId'] ?? '',
      accountName: data['accountName'] ?? '',
      balance: data['balance']?.toDouble() ?? 0.0,
      totalIncome: data['totalIncome']?.toDouble() ?? 0.0,
      totalExpense: data['totalExpense']?.toDouble() ?? 0.0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }


  // Method to convert AccountModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'accountName': accountName,
      'balance': balance,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'createdAt': createdAt,
    };
  }
}
