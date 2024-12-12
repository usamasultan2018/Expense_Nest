import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/view%20model/user_controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<UserController>(builder:
            (BuildContext context, UserController value, Widget? child) {
          return RoundButton(
              loading: value.isLoading,
              title: "Delete Account",
              onPress: () async {
                await value.deleteAccount(
                  context,
                );
              });
        }),
      ),
      appBar: AppBar(
        title: Text("Delete Account"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text("${auth.currentUser!.displayName}"),
          SizedBox(
            height: 5,
          ),
          Text(
            "Are you sure you want to delete your account?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Deleting account is permanent process!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "By deleting your account your profile, your transaction will be permantly deleted. Be aware of that! ",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
