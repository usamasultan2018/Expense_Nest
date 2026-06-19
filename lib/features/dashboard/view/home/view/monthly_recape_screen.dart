import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const _quotes = [
  "The best way to predict your future is to create it.\n- Peter Drucker",
  "A penny saved is a penny earned.\n- Benjamin Franklin",
  "Do not save what is left after spending, spend what is left after saving.\n- Warren Buffett",
  "Financial freedom is available to those who learn about it and work for it.\n- Robert Kiyosaki",
  "It's not how much money you make, but how much money you keep.\n- Robert Kiyosaki",
];

class MonthlyRecapScreen extends StatefulWidget {
  const MonthlyRecapScreen({super.key});

  @override
  State<MonthlyRecapScreen> createState() => _MonthlyRecapScreenState();
}

class _MonthlyRecapScreenState extends State<MonthlyRecapScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _progressController;
  int _currentPage = 0;
  final int _totalPages = 3;
  final Duration _pageDuration = const Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: _pageDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextPage();
        }
      });
    _progressController.forward();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _progressController.reset();
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();

    // ✅ reads currency reactively
    final currency = context.watch<CurrencyController>();

    final now = DateTime.now();

    final monthTransactions = controller.allTransactions
        .where(
            (t) => t.dateTime.year == now.year && t.dateTime.month == now.month)
        .toList();

    final totalIncome = monthTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);

    final totalExpense = monthTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);

    // Biggest income category
    final Map<String, double> incomeByCategory = {};
    for (final t in monthTransactions
        .where((t) => t.type == TransactionType.income && t.category != null)) {
      incomeByCategory[t.category!.title] =
          (incomeByCategory[t.category!.title] ?? 0) + t.amount;
    }
    final biggestIncomeEntry = incomeByCategory.entries.isEmpty
        ? null
        : incomeByCategory.entries.reduce((a, b) => a.value > b.value ? a : b);
    final biggestIncomeCategory = monthTransactions
        .where((t) =>
            t.category?.title == biggestIncomeEntry?.key &&
            t.type == TransactionType.income)
        .map((t) => t.category)
        .firstOrNull;

    // Biggest expense category
    final Map<String, double> expenseByCategory = {};
    for (final t in monthTransactions.where(
        (t) => t.type == TransactionType.expense && t.category != null)) {
      expenseByCategory[t.category!.title] =
          (expenseByCategory[t.category!.title] ?? 0) + t.amount;
    }
    final biggestExpenseEntry = expenseByCategory.entries.isEmpty
        ? null
        : expenseByCategory.entries.reduce((a, b) => a.value > b.value ? a : b);
    final biggestExpenseCategory = monthTransactions
        .where((t) =>
            t.category?.title == biggestExpenseEntry?.key &&
            t.type == TransactionType.expense)
        .map((t) => t.category)
        .firstOrNull;

    final quote = _quotes[now.month % _quotes.length];

    final pages = [
      _SummarySlide(
        isIncome: true,
        totalAmount: totalIncome,
        currencySymbol: currency.symbol, // ✅ pass symbol
        biggestCategoryTitle: biggestIncomeEntry?.key,
        biggestCategoryAmount: biggestIncomeEntry?.value,
        biggestCategoryIcon: biggestIncomeCategory?.icon,
        biggestCategoryColor: biggestIncomeCategory?.color,
      ),
      _SummarySlide(
        isIncome: false,
        totalAmount: totalExpense,
        currencySymbol: currency.symbol, // ✅ pass symbol
        biggestCategoryTitle: biggestExpenseEntry?.key,
        biggestCategoryAmount: biggestExpenseEntry?.value,
        biggestCategoryIcon: biggestExpenseCategory?.icon,
        biggestCategoryColor: biggestExpenseCategory?.color,
      ),
      _QuoteSlide(quote: quote),
    ];

    return Scaffold(
      body: GestureDetector(
        onTapUp: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 2) {
            _prevPage();
          } else {
            _nextPage();
          }
        },
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),

            // Progress bars
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: List.generate(_totalPages, (i) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: i < _currentPage
                              ? Container(height: 3, color: Colors.white)
                              : i == _currentPage
                                  ? AnimatedBuilder(
                                      animation: _progressController,
                                      builder: (_, __) =>
                                          LinearProgressIndicator(
                                        value: _progressController.value,
                                        minHeight: 3,
                                        backgroundColor:
                                            Colors.white.withValues(alpha: 0.3),
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                Colors.white),
                                      ),
                                    )
                                  : Container(
                                      height: 3,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Close button
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, right: 16),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quote Slide ────────────────────────────────────────────────────────────

class _QuoteSlide extends StatelessWidget {
  final String quote;
  const _QuoteSlide({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF4A98A),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D1B0E),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              // Handle tap event
              context.read<BottomNavController>().setIndex(3);
              context.pop();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF2D1B0E),
                borderRadius: BorderRadius.circular(32),
              ),
              alignment: Alignment.center,
              child: const Text(
                'See the full details',
                style: TextStyle(
                  color: Color(0xFFF4A98A),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary Slide ──────────────────────────────────────────────────────────

class _SummarySlide extends StatelessWidget {
  final bool isIncome;
  final double totalAmount;
  final String currencySymbol; // ✅ new param
  final String? biggestCategoryTitle;
  final double? biggestCategoryAmount;
  final IconData? biggestCategoryIcon;
  final Color? biggestCategoryColor;

  const _SummarySlide({
    required this.isIncome,
    required this.totalAmount,
    required this.currencySymbol, // ✅ new param
    this.biggestCategoryTitle,
    this.biggestCategoryAmount,
    this.biggestCategoryIcon,
    this.biggestCategoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isIncome ? const Color(0xFF2EC56A) : const Color(0xFFEF5350);
    final emoji = isIncome ? '💰' : '💸';
    final label = isIncome ? 'You Earned' : 'You Spend';
    final biggestLabel = isIncome
        ? 'your biggest income is from'
        : 'your biggest spending is from';

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'This month',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$label $emoji',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            // ✅ dynamic symbol
            '$currencySymbol${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B0E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  'and $biggestLabel',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                if (biggestCategoryTitle != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (biggestCategoryColor ?? Colors.white)
                                .withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            biggestCategoryIcon ?? Icons.category,
                            color: biggestCategoryColor ?? Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          biggestCategoryTitle!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Text(
                    'No transactions yet',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                const SizedBox(height: 16),
                Text(
                  // ✅ dynamic symbol
                  '$currencySymbol${(biggestCategoryAmount ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
