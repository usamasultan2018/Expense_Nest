import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/loading_widget.dart';
import 'package:expense_tracker/components/no_transaction.dart';
import 'package:expense_tracker/components/transaction_tile.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/utils/helpers/Skeleton.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/geticons.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:expense_tracker/view/dashboard/transactions/edit_transactions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    // Initialize the AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Duration of the animation
      vsync: this,
    );

    // Create the fade animation
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation when the widget is built
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller when not needed
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
          SizedBox(height: 10),
          _buildTimePeriodSelector(transactionController),
          SizedBox(height: 20),
          _buildSearchField(transactionController),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: transactionController
                  .transactionsStream, // Method to fetch transactions
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        FadeTransitionEffect(child: TransactionCardSkeleton()),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FadeTransitionEffect(child: NoTransaction()),
                  );
                } else {
                  List<TransactionModel> transactions = snapshot.data!;
                  List<TransactionModel> filteredTransactions =
                      transactionController.filterTransactions(transactions);

                  if (filteredTransactions.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: NoTransaction(),
                    );
                  }
                  _animationController.forward(
                      from: 0); // Restart animation on update
                  return AnimatedSwitcher(
                    duration: Duration(microseconds: 300),
                    child: FadeTransition(
                      opacity:
                          _fadeAnimation, // Use FadeTransition to animate opacity
                      child: ListView.builder(
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
                              color: getCategoryLightColor(
                                  transactions[index].category),
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
              onTap: () =>
                  transactionController.selectedTimePeriod = timePeriod,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 5),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  border: transactionController.selectedTimePeriod == timePeriod
                      ? Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1)
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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<TransactionController>(
          builder: (BuildContext context, TransactionController value,
              Widget? child) {
            return TextFormField(
              // onTapAlwaysCalled: (){},
              onChanged: (val) {
                setState(() {
                  value.searchQuery = val;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surface, // Change color based on readOnly
                prefixIcon: Icon(
                  FontAwesomeIcons.search,

                  color: Theme.of(context)
                      .colorScheme
                      .onSurface, // Use theme color for icon
                ),
                hintText: "Search transactions...",
                hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6)), // Adjust hint text color
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
              ),
            );
          },
        ));
  }
}
