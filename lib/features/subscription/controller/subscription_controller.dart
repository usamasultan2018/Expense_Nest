import 'package:expense_tracker/features/subscription/services/revenuecat_service.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends ChangeNotifier {
  final RevenueCatService _service;
  final UserController _userController;

  SubscriptionController({
    RevenueCatService? service,
    required UserController userController,
  })  : _service = service ?? RevenueCatService(),
        _userController = userController;

  bool isLoading = false;
  String? errorMessage;

  List<Package> packages = [];

  final Map<String, IntroductoryPrice?> introductoryPrices = {};

  /// Always read isPremium from UserController (single source of truth = Firestore)
  bool get isPremium => _userController.currentUser?.isPremium ?? false;

  bool get hasError => errorMessage != null;

  IntroductoryPrice? trialFor(Package package) =>
      introductoryPrices[package.storeProduct.identifier];

  void _notify() => notifyListeners();

  Future<void> initialize() => loadSubscriptionData();

  Future<void> loadSubscriptionData() async {
    isLoading = true;
    errorMessage = null;
    _notify();

    try {
      final offerings = await _service.getOfferings();

      packages = offerings.current?.availablePackages ?? [];

      introductoryPrices.clear();

      for (final p in packages) {
        introductoryPrices[p.storeProduct.identifier] =
            p.storeProduct.introductoryPrice;
      }
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Error loading subscription data: $e');
    }

    isLoading = false;
    _notify();
  }

  Future<bool> purchase(Package package, BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    _notify();

    try {
      final customerInfo = await _service.purchasePackage(package);

      final isActive = _service.checkEntitlement(customerInfo);

      if (isActive) {
        /// Webhook will update Firestore — re-fetch user to get latest isPremium
        await Future.delayed(const Duration(seconds: 2));
        await _userController.fetchUser();
      }

      isLoading = false;
      _notify();
      return isPremium; // reads from UserController after fetchUser()
    } on PurchasesError catch (e) {
      isLoading = false;
      _notify();
      rethrow;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Purchase error: $e');
      isLoading = false;
      _notify();
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    isLoading = true;
    errorMessage = null;
    _notify();

    try {
      final customerInfo = await _service.restorePurchases();

      final isActive = _service.checkEntitlement(customerInfo);

      if (isActive) {
        /// Webhook will update Firestore — re-fetch user to get latest isPremium
        await Future.delayed(const Duration(seconds: 2));
        await _userController.fetchUser();
      }

      isLoading = false;
      _notify();
      return isPremium; // reads from UserController after fetchUser()
    } on PurchasesError catch (e) {
      isLoading = false;
      _notify();
      rethrow;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Restore error: $e');
      isLoading = false;
      _notify();
      return false;
    }
  }

  void clearError() {
    errorMessage = null;
    _notify();
  }
}
