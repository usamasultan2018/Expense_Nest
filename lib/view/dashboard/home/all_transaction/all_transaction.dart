import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_tracker/view/dashboard/transactions/edit_transactions.dart';
import 'package:expense_tracker/components/no_transaction.dart';
import 'package:expense_tracker/components/transaction_tile.dart';
import 'package:expense_tracker/utils/helpers/skeleton.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';

class AllTransaction extends StatefulWidget {
  const AllTransaction({super.key});

  @override
  _AllTransactionState createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildTimePeriodSelector(transactionController),
          const SizedBox(height: 20),
          _buildSearchField(transactionController),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: transactionController.transactionsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => const TileSkeleton(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const NoTransaction();
                } else {
                  List<TransactionModel> transactions = snapshot.data!;
                  List<TransactionModel> filteredTransactions =
                      transactionController.filterTransactions(transactions);

                  if (filteredTransactions.isEmpty) {
                    return const NoTransaction();
                  }
                  _animationController.forward(from: 0);
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.builder(
                        key: ValueKey(filteredTransactions.length),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TransactionTile(
                              onPressed: () {
                                transactionController.loadTransactionForEditing(
                                    filteredTransactions[index]);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (ctx) {
                                  return EditTransaction(
                                      transaction: filteredTransactions[index]);
                                }));
                              },
                              transaction: filteredTransactions[index],
                              iconData: filteredTransactions[index].category,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodSelector(TransactionController transactionController) {
    final List<String> timePeriods = [
      'All Time',
      'This Year',
      'This Month',
      'This Week',
      'Yesterday',
      'Today',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: timePeriods.length,
          itemBuilder: (context, index) {
            String timePeriod = timePeriods[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  transactionController.selectedTimePeriod = timePeriod;
                });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  border: transactionController.selectedTimePeriod == timePeriod
                      ? Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )
                      : null,
                ),
                child: Text(
                  timePeriod,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField(TransactionController transactionController) {
    final TextEditingController textController =
        TextEditingController(text: transactionController.searchQuery);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: textController,
        onChanged: (val) {
          transactionController
              .updateSearchQuery(val); // Update the query in the controller
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          prefixIcon: Icon(
            FontAwesomeIcons.search,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          suffixIcon: transactionController.searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    transactionController
                        .updateSearchQuery(''); // Clear query in controller
                    textController.clear(); // Clear the TextField's text
                  },
                )
              : null,
          hintText: "Search transactions...",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
