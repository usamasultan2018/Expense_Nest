// filter_sheet.dart

import 'package:expense_tracker/core/models/category_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SortOption { highest, lowest, newest, oldest }

class FilterSheet extends StatefulWidget {
  final TransactionType? initialTypeFilter;
  final SortOption initialSort;
  final Set<String> initialCategories;

  const FilterSheet({
    super.key,
    this.initialTypeFilter,
    this.initialSort = SortOption.newest,
    this.initialCategories = const {},
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late TransactionType? _typeFilter;
  late SortOption _sort;
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _typeFilter = widget.initialTypeFilter;
    _sort = widget.initialSort;
    _selectedCategories = Set.from(widget.initialCategories);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.read<TransactionController>();

    // Derive unique categories from transactions
    final allCategories = controller.allTransactions
        .map((t) => t.category)
        .whereType<CategoryModel>()
        .fold<Map<String, CategoryModel>>({}, (map, c) {
          map[c.title] = c;
          return map;
        })
        .values
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, _result()),
                    child: Text('Apply',
                        style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    color: theme.primaryColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('Filter Transaction',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() {
                      _typeFilter = null;
                      _sort = SortOption.newest;
                      _selectedCategories.clear();
                    }),
                    child: Text('Reset',
                        style: TextStyle(color: theme.primaryColor)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable body
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  // ── Filter by ──────────────────────────────────────────
                  _SectionLabel(label: 'Filter by'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      _ToggleChip(
                        label: 'Income',
                        isSelected: _typeFilter == TransactionType.income,
                        onTap: () => setState(() {
                          _typeFilter = _typeFilter == TransactionType.income
                              ? null
                              : TransactionType.income;
                        }),
                      ),
                      _ToggleChip(
                        label: 'Expense',
                        isSelected: _typeFilter == TransactionType.expense,
                        onTap: () => setState(() {
                          _typeFilter = _typeFilter == TransactionType.expense
                              ? null
                              : TransactionType.expense;
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Sort by ────────────────────────────────────────────
                  _SectionLabel(label: 'Sort by'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: SortOption.values.map((opt) {
                      return _ToggleChip(
                        label: _sortLabel(opt),
                        isSelected: _sort == opt,
                        onTap: () => setState(() => _sort = opt),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Category ───────────────────────────────────────────
                  _SectionLabel(label: 'Category'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: allCategories.map((cat) {
                      return _ToggleChip(
                        label: cat.title,
                        isSelected: _selectedCategories.contains(cat.title),
                        onTap: () => setState(() {
                          _selectedCategories.contains(cat.title)
                              ? _selectedCategories.remove(cat.title)
                              : _selectedCategories.add(cat.title);
                        }),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _sortLabel(SortOption opt) {
    switch (opt) {
      case SortOption.highest:
        return 'Highest';
      case SortOption.lowest:
        return 'Lowest';
      case SortOption.newest:
        return 'Newest';
      case SortOption.oldest:
        return 'Oldest';
    }
  }

  FilterResult _result() => FilterResult(
        typeFilter: _typeFilter,
        sort: _sort,
        selectedCategories: _selectedCategories,
      );
}

class FilterResult {
  final TransactionType? typeFilter;
  final SortOption sort;
  final Set<String> selectedCategories;

  const FilterResult({
    required this.typeFilter,
    required this.sort,
    required this.selectedCategories,
  });
}

// ── Small reusable widgets ─────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold));
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : theme.dividerColor.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.primaryColor : theme.hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
