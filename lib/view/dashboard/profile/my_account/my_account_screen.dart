import 'package:expense_tracker/components/loading_widget.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/appColors.dart';

import 'package:expense_tracker/utils/helpers/date.dart';
import 'package:expense_tracker/view/dashboard/profile/widgets/edit_profile_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the generated localization class

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  int incomeCount = 0;
  int expenseCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchTransactionCounts();
  }

  Future<void> _fetchTransactionCounts() async {
    try {
      final counts = await TransactionRepository().getTransactionCounts();
      setState(() {
        incomeCount = counts['income'] ?? 0;
        expenseCount = counts['expense'] ?? 0;
      });
    } catch (e) {
      print("Error fetching transaction counts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("No user is currently logged in."));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myAccount), // Localized text
      ),
      body: StreamBuilder<UserModel?>(
        stream: UserRepository().streamUserData(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No user data available."));
          }

          final UserModel userModel = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!
                      .loginInformation, // Localized text
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .nickname, // Localized text
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.primary,
                                    )),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: userModel
                                          .profilePicture.isNotEmpty
                                      ? NetworkImage(userModel.profilePicture)
                                      : const AssetImage(
                                              'assets/images/boy.png')
                                          as ImageProvider<Object>,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(userModel.username,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          EditProfileSheet(userModel: userModel),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!
                            .connectedAccount, // Localized text
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 20),
                          const SizedBox(width: 10),
                          Text(userModel.email,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!
                            .registeredOn, // Localized text
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            DateTimeUtils.formatDateMonthDayYear(
                                userModel.createdAt),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!
                      .myTransactions, // Localized text
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .recordedIncomes, // Localized text
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  incomeCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const Icon(Icons.done_all_sharp),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .recordedExpenses, // Localized text
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  expenseCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const Icon(Icons.done_all_sharp),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
