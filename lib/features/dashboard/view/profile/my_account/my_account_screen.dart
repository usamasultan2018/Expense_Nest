import 'package:expense_tracker/core/components/loading_widget.dart';
import 'package:expense_tracker/features/dashboard/view/profile/my_account/widgets/transaction_count.dart';
import 'package:expense_tracker/features/dashboard/view/profile/my_account/widgets/user_info_section.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        centerTitle: true,
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          /// Loading State
          if (userController.isLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          final userModel = userController.currentUser;

          /// Empty State
          if (userModel == null) {
            return const Center(
              child: Text(
                "No user data available",
              ),
            );
          }

          /// Main Content
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            children: [
              UserInfoSection(
                userModel: userModel,
              ),
              const SizedBox(height: 20),
              const TransactionCountsSection(),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
