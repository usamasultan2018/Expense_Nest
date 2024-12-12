import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  final TextEditingController feedbackController = TextEditingController();

  // Function to send feedback via email
  Future<void> sendFeedback() async {
    final Email email = Email(
      body: feedbackController
          .text, // Get feedback text directly from the controller
      subject: 'App Feedback',
      recipients: ['usama.khan2018@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.feedbackEmailOpened)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.feedbackEmailError + ": $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.feedbackScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.feedbackPrompt,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: feedbackController,
              keyboardType: TextInputType.text,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.surface,
                hintText: AppLocalizations.of(context)!.feedbackHint,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            RoundButton(
              title: AppLocalizations.of(context)!.sendFeedbackButton,
              onPress: () {
                if (feedbackController.text.isNotEmpty) {
                  sendFeedback();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .feedbackEmptyWarning)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
