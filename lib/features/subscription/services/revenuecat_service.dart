import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../exceptions/revenuecat_exception.dart';

class RevenueCatService {
  static const _entitlementKey = 'premium';

  Future<void> initialize(String apiKey) async {
    try {
      await Purchases.configure(PurchasesConfiguration(apiKey));
      debugPrint('[RevenueCat] Initialized successfully');
    } on PurchasesError catch (e) {
      throw RevenueCatException(
        'Failed to initialize RevenueCat',
        code: e.code.name,
        originalError: e,
      );
    }
  }

  Future<Offerings> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PurchasesError catch (e) {
      throw RevenueCatException(
        'Failed to fetch offerings',
        code: e.code.name,
        originalError: e,
      );
    }
  }
Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return result.customerInfo;
    } on PurchasesError catch (e) {
      if (e.code == PurchasesErrorCode.purchaseCancelledError) {
        throw RevenueCatException(
          'Purchase cancelled by user',
          code: 'CANCELLED',
          originalError: e,
        );
      }
      throw RevenueCatException(
        'Purchase failed: ${e.message}',
        code: e.code.name,
        originalError: e,
      );
    } catch (e) {
      throw RevenueCatException(
        'Purchase failed: $e',
        code: 'UNKNOWN',
        originalError: e,
      );
    }
  }

  Future<CustomerInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } on PurchasesError catch (e) {
      throw RevenueCatException(
        'Restore failed: ${e.message}',
        code: e.code.name,
        originalError: e,
      );
    }
  }

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } on PurchasesError catch (e) {
      throw RevenueCatException(
        'Failed to fetch customer info',
        code: e.code.name,
        originalError: e,
      );
    }
  }

  Future<bool> isPremiumUser() async {
    final info = await getCustomerInfo();
    return info.entitlements.active.containsKey(_entitlementKey);
  }

  bool checkEntitlement(CustomerInfo info) =>
      info.entitlements.active.containsKey(_entitlementKey);
}
