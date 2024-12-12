import 'package:flutter/material.dart';

// Enum to define CategoryType
enum CategoryType { income, expense }

class Category {
  final String name;
  final Color color;
  final bool isDefault;
  final CategoryType type;
  final IconData icon; // Add icon field
  late final Color backgroundColor; // Background color derived from color

  // Constructor for Category
  Category({
    required this.name,
    required this.color,
    this.isDefault = true,
    required this.type,
    required this.icon,
  }) {
    backgroundColor = color.withOpacity(0.2); // Light version of the color
  }

  // Convert a Category instance to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.value, // Convert Color to int
      'isDefault': isDefault,
      'type': type.toString().split('.').last, // Save type as a string
      'icon': icon.codePoint, // Save icon as codePoint
    };
  }

  // Create a Category instance from a Map (for JSON deserialization)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      color: Color(json['color']), // Convert int back to Color
      isDefault: json['isDefault'] ?? false, // Default to false if not present
      type: CategoryType.values.firstWhere((e) =>
          e.toString().split('.').last == json['type']), // Deserialize type
      icon: IconData(json['icon'],
          fontFamily: 'MaterialIcons'), // Deserialize icon
    );
  }
}

// Updated list of categories with icons and background colors
List<Category> categories = [
  // Expense Categories
  Category(
      name: 'Dining Out',
      color: Colors.deepOrange,
      type: CategoryType.expense,
      icon: Icons.restaurant),
  Category(
      name: 'Public Transport',
      color: Colors.blueAccent,
      type: CategoryType.expense,
      icon: Icons.train),
  Category(
      name: 'Streaming Services',
      color: Colors.purpleAccent,
      type: CategoryType.expense,
      icon: Icons.tv),
  Category(
      name: 'Wellness & Spa',
      color: Colors.lightGreen,
      type: CategoryType.expense,
      icon: Icons.spa),
  Category(
      name: 'Tech Gadgets',
      color: Colors.cyan,
      type: CategoryType.expense,
      icon: Icons.devices_other),
  Category(
      name: 'Party Expenses',
      color: Colors.pinkAccent,
      type: CategoryType.expense,
      icon: Icons.celebration),
  Category(
      name: 'Home Decor',
      color: Colors.brown,
      type: CategoryType.expense,
      icon: Icons.chair),
  Category(
      name: 'Learning Platforms',
      color: Colors.indigo,
      type: CategoryType.expense,
      icon: Icons.cast_for_education),
  Category(
      name: 'Adventure Sports',
      color: Colors.teal,
      type: CategoryType.expense,
      icon: Icons.sports),
  Category(
      name: 'Fitness Subscriptions',
      color: Colors.lime,
      type: CategoryType.expense,
      icon: Icons.fitness_center),

  // Income Categories
  Category(
      name: 'Affiliate Earnings',
      color: Colors.lightBlue,
      type: CategoryType.income,
      icon: Icons.link),
  Category(
      name: 'Content Creation',
      color: Colors.orangeAccent,
      type: CategoryType.income,
      icon: Icons.videocam),
  Category(
      name: 'Rental Properties',
      color: Colors.greenAccent,
      type: CategoryType.income,
      icon: Icons.apartment),
  Category(
      name: 'Crypto Investments',
      color: Colors.amber,
      type: CategoryType.income,
      icon: Icons.currency_bitcoin),
  Category(
      name: 'Crowdfunding',
      color: Colors.pinkAccent,
      type: CategoryType.income,
      icon: Icons.people),
  Category(
      name: 'Stock Dividends',
      color: Colors.deepPurpleAccent,
      type: CategoryType.income,
      icon: Icons.show_chart),
  Category(
      name: 'E-Commerce Sales',
      color: Colors.brown,
      type: CategoryType.income,
      icon: Icons.shopping_bag),
  Category(
      name: 'Digital Products',
      color: Colors.teal,
      type: CategoryType.income,
      icon: Icons.cloud),
  Category(
      name: 'Freelance Projects',
      color: Colors.green,
      type: CategoryType.income,
      icon: Icons.work_outline),
  Category(
      name: 'Consulting',
      color: Colors.blueGrey,
      type: CategoryType.income,
      icon: Icons.chat_bubble),
];
