import 'package:expense_tracker/features/subscription/controller/subscription_controller.dart';
import 'package:expense_tracker/features/subscription/widgets/plan_tile.dart';
import 'package:expense_tracker/features/subscription/widgets/subscription_actions.dart';
import 'package:expense_tracker/features/subscription/widgets/subscription_features.dart';
import 'package:expense_tracker/features/subscription/widgets/subscription_footer.dart';
import 'package:expense_tracker/features/subscription/widgets/subscription_hero.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';



class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
    );
  }

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Package? _selectedPackage;
  bool _purchasedThisSession = false; // 👈 renamed — more explicit

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final controller = context.read<SubscriptionController>();

      // 👇 always reload fresh from RevenueCat when screen opens
      // this catches cancellations, expirations, etc.
      controller.loadSubscriptionData().then((_) {
        if (!mounted) return;
        final packages = controller.packages;
        if (packages.isNotEmpty) {
          setState(() => _selectedPackage = packages.first);
        }
      });
    });
  }

  void _showMessage(String message, {required bool isSuccess}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor:
          isSuccess ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionController>(
      builder: (context, controller, _) {
        // 👇 only auto-pop if premium was achieved THIS session (via purchase/restore)
        if (_purchasedThisSession &&
            controller.isPremium &&
            !controller.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _showMessage(
              'Welcome to Premium! 🎉 Enjoy all features.',
              isSuccess: true,
            );
            Navigator.of(context).pop();
          });
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SubscriptionHero(),
                const SubscriptionFeatures(),
                _buildPlans(controller),
                SubscriptionActions(
                  controller: controller,
                  selectedPackage: _selectedPackage,
                  onPurchase: () => _onPurchase(context),
                ),
                SubscriptionFooter(
                  controller: controller,
                  onRestore: () => _onRestore(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlans(SubscriptionController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (controller.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.packages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 36, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              'Plans unavailable right now.\nPlease try again later.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 14),
          Text(
            'Choose your plan',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          ...controller.packages.asMap().entries.map((entry) {
            final package = entry.value;
            final trial = controller.trialFor(package);
            return PlanTile(
              package: package,
              isSelected: _selectedPackage == package,
              isBestValue: entry.key == 0 && controller.packages.length > 1,
              trial: trial,
              onTap: () => setState(() => _selectedPackage = package),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _onPurchase(BuildContext context) async {
    if (_selectedPackage == null) {
      _showMessage('Please select a plan first.', isSuccess: false);
      return;
    }

    final controller = context.read<SubscriptionController>();

    try {
      final success = await controller.purchase(_selectedPackage!, context);
      if (success) {
        setState(() => _purchasedThisSession = true); // 👈 mark session
      } else if (mounted) {
        _showMessage(
          'Purchase could not be completed. Please try again.',
          isSuccess: false,
        );
      }
    } on PurchasesError catch (e) {
      debugPrint('🔴 PurchasesError: ${e.code} — ${e.message}');
      if (!mounted) return;

      final msg = switch (e.code) {
        PurchasesErrorCode.purchaseCancelledError =>
          'Purchase cancelled. No changes were made.',
        PurchasesErrorCode.paymentPendingError =>
          'Payment pending — we\'ll activate Premium once confirmed.',
        PurchasesErrorCode.networkError =>
          'No internet connection. Check your network and retry.',
        PurchasesErrorCode.productAlreadyPurchasedError =>
          'Already purchased! Tap "Restore purchases" to activate.',
        PurchasesErrorCode.receiptAlreadyInUseError =>
          'This receipt is linked to another account.',
        PurchasesErrorCode.purchaseNotAllowedError =>
          'Purchases are not allowed on this device.',
        PurchasesErrorCode.storeProblemError =>
          'Store issue. Please try again shortly.',
        _ => 'Something went wrong. Please try again.',
      };

      final isSuccess = e.code == PurchasesErrorCode.paymentPendingError;
      final isSilent = e.code == PurchasesErrorCode.purchaseCancelledError;

      if (!isSilent) _showMessage(msg, isSuccess: isSuccess);
    } catch (e) {
      debugPrint('🔴 Unknown purchase error: $e');
      if (!mounted) return;
      _showMessage('Unexpected error. Please try again.', isSuccess: false);
    }
  }

  Future<void> _onRestore(BuildContext context) async {
    final controller = context.read<SubscriptionController>();

    try {
      final success = await controller.restorePurchases();
      if (!mounted) return;

      if (success) {
        setState(() => _purchasedThisSession = true); // 👈 mark session
      } else {
        _showMessage(
          'No previous purchases found for this account.',
          isSuccess: false,
        );
      }
    } on PurchasesError catch (e) {
      debugPrint('🔴 Restore PurchasesError: ${e.code}');
      if (!mounted) return;
      final msg = switch (e.code) {
        PurchasesErrorCode.networkError =>
          'No internet connection. Check your network.',
        _ => 'Couldn\'t restore purchases. Please try again.',
      };
      _showMessage(msg, isSuccess: false);
    } catch (e) {
      debugPrint('🔴 Unknown restore error: $e');
      if (!mounted) return;
      _showMessage(
        'Unexpected error during restore. Please try again.',
        isSuccess: false,
      );
    }
  }
}
