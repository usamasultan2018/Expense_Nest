import 'package:expense_tracker/components/fade_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacy_policy_title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: FadeTransitionEffect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.privacy_policy_app_name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.privacy_policy_last_updated,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_intro,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_info_collect,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .privacy_policy_info_collect_details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_use_info,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.privacy_policy_use_info_details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_sharing_info,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .privacy_policy_sharing_info_details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_data_retention,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .privacy_policy_data_retention_details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_security,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.privacy_policy_security_details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_rights,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.privacy_policy_rights_details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_changes,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.privacy_policy_changes_details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.privacy_policy_contact,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.privacy_policy_contact_details,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
