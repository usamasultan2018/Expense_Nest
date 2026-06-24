import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../controller/subscription_controller.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  const SubscriptionBottomSheet({super.key});

  static Future<void> show(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    final result = await showModalBottomSheet<_SheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => ChangeNotifierProvider.value(
        value: context.read<SubscriptionController>(),
        child: const SubscriptionBottomSheet(),
      ),
    );

    if (result != null && messenger.mounted) {
      messenger.clearSnackBars();
      messenger.showSnackBar(SnackBar(
        content: Text(result.message),
        backgroundColor: result.isSuccess
            ? const Color(0xFF2E7D32)
            : const Color(0xFFC62828),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      ));
    }
  }

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SheetResult {
  final String message;
  final bool isSuccess;
  const _SheetResult({required this.message, required this.isSuccess});
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet>
    with SingleTickerProviderStateMixin {
  Package? _selectedPackage;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _handledPremium = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final packages = context.read<SubscriptionController>().packages;
      if (packages.isNotEmpty) {
        setState(() => _selectedPackage = packages.first);
      }
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _closeWithResult(_SheetResult result) {
    if (mounted) Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<SubscriptionController>(
      builder: (context, controller, _) {
        if (controller.isPremium && !controller.isLoading && !_handledPremium) {
          _handledPremium = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _closeWithResult(const _SheetResult(
              message: 'Welcome to Premium! 🎉 Enjoy all features.',
              isSuccess: true,
            ));
          });
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              _buildHandle(theme),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildHero(theme),
                          _buildFeatures(theme),
                          _buildPlans(theme, controller),
                          _buildActions(theme, controller),
                          _buildFooterLinks(theme, controller),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: theme.dividerColor,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }

  Widget _buildHero(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.18),
                      colorScheme.tertiary.withValues(alpha: 0.12),
                    ],
                  ),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/appp_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.tertiary],
                    ),
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '✦ PREMIUM',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Take full control\nof your finances',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Everything you need, nothing you don\'t.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    const features = [
      (Icons.account_balance_wallet_rounded, 'Unlimited budgets'),
      (Icons.cloud_upload_rounded, 'Cloud backup & sync'),
      (Icons.repeat_rounded, 'Recurring transactions'),
      (Icons.bar_chart_rounded, 'Advanced analytics'),
      (Icons.file_download_rounded, 'PDF & CSV export'),
      (Icons.support_agent_rounded, 'Priority support'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Everything included',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 4.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 4,
            children:
                features.map((f) => _featureTile(theme, f.$1, f.$2)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _featureTile(ThemeData theme, IconData icon, String label) {
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: colorScheme.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlans(ThemeData theme, SubscriptionController controller) {
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
            final index = entry.key;
            final package = entry.value;
            final trial = controller.trialFor(package);
            return _PlanTile(
              package: package,
              isSelected: _selectedPackage == package,
              isBestValue: index == 0 && controller.packages.length > 1,
              trial: trial,
              onTap: () => setState(() => _selectedPackage = package),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActions(ThemeData theme, SubscriptionController controller) {
    final colorScheme = theme.colorScheme;
    final hasTrial = _selectedPackage != null &&
        controller.trialFor(_selectedPackage!) != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: controller.isLoading
                    ? null
                    : LinearGradient(
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                boxShadow: controller.isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      controller.isLoading ? null : Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: controller.isLoading ? null : () => _onPurchase(context),
                icon: controller.isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Icon(
                        hasTrial
                            ? Icons.play_circle_outline_rounded
                            : Icons.lock_open_rounded,
                        size: 18,
                      ),
                label: Text(
                  controller.isLoading
                      ? 'Processing...'
                      : hasTrial
                          ? 'Start Free Trial'
                          : 'Unlock Premium',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (hasTrial)
            Text(
              'No charge during trial · Cancel any time',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooterLinks(ThemeData theme, SubscriptionController controller) {
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: controller.isLoading ? null : _onRestore,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Restore purchases',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text('·',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          TextButton(
            onPressed: () {/* open privacy policy */},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Privacy',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
          ),
          Text('·',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          TextButton(
            onPressed: () {/* open terms */},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Terms',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }

  Future<void> _onPurchase(BuildContext context) async {
    if (_selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a plan first.')),
      );
      return;
    }

    final controller = context.read<SubscriptionController>();

    try {
      final success = await controller.purchase(_selectedPackage!,context);
      if (!success && mounted) {
        _closeWithResult(const _SheetResult(
          message: 'Purchase could not be completed. Please try again.',
          isSuccess: false,
        ));
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

      if (isSilent) {
        Navigator.of(context).pop();
      } else {
        _closeWithResult(_SheetResult(message: msg, isSuccess: isSuccess));
      }
    } catch (e) {
      debugPrint('🔴 Unknown purchase error: $e');
      if (!mounted) return;
      _closeWithResult(const _SheetResult(
        message: 'Unexpected error. Please try again.',
        isSuccess: false,
      ));
    }
  }

  Future<void> _onRestore() async {
    final controller = context.read<SubscriptionController>();

    // Reset so the isPremium listener can re-fire even if already premium
    setState(() => _handledPremium = false);

    try {
      final success = await controller.restorePurchases();
      if (!mounted) return;

      if (success) {
        // If the isPremium listener already fired and closed the sheet,
        // _handledPremium is true and we're unmounted — guard above catches it.
        // If isPremium was already true before restore, close explicitly.
        if (!_handledPremium) {
          _closeWithResult(const _SheetResult(
            message: 'Welcome back to Premium! 🎉',
            isSuccess: true,
          ));
        }
      } else {
        _closeWithResult(const _SheetResult(
          message: 'No previous purchases found for this account.',
          isSuccess: false,
        ));
      }
    } on PurchasesError catch (e) {
      debugPrint('🔴 Restore PurchasesError: ${e.code}');
      if (!mounted) return;

      final msg = switch (e.code) {
        PurchasesErrorCode.networkError =>
          'No internet connection. Check your network.',
        _ => 'Couldn\'t restore purchases. Please try again.',
      };
      _closeWithResult(_SheetResult(message: msg, isSuccess: false));
    } catch (e) {
      debugPrint('🔴 Unknown restore error: $e');
      if (!mounted) return;
      _closeWithResult(const _SheetResult(
        message: 'Unexpected error during restore. Please try again.',
        isSuccess: false,
      ));
    }
  }
}

// ---------------------------------------------------------------------------

class _PlanTile extends StatelessWidget {
  final Package package;
  final bool isSelected;
  final bool isBestValue;
  final IntroductoryPrice? trial;
  final VoidCallback onTap;

  const _PlanTile({
    required this.package,
    required this.isSelected,
    required this.isBestValue,
    required this.trial,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFreeTrial = trial != null && trial!.price == 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.35)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isBestValue)
              Positioned(
                top: -24,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.tertiary],
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '🏆 Best value · Save 40%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: isSelected ? 0 : 1.5,
                    ),
                    color:
                        isSelected ? colorScheme.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          size: 13, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.storeProduct.title
                            .replaceAll(RegExp(r'\s*\(.*?\)\s*$'), '')
                            .trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? colorScheme.primary : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (hasFreeTrial)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '🎁 ${_trialLabel(trial!)}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      else
                        Text(
                          _periodLabel(package),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      package.storeProduct.priceString,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected ? colorScheme.primary : null,
                      ),
                    ),
                    Text(
                      _periodLabel(package),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _trialLabel(IntroductoryPrice trial) {
    final n = trial.periodNumberOfUnits;
    final unit = switch (trial.periodUnit) {
      PeriodUnit.day => n == 1 ? 'day' : 'days',
      PeriodUnit.week => n == 1 ? 'week' : 'weeks',
      PeriodUnit.month => n == 1 ? 'month' : 'months',
      PeriodUnit.year => n == 1 ? 'year' : 'years',
      _ => '',
    };
    return 'Free $n-$unit trial';
  }

  String _periodLabel(Package package) {
    return switch (package.packageType) {
      PackageType.monthly => 'per month',
      PackageType.annual => 'per year',
      PackageType.weekly => 'per week',
      PackageType.lifetime => 'one-time',
      _ => '',
    };
  }
}
