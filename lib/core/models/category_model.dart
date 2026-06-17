import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String userId;

  /// Category Name
  final String title;

  /// Income | Expense
  final String type;

  final int colorValue;
  final int iconCodePoint;

  /// Built-in category or user-created category
  final bool isDefault;

  final DateTime createdAt;

  const CategoryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.colorValue,
    required this.iconCodePoint,
    required this.createdAt,
    this.isDefault = false,
  });

  // UI Helpers

  Color get color => Color(colorValue);

  IconData get icon => IconData(
        iconCodePoint,
        fontFamily: 'MaterialIcons',
      );

  bool get canDelete => !isDefault;

  bool get canEdit => !isDefault;

  // Firebase

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'type': type,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
      'isDefault': isDefault,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? 'Expense',
      colorValue: map['colorValue'] ?? Colors.blue.value,
      iconCodePoint: map['iconCodePoint'] ?? Icons.category.codePoint,
      isDefault: map['isDefault'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? 0,
      ),
    );
  }

  CategoryModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? type,
    int? colorValue,
    int? iconCodePoint,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CategoryModel('
        'id: $id, '
        'userId: $userId, '
        'title: $title, '
        'type: $type, '
        'isDefault: $isDefault'
        ')';
  }
}
