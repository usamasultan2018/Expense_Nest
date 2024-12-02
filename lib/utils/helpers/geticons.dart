import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Function to get the corresponding icon for a category
IconData getIconForCategory(String categoryName) {
  switch (categoryName) {
    // Expense Categories
    case 'Dining Out':
      return Icons.restaurant;
    case 'Public Transport':
      return Icons.train;
    case 'Streaming Services':
      return Icons.tv;
    case 'Wellness & Spa':
      return Icons.spa;
    case 'Tech Gadgets':
      return Icons.devices_other;
    case 'Party Expenses':
      return Icons.celebration;
    case 'Home Decor':
      return Icons.chair;
    case 'Learning Platforms':
      return Icons.cast_for_education;
    case 'Adventure Sports':
      return Icons.sports;
    case 'Fitness Subscriptions':
      return Icons.fitness_center;

    // Income Categories
    case 'Affiliate Earnings':
      return Icons.link;
    case 'Content Creation':
      return Icons.videocam;
    case 'Rental Properties':
      return Icons.apartment;
    case 'Crypto Investments':
      return Icons.currency_bitcoin;
    case 'Crowdfunding':
      return Icons.people;
    case 'Stock Dividends':
      return Icons.show_chart;
    case 'E-Commerce Sales':
      return Icons.shopping_bag;
    case 'Digital Products':
      return Icons.cloud;
    case 'Freelance Projects':
      return Icons.work_outline;
    case 'Consulting':
      return Icons.chat_bubble;

    default:
      return Icons.category; // Fallback icon
  }
}

// Function to get the background color (light shade) for a category
// Function to get the background color (light shade) for a category
Color getCategoryLightColor(String categoryName) {
  switch (categoryName) {
    case 'Dining Out':
      return const Color(0xFFFFF3E0); // Light orange
    case 'Public Transport':
      return const Color(0xFFBBDEFB); // Light blue
    case 'Streaming Services':
      return const Color(0xFFF3E5F5); // Light purple
    case 'Wellness & Spa':
      return const Color(0xFFE8F5E9); // Light green
    case 'Tech Gadgets':
      return const Color(0xFFFFF9C4); // Light yellow
    case 'Party Expenses':
      return const Color(0xFFFFCDD2); // Light red
    case 'Home Decor':
      return const Color(0xFFB2DFDB); // Light teal
    case 'Learning Platforms':
      return const Color(0xFFE1BEE7); // Light purple
    case 'Adventure Sports':
      return const Color(0xFFB3E5FC); // Light blue accent
    case 'Fitness Subscriptions':
      return const Color(0xFFF1F8E9); // Light green accent

    // Income Categories
    case 'Affiliate Earnings':
    case 'Crowdfunding':
      return const Color(0xFFF1F8E9); // Light green accent
    case 'Content Creation':
      return const Color(0xFFBBDEFB); // Light blue accent
    case 'Rental Properties':
      return const Color(0xFFFFF3E0); // Light amber
    case 'Crypto Investments':
      return const Color(0xFFFCE4EC); // Light pink accent

    // Missing categories added
    case 'E-Commerce Sales':
      return const Color(0xFFFFF9C4); // Light yellow (similar to Tech Gadgets)
    case 'Digital Products':
      return const Color(
          0xFFE1BEE7); // Light purple (similar to Learning Platforms)
    case 'Freelance Projects':
      return const Color(
          0xFFBBDEFB); // Light blue accent (similar to Content Creation)
    case 'Consulting':
      return const Color(0xFFE8F5E9); // Light green (similar to Wellness & Spa)
    case 'Stock Dividends':
      return const Color(
          0xFFF3E5F5); // Light purple accent (similar to Streaming Services)

    default:
      return const Color(0xFFF5F5F5); // Default very light grey
  }
}

// Function to get the dark shade of a category for the icon color
// Function to get the background color (dark shade) for a category
Color getCategoryDarkColor(String categoryName) {
  switch (categoryName) {
    case 'Dining Out':
      return const Color(0xFFFFC107); // Dark orange
    case 'Public Transport':
      return const Color(0xFF1976D2); // Dark blue
    case 'Streaming Services':
      return const Color(0xFF9C27B0); // Dark purple
    case 'Wellness & Spa':
      return const Color(0xFF388E3C); // Dark green
    case 'Tech Gadgets':
      return const Color(0xFFFBC02D); // Dark yellow
    case 'Party Expenses':
      return const Color(0xFFF57C00); // Dark red
    case 'Home Decor':
      return const Color(0xFF00796B); // Dark teal
    case 'Learning Platforms':
      return const Color(0xFF795548); // Dark brown
    case 'Adventure Sports':
      return const Color(0xFF303F9F); // Dark indigo
    case 'Fitness Subscriptions':
      return const Color(0xFFF57C00); // Dark amber

    // Income Categories
    case 'Affiliate Earnings':
      return const Color(0xFF1B5E20); // Dark green accent
    case 'Content Creation':
      return const Color(0xFF1976D2); // Dark blue accent
    case 'Rental Properties':
      return const Color(0xFFFBC02D); // Dark amber
    case 'Crypto Investments':
      return const Color(0xFFEC407A); // Dark pink accent
    case 'Crowdfunding':
      return const Color(0xFF388E3C); // Dark green

    // Missing categories added
    case 'E-Commerce Sales':
      return const Color(0xFF0288D1); // Dark blue (similar to Public Transport)
    case 'Digital Products':
      return const Color(
          0xFF8E24AA); // Dark purple (similar to Streaming Services)
    case 'Freelance Projects':
      return const Color(
          0xFF1976D2); // Dark blue accent (similar to Content Creation)
    case 'Consulting':
      return const Color(0xFF388E3C); // Dark green (similar to Wellness & Spa)
    case 'Stock Dividends':
      return const Color(
          0xFF9C27B0); // Dark purple accent (similar to Streaming Services)

    default:
      return const Color(0xFFBDBDBD); // Default dark grey
  }
}

Icon getIconFromName(String iconName, String colorHex) {
  // Helper function to validate and parse hex color
  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    // Remove any leading '#' from the color string
    hexString = hexString.replaceFirst('#', '');

    // Validate if the string is a valid hex code (6 or 8 characters)
    final hexRegExp = RegExp(r'^[0-9A-Fa-f]{6}$|^[0-9A-Fa-f]{8}$');
    if (!hexRegExp.hasMatch(hexString)) {
      throw FormatException('Invalid hex color format: $hexString');
    }

    // If it's 6 characters (RGB), add 'FF' (default full opacity)
    if (hexString.length == 6) {
      hexString = 'FF' + hexString; // Add default opacity
    }

    try {
      // Convert hex string to Color object
      return Color(int.parse('0x$hexString'));
    } catch (e) {
      // Catch any parsing errors
      throw FormatException('Error parsing hex color: $hexString. Error: $e');
    }
  }

  // Parse the colorHex string
  Color color;
  try {
    color = hexToColor(colorHex);
  } catch (e) {
    // Return a default color if parsing fails
    color = Colors.grey;
    print('Error parsing hex color: $e');
  }

  // Switch case to return the appropriate icon
  switch (iconName) {
    case 'checkroom':
      return Icon(Icons.checkroom, color: color);
    case 'coffee':
      return Icon(Icons.coffee, color: color);
    case 'monetization_on':
      return Icon(Icons.monetization_on, color: color);
    case 'local_drink':
      return Icon(Icons.local_drink, color: color);
    case 'school':
      return Icon(Icons.school, color: color);
    case 'bolt':
      return Icon(Icons.bolt, color: color);
    case 'phone_android':
      return Icon(Icons.phone_android, color: color);
    case 'movie':
      return Icon(Icons.movie, color: color);
    case 'fastfood':
      return Icon(Icons.fastfood, color: color);
    case 'local_fire_department':
      return Icon(Icons.local_fire_department, color: color);
    case 'shopping_cart':
      return Icon(Icons.shopping_cart, color: color);
    case 'local_hospital':
      return Icon(Icons.local_hospital, color: color);
    case 'wifi':
      return Icon(Icons.wifi, color: color);
    case 'person':
      return Icon(Icons.person, color: color);
    case 'phone':
      return Icon(Icons.phone, color: color);
    case 'notifications':
      return Icon(Icons.notifications, color: color);
    case 'home':
      return Icon(Icons.home, color: color);
    case 'restaurant':
      return Icon(Icons.restaurant, color: color);
    case 'shopping_bag':
      return Icon(Icons.shopping_bag, color: color);
    case 'music_note':
      return Icon(Icons.music_note, color: color);
    case 'tv':
      return Icon(Icons.tv, color: color);
    case 'directions_car':
      return Icon(Icons.directions_car, color: color);
    case 'flight':
      return Icon(Icons.flight, color: color);
    case 'build':
      return Icon(Icons.build, color: color);
    case 'water_drop':
      return Icon(Icons.water_drop, color: color);
    case 'video_library':
      return Icon(Icons.video_library, color: color);
    case 'hand_holding_money':
      return Icon(Icons.money, color: color);
    case 'show_chart':
      return Icon(Icons.show_chart, color: color);
    case 'laptop_mac':
      return Icon(Icons.laptop_mac, color: color);
    case 'attach_money':
      return Icon(Icons.attach_money, color: color);
    case 'piggy_bank':
      return Icon(Icons.food_bank, color: color);
    case 'money_off':
      return Icon(Icons.money_off, color: color);
    case 'insert_chart':
      return Icon(Icons.insert_chart, color: color);
    case 'add_circle':
      return Icon(Icons.add_circle, color: color);
    default:
      return Icon(Icons.help, color: color); // Default icon if no match found
  }
}

Color getColorFromHex(String hexString) {
  // Remove any leading '#' from the color string
  hexString = hexString.replaceFirst('#', '');

  // Validate if the string is a valid hex code (6 or 8 characters)
  final hexRegExp = RegExp(r'^[0-9A-Fa-f]{6}$|^[0-9A-Fa-f]{8}$');
  if (!hexRegExp.hasMatch(hexString)) {
    throw FormatException('Invalid hex color format: $hexString');
  }

  // If it's 6 characters (RGB), add 'FF' (default full opacity)
  if (hexString.length == 6) {
    hexString = 'FF' + hexString; // Add default opacity
  }

  try {
    // Convert hex string to Color object
    return Color(int.parse('0x$hexString'));
  } catch (e) {
    // Catch any parsing errors
    throw FormatException('Error parsing hex color: $hexString. Error: $e');
  }
}

Icon getIconsForTile(String categoryName) {
  switch (categoryName) {
    case 'Cloths':
      return Icon(Icons.checkroom, color: Color(0xFFFF5733));
    case 'Coffee':
      return Icon(Icons.coffee, color: Color(0xFF6F4F28));
    case 'Debt':
      return Icon(Icons.monetization_on, color: Color(0xFF9C27B0));
    case 'Drinks':
      return Icon(Icons.local_drink, color: Color(0xFF4CAF50));
    case 'Education':
      return Icon(Icons.school, color: Color(0xFF2196F3));
    case 'Electricity':
      return Icon(Icons.bolt, color: Color(0xFFFFEB3B));
    case 'Electronic':
      return Icon(Icons.phone_android, color: Color(0xFF607D8B));
    case 'Entertainment':
      return Icon(Icons.movie, color: Color(0xFFFFC107));
    case 'Food':
      return Icon(Icons.fastfood, color: Color(0xFFFF9800));
    case 'Gas Bill':
      return Icon(Icons.local_fire_department, color: Color(0xFFFF5722));
    case 'Groceries':
      return Icon(Icons.shopping_cart, color: Color(0xFF4CAF50));
    case 'Healthcare':
      return Icon(Icons.local_hospital, color: Color(0xFFF44336));
    case 'Internet':
      return Icon(Icons.wifi, color: Color(0xFF03A9F4));
    case 'Personal':
      return Icon(Icons.person, color: Color(0xFF9E9E9E));
    case 'Phone Bill':
      return Icon(Icons.phone, color: Color(0xFF03A9F4));
    case 'Bell':
      return Icon(Icons.notifications, color: Color(0xFFFFC107));
    case 'Rent':
      return Icon(Icons.home, color: Color(0xFF8BC34A));
    case 'Restaurant':
      return Icon(Icons.restaurant, color: Color(0xFF9C27B0));
    case 'Shopping':
      return Icon(Icons.shopping_bag, color: Color(0xFFE91E63));
    case 'Spotify':
      return Icon(Icons.music_note, color: Color(0xFF1DB954));
    case 'TV':
      return Icon(Icons.tv, color: Color(0xFF8E24AA));
    case 'Transport':
      return Icon(Icons.directions_car, color: Color(0xFFFF5722));
    case 'Travel':
      return Icon(Icons.flight, color: Color(0xFF00BCD4));
    case 'Utilities':
      return Icon(Icons.build, color: Color(0xFF9E9E9E));
    case 'Water':
      return Icon(Icons.water_drop, color: Color(0xFF03A9F4));
    case 'YouTube':
      return Icon(Icons.video_library, color: Color(0xFFFF0000));
    case 'Netflix':
      return Icon(Icons.tv, color: Color(0xFFE50914));
    case 'Prime':
      return Icon(Icons.shopping_cart, color: Color(0xFFFF9800));
    case 'Borrow':
      return Icon(Icons.attach_money, color: Color(0xFFFFEB3B));
    case 'Dividend':
      return Icon(Icons.show_chart, color: Color(0xFF4CAF50));
    case 'Freelance':
      return Icon(Icons.laptop_mac, color: Color(0xFF2196F3));
    case 'Passive Income':
      return Icon(Icons.attach_money, color: Color(0xFF9C27B0));
    case 'Pension':
      return Icon(Icons.savings, color: Color(0xFF8BC34A));
    case 'Profit':
      return Icon(Icons.show_chart, color: Color(0xFF00BCD4));
    case 'Salary':
      return Icon(Icons.money_off, color: Color(0xFFFF9800));
    case 'Stock Trading':
      return Icon(Icons.insert_chart, color: Color(0xFF673AB7));
    case 'Other':
      return Icon(Icons.add_circle, color: Color(0xFF9E9E9E));
    default:
      return Icon(Icons.help_outline, color: Colors.grey);
  }
}

Color getColorsForTile(String categoryName) {
  switch (categoryName) {
    case 'Cloths':
      return Color(0xFFFF5733);
    case 'Coffee':
      return Color(0xFF6F4F28);
    case 'Debt':
      return Color(0xFF9C27B0);
    case 'Drinks':
      return Color(0xFF4CAF50);
    case 'Education':
      return Color(0xFF2196F3);
    case 'Electricity':
      return Color(0xFFFFEB3B);
    case 'Electronic':
      return Color(0xFF607D8B);
    case 'Entertainment':
      return Color(0xFFFFC107);
    case 'Food':
      return Color(0xFFFF9800);
    case 'Gas Bill':
      return Color(0xFFFF5722);
    case 'Groceries':
      return Color(0xFF4CAF50);
    case 'Healthcare':
      return Color(0xFFF44336);
    case 'Internet':
      return Color(0xFF03A9F4);
    case 'Personal':
      return Color(0xFF9E9E9E);
    case 'Phone Bill':
      return Color(0xFF03A9F4);
    case 'Bell':
      return Color(0xFFFFC107);
    case 'Rent':
      return Color(0xFF8BC34A);
    case 'Restaurant':
      return Color(0xFF9C27B0);
    case 'Shopping':
      return Color(0xFFE91E63);
    case 'Spotify':
      return Color(0xFF1DB954);
    case 'TV':
      return Color(0xFF8E24AA);
    case 'Transport':
      return Color(0xFFFF5722);
    case 'Travel':
      return Color(0xFF00BCD4);
    case 'Utilities':
      return Color(0xFF9E9E9E);
    case 'Water':
      return Color(0xFF03A9F4);
    case 'YouTube':
      return Color(0xFFFF0000);
    case 'Netflix':
      return Color(0xFFE50914);
    case 'Prime':
      return Color(0xFFFF9800);
    case 'Borrow':
      return Color(0xFFFFEB3B);
    case 'Dividend':
      return Color(0xFF4CAF50);
    case 'Freelance':
      return Color(0xFF2196F3);
    case 'Passive Income':
      return Color(0xFF9C27B0);
    case 'Pension':
      return Color(0xFF8BC34A);
    case 'Profit':
      return Color(0xFF00BCD4);
    case 'Salary':
      return Color(0xFFFF9800);
    case 'Stock Trading':
      return Color(0xFF673AB7);
    case 'Other':
      return Color(0xFF9E9E9E);
    default:
      return Colors.grey;
  }
}
