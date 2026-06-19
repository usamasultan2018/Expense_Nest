import 'package:expense_tracker/core/models/category_model.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/all_transaction_screen.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final List<TransactionModel> allTransactions;
  final TransactionType? initialTypeFilter;
  final SortOption initialSort;
  final Set<String> initialCategories;

  const FilterSheet({
    super.key,
    required this.allTransactions,
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

  List<CategoryModel> get _uniqueCategories {
    return widget.allTransactions
        .map((t) => t.category)
        .whereType<CategoryModel>()
        .fold<Map<String, CategoryModel>>({}, (map, c) {
          map[c.title] = c;
          return map;
        })
        .values
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
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

  bool get _hasChanges =>
      _typeFilter != null ||
      _sort != SortOption.newest ||
      _selectedCategories.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // ── Handle ───────────────────────────────────────────────
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // ── Header ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.close,
                            size: 18, color: colorScheme.onSurface),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Filter Transaction',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() {
                        _typeFilter = null;
                        _sort = SortOption.newest;
                        _selectedCategories.clear();
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Divider(
                  height: 1, color: theme.dividerColor.withValues(alpha: 0.2)),

              // ── Body ─────────────────────────────────────────────────
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  children: [
                    // Filter by
                    _SectionLabel('Filter by'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _TypeCard(
                            label: 'Income',
                            icon: Icons.arrow_downward_rounded,
                            color: colorScheme.primary,
                            isSelected: _typeFilter == TransactionType.income,
                            onTap: () => setState(() {
                              _typeFilter =
                                  _typeFilter == TransactionType.income
                                      ? null
                                      : TransactionType.income;
                            }),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TypeCard(
                            label: 'Expense',
                            icon: Icons.arrow_upward_rounded,
                            color: colorScheme.error,
                            isSelected: _typeFilter == TransactionType.expense,
                            onTap: () => setState(() {
                              _typeFilter =
                                  _typeFilter == TransactionType.expense
                                      ? null
                                      : TransactionType.expense;
                            }),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Sort by
                    _SectionLabel('Sort by'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: SortOption.values
                          .map((opt) => ToggleChip(
                                label: _sortLabel(opt),
                                isSelected: _sort == opt,
                                onTap: () => setState(() => _sort = opt),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 28),

                    // Category
                    _SectionLabel('Category'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _uniqueCategories
                          .map((cat) => ToggleChip(
                                label: cat.title,
                                isSelected:
                                    _selectedCategories.contains(cat.title),
                                onTap: () => setState(() {
                                  _selectedCategories.contains(cat.title)
                                      ? _selectedCategories.remove(cat.title)
                                      : _selectedCategories.add(cat.title);
                                }),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              // ── Apply button ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(
                    context,
                    FilterResult(
                      typeFilter: _typeFilter,
                      sort: _sort,
                      selectedCategories: _selectedCategories,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Apply Filter',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Type card (Income / Expense) ───────────────────────────────────────────

class _TypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : theme.cardColor,
          border: Border.all(
            color:
                isSelected ? color : theme.dividerColor.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : theme.hintColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.3),
    );
  }
}

// ── Toggle chip ────────────────────────────────────────────────────────────

class ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.12) : theme.cardColor,
          border: Border.all(
            color: isSelected
                ? primary
                : theme.dividerColor.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? primary : theme.hintColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
