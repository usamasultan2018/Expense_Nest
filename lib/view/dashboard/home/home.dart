import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/view/dashboard/home/all_transaction/all_transaction.dart';
import 'package:expense_tracker/view/dashboard/home/widgets/balance_card.dart';
import 'package:expense_tracker/view/dashboard/home/widgets/transaction.dart';
import 'package:expense_tracker/view/dashboard/home/widgets/userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("UserId ${HTrackerSharedPreferences.getString('userId')}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UserData(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align to the start
              children: [
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                const BalanceCard(),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.transaction,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return const AllTransaction();
                        }));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
                const Transactions(),
                // ListView.builder(
                //     shrinkWrap: true,
                //     itemBuilder: (context, index) => TransactionCardSkeleton(),
                //     itemCount: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
