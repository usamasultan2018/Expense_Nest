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
