import 'package:expense_tracker/components/fade_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.terms_and_services_title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: FadeTransitionEffect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.terms_and_services_title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.last_updated,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey, // Modify color based on your theme
                ),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.accept_terms,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_acceptance_of_terms,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.acceptance_of_terms,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_changes_to_terms,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.changes_to_terms,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_user_responsibilities,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.user_responsibilities,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_account_registration,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.account_registration,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_data_privacy,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.data_privacy,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_intellectual_property,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.intellectual_property,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_termination_of_service,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.termination_of_service,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_limitation_of_liability,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.limitation_of_liability,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_governing_law,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.governing_law,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.section_contact_us,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.contact_us,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
