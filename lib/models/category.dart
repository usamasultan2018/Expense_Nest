import 'package:expense_tracker/utils/helpers/constant.dart';

class CategoryModel {
  String name;
  String icon;
  String color; // Hex color code for category color
  CategoryType type; // Category type (expense or income)
  bool isDefault; // Whether it's a default category

  // Constructor for CategoryModel
  CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.isDefault = true, // Default value is true
  });

  // Factory method to create a CategoryModel from a map (for Firestore)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      color: map['color'] ?? '#FFFFFF', // Default to white if color is missing
      type: CategoryType.values.firstWhere(
          (e) => e.toString() == 'CategoryType.${map['type']}',
          orElse: () => CategoryType.expense),
      isDefault: map['isDefault'] ?? true, // Default is true if missing
    );
  }

  // Method to convert CategoryModel to a map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
      'type': type
          .toString()
          .split('.')
          .last, // Store only the type name (expense or income)
      'isDefault': isDefault,
    };
  }
}

// Updated list of categories with icons and background colors
final List<CategoryModel> categories = [
  CategoryModel(
      name: 'Cloths',
      icon: 'checkroom',
      color: '#FF5733',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Coffee',
      icon: 'coffee',
      color: '#6F4F28',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Debt',
      icon: 'monetization_on',
      color: '#9C27B0',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Drinks',
      icon: 'local_drink',
      color: '#4CAF50',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Education',
      icon: 'school',
      color: '#2196F3',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Electricity',
      icon: 'bolt',
      color: '#FFEB3B',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Electronic',
      icon: 'phone_android',
      color: '#607D8B',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Entertainment',
      icon: 'movie',
      color: '#FFC107',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Food',
      icon: 'fastfood',
      color: '#FF9800',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Gas Bill',
      icon: 'local_fire_department',
      color: '#FF5722',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Groceries',
      icon: 'shopping_cart',
      color: '#4CAF50',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Healthcare',
      icon: 'local_hospital',
      color: '#F44336',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Internet',
      icon: 'wifi',
      color: '#03A9F4',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Personal',
      icon: 'person',
      color: '#9E9E9E',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Phone Bill',
      icon: 'phone',
      color: '#03A9F4',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Bell',
      icon: 'notifications',
      color: '#FFC107',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Rent', icon: 'home', color: '#8BC34A', type: CategoryType.expense),
  CategoryModel(
      name: 'Restaurant',
      icon: 'restaurant',
      color: '#9C27B0',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Shopping',
      icon: 'shopping_bag',
      color: '#E91E63',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Spotify',
      icon: 'music_note',
      color: '#1DB954',
      type: CategoryType.expense),
  CategoryModel(
      name: 'TV', icon: 'tv', color: '#8E24AA', type: CategoryType.expense),
  CategoryModel(
      name: 'Transport',
      icon: 'directions_car',
      color: '#FF5722',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Travel',
      icon: 'flight',
      color: '#00BCD4',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Utilities',
      icon: 'build',
      color: '#9E9E9E',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Water',
      icon: 'water_drop',
      color: '#03A9F4',
      type: CategoryType.expense),
  CategoryModel(
      name: 'YouTube',
      icon: 'video_library',
      color: '#FF0000',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Netflix',
      icon: 'tv',
      color: '#E50914',
      type: CategoryType.expense),
  CategoryModel(
      name: 'Prime',
      icon: 'shopping_cart',
      color: '#FF9800',
      type: CategoryType.expense),
  // Income Categories
  CategoryModel(
      name: 'Borrow',
      icon: 'hand_holding_money',
      color: '#FFEB3B',
      type: CategoryType.income),
  CategoryModel(
      name: 'Dividend',
      icon: 'show_chart',
      color: '#4CAF50',
      type: CategoryType.income),
  CategoryModel(
      name: 'Freelance',
      icon: 'laptop_mac',
      color: '#2196F3',
      type: CategoryType.income),
  CategoryModel(
      name: 'Passive Income',
      icon: 'attach_money',
      color: '#9C27B0',
      type: CategoryType.income),
  CategoryModel(
      name: 'Pension',
      icon: 'piggy_bank',
      color: '#8BC34A',
      type: CategoryType.income),
  CategoryModel(
      name: 'Profit',
      icon: 'show_chart',
      color: '#00BCD4',
      type: CategoryType.income),
  CategoryModel(
      name: 'Salary',
      icon: 'money_off',
      color: '#FF9800',
      type: CategoryType.income),
  CategoryModel(
      name: 'Stock Trading',
      icon: 'insert_chart',
      color: '#673AB7',
      type: CategoryType.income),
  CategoryModel(
      name: 'Other',
      icon: 'add_circle',
      color: '#9E9E9E',
      type: CategoryType.income),
];
