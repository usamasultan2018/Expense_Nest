import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final String userId;

  final String categoryId;
  final String categoryTitle;
  final int categoryColor;
  final int categoryIcon;

  final double amount;
  final double spent;
  final double remaining;

  final int month;
  final int year;

  final bool receiveAlert;
  final double alertThresholdPercent;
  final bool alertSent;

  final Timestamp createdAt;
  final Timestamp updatedAt;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryColor,
    required this.categoryIcon,
    required this.amount,
    required this.spent,
    required this.remaining,
    required this.month,
    required this.year,
    this.receiveAlert = true,
    this.alertThresholdPercent = 40,
    this.alertSent = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryTitle: json['categoryTitle'] ?? '',
      categoryColor: json['categoryColor'] ?? 0,
      categoryIcon: json['categoryIcon'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
      remaining: (json['remaining'] ?? 0).toDouble(),
      month: json['month'] ?? DateTime.now().month,
      year: json['year'] ?? DateTime.now().year,
      receiveAlert: json['receiveAlert'] ?? true,
      alertThresholdPercent: (json['alertThresholdPercent'] ?? 40).toDouble(),
      alertSent: json['alertSent'] ?? false,
      createdAt: json['createdAt'] ?? Timestamp.now(),
      updatedAt: json['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'categoryId': categoryId,
      'categoryTitle': categoryTitle,
      'categoryColor': categoryColor,
      'categoryIcon': categoryIcon,
      'amount': amount,
      'spent': spent,
      'remaining': remaining,
      'month': month,
      'year': year,
      'receiveAlert': receiveAlert,
      'alertThresholdPercent': alertThresholdPercent,
      'alertSent': alertSent,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  BudgetModel copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? categoryTitle,
    int? categoryColor,
    int? categoryIcon,
    double? amount,
    double? spent,
    double? remaining,
    int? month,
    int? year,
    bool? receiveAlert,
    double? alertThresholdPercent,
    bool? alertSent,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      categoryColor: categoryColor ?? this.categoryColor,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      remaining: remaining ?? this.remaining,
      month: month ?? this.month,
      year: year ?? this.year,
      receiveAlert: receiveAlert ?? this.receiveAlert,
      alertThresholdPercent:
          alertThresholdPercent ?? this.alertThresholdPercent,
      alertSent: alertSent ?? this.alertSent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
