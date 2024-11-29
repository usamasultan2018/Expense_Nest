import 'package:flutter/material.dart';

// Enum to define CategoryType
enum CategoryType { income, expense }

class Category {
  final String name;
  final Color color;
  final bool isDefault;
  final CategoryType type;
  final IconData icon;

  Category({
    required this.name,
    required this.color,
    this.isDefault = true,
    required this.type,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.value,
      'isDefault': isDefault,
      'type': type.toString().split('.').last,
      'icon': _iconToString(icon),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      color: Color(json['color']),
      isDefault: json['isDefault'] ?? false,
      type: CategoryType.values.firstWhere((e) =>
          e.toString().split('.').last == json['type']),
      icon: _stringToIcon(json['icon']),
    );
  }

  static const Map<String, IconData> _iconMap = {
    'restaurant': Icons.restaurant,
    'train': Icons.train,
    'tv': Icons.tv,
    'spa': Icons.spa,
    'devices_other': Icons.devices_other,
    'celebration': Icons.celebration,
    'chair': Icons.chair,
    'cast_for_education': Icons.cast_for_education,
    'sports': Icons.sports,
    'fitness_center': Icons.fitness_center,
    'link': Icons.link,
    'videocam': Icons.videocam,
    'apartment': Icons.apartment,
    'currency_bitcoin': Icons.currency_bitcoin,
    'people': Icons.people,
    'show_chart': Icons.show_chart,
    'shopping_bag': Icons.shopping_bag,
    'cloud': Icons.cloud,
    'work_outline': Icons.work_outline,
    'chat_bubble': Icons.chat_bubble,
  };

  static IconData _stringToIcon(String? key) {
    return _iconMap[key] ?? Icons.help; // Default to a fallback icon
  }

  static String _iconToString(IconData icon) {
    return _iconMap.entries
        .firstWhere((entry) => entry.value == icon, orElse: () => MapEntry('help', Icons.help))
        .key;
  }
}
