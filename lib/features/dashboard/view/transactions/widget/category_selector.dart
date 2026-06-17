// category_selector.dart

import 'package:expense_tracker/core/models/category_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/data/default_categories.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel>? onCategorySelected;
  final TransactionType selectedType;

  const CategorySelector({
    super.key,
    required this.selectedType,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  bool _isExpanded = false;
  CategoryModel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedCategory;
  }

  @override
  void didUpdateWidget(CategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedType != widget.selectedType) {
      _selected = null;
    }
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _selected = widget.selectedCategory;
    }
  }

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  void _onTap(CategoryModel cat) {
    setState(() {
      _selected = cat;
      _isExpanded = false;
    });
    widget.onCategorySelected?.call(cat);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categories = widget.selectedType == TransactionType.expense 
        ? DefaultCategories.expense
        : DefaultCategories.income;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────────
        GestureDetector(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _selected == null
                    ? Text(
                        'Select Category',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CategoryCircle(category: _selected!, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            _selected!.title,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                AnimatedRotation(
                  turns: _isExpanded ? 0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Grid ──────────────────────────────────────────────────────────
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 4,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selected?.title == cat.title;

                return GestureDetector(
                  onTap: () => _onTap(cat),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: isSelected
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: cat.color.withOpacity(0.45),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              )
                            : null,
                        child: _CategoryCircle(
                          category: cat,
                          size: 48,
                          selected: isSelected,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cat.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCircle extends StatelessWidget {
  final CategoryModel category;
  final double size;
  final bool selected;

  const _CategoryCircle({
    required this.category,
    required this.size,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: category.color.withOpacity(selected ? 1.0 : 0.25),
        border: selected ? Border.all(color: category.color, width: 2) : null,
      ),
      child: Icon(
        category.icon,
        color: selected ? Colors.white : category.color,
        size: size * 0.48,
      ),
    );
  }
}
