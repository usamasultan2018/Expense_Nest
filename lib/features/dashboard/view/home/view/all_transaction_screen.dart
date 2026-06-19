import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/core/components/no_transaction.dart';
import 'package:expense_tracker/core/components/transaction_tile.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/core/utils/date.dart';
import 'package:expense_tracker/core/utils/skeleton_loading.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/widgets/filter_chip.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/widgets/transaction_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum _TimeFilter { all, year, month }

enum SortOption { highest, lowest, newest, oldest }

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

class AllTransactionScreen extends StatefulWidget {
  const AllTransactionScreen({super.key});

  @override
  State<AllTransactionScreen> createState() => _AllTransactionScreenState();
}

class _AllTransactionScreenState extends State<AllTransactionScreen> {
  _TimeFilter _timeFilter = _TimeFilter.all;
  SortOption _sort = SortOption.newest;
  String _searchQuery = '';
  TransactionType? _typeFilter;
  Set<String> _selectedCategories = {};

  // ── Filtering & sorting ───────────────────────────────────────────────────

  List<TransactionModel> _applyFilters(List<TransactionModel> transactions) {
    final now = DateTime.now();

    var result = transactions.where((t) {
      if (_timeFilter == _TimeFilter.year && t.dateTime.year != now.year) {
        return false;
      }
      if (_timeFilter == _TimeFilter.month &&
          (t.dateTime.year != now.year || t.dateTime.month != now.month)) {
        return false;
      }
      if (_typeFilter != null && t.type != _typeFilter) return false;
      if (_selectedCategories.isNotEmpty &&
          !_selectedCategories.contains(t.category?.title)) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!t.note.toLowerCase().contains(q) &&
            !(t.category?.title.toLowerCase().contains(q) ?? false)) {
          return false;
        }
      }
      return true;
    }).toList();

    switch (_sort) {
      case SortOption.newest:
        result.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      case SortOption.oldest:
        result.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      case SortOption.highest:
        result.sort((a, b) => b.amount.compareTo(a.amount));
      case SortOption.lowest:
        result.sort((a, b) => a.amount.compareTo(b.amount));
    }

    return result;
  }

  // ── Group by date ─────────────────────────────────────────────────────────

  /// Returns a list of mixed items: either a _DateHeader or a TransactionModel.
  List<Object> _groupByDate(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return [];

    final Map<String, List<TransactionModel>> grouped = {};

    for (final t in transactions) {
      final key = DateTimeUtils.formatDateMonthDayYear(t.dateTime);
      grouped.putIfAbsent(key, () => []).add(t);
    }

    final List<Object> items = [];
    for (final entry in grouped.entries) {
      final dayNet = entry.value.fold<double>(0, (sum, t) {
        return t.type == TransactionType.income
            ? sum + t.amount
            : sum - t.amount;
      });
      items.add(_DateHeader(date: entry.key, net: dayNet));
      items.addAll(entry.value);
    }

    return items;
  }

  // ── Filter sheet ──────────────────────────────────────────────────────────

  Future<void> _openFilterSheet(List<TransactionModel> all) async {
    final theme = Theme.of(context);
    final result = await showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterSheet(
        allTransactions: all,
        initialTypeFilter: _typeFilter,
        initialSort: _sort,
        initialCategories: _selectedCategories,
      ),
    );

    if (result != null) {
      setState(() {
        _typeFilter = result.typeFilter;
        _sort = result.sort;
        _selectedCategories = result.selectedCategories;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasActiveFilter =
        _typeFilter != null || _selectedCategories.isNotEmpty;

    return Consumer<TransactionController>(
      builder: (context, controller, _) {
        final filtered = _applyFilters(controller.allTransactions);
        final items = _groupByDate(filtered);

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: const Text(
              "Transactions",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () => context.push(RouteName.recurringTransactions),
                icon: Icon(Icons.timer_outlined, color: theme.primaryColor),
              ),
              IconButton(
                onPressed: () => _openFilterSheet(controller.allTransactions),
                icon: Icon(
                  hasActiveFilter ? Icons.filter_alt : Icons.filter_list,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Financial report banner
                  GestureDetector(
                    onTap: () => context.push(RouteName.monthlyRecap),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "See your financial report",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: theme.primaryColor),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Time filters
                  Row(
                    children: [
                      Expanded(
                        child: FiltersChip(
                          label: "All time",
                          isSelected: _timeFilter == _TimeFilter.all,
                          onTap: () =>
                              setState(() => _timeFilter = _TimeFilter.all),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FiltersChip(
                          label: "This year",
                          isSelected: _timeFilter == _TimeFilter.year,
                          onTap: () =>
                              setState(() => _timeFilter = _TimeFilter.year),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FiltersChip(
                          label: "This month",
                          isSelected: _timeFilter == _TimeFilter.month,
                          onTap: () =>
                              setState(() => _timeFilter = _TimeFilter.month),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    hintText: "Search",
                    prefixIcon:
                        Icon(Icons.search_rounded, color: theme.primaryColor),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),

                  const SizedBox(height: 20),

                  // List
                  Expanded(
                    child: controller.isLoadingTransactions
                        ? ListView.builder(
                            itemCount: controller.allTransactions.length,
                            itemBuilder: (_, __) =>
                                const TransactionCardSkeleton(),
                          )
                        : items.isEmpty
                            ? const NoTransaction()
                            : ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (_, i) {
                                  final item = items[i];
                                  if (item is _DateHeader) {
                                    return _DateHeaderRow(header: item);
                                  }
                                  final t = item as TransactionModel;
                                  return TransactionTile(
                                    transaction: t,
                                    onPressed: () => context.push(
                                      '/edit-transaction',
                                      extra: t,
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Date header model ──────────────────────────────────────────────────────

class _DateHeader {
  final String date;
  final double net;
  const _DateHeader({required this.date, required this.net});
}

// ── Date header row widget ─────────────────────────────────────────────────

class _DateHeaderRow extends StatelessWidget {
  final _DateHeader header;
  const _DateHeaderRow({required this.header});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header.date,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
