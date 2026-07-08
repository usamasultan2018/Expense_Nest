import 'package:expense_tracker/core/models/category_model.dart';
import 'package:flutter/material.dart';

import 'sheet_handle.dart';

/// Modal bottom sheet listing categories to choose from.
///
/// Call [show] to display it; it returns the picked [CategoryModel],
/// or null if the user dismissed it without picking.
class CategoryPickerSheet extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selected;

  const CategoryPickerSheet({
    super.key,
    required this.categories,
    required this.selected,
  });

  static Future<CategoryModel?> show(
    BuildContext context, {
    required List<CategoryModel> categories,
    required CategoryModel? selected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<CategoryModel>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CategoryPickerSheet(
        categories: categories,
        selected: selected,
      ),
    );
  }

  IconData _iconFor(CategoryModel category) =>
      IconData(category.iconCodePoint, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const SheetHandle(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category.id == selected?.id;
                return ListTile(
                  leading: Icon(
                    _iconFor(category),
                    color: Color(category.colorValue),
                  ),
                  title: Text(category.title),
                  trailing: isSelected
                      ? Icon(Icons.check_circle_rounded,
                          color: colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(context, category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
