import 'package:purchases_flutter/purchases_flutter.dart';

abstract interface class IRevenueCatService {
  Future<Offerings> getOfferings();
  Future<CustomerInfo> purchasePackage(Package package);
  Future<CustomerInfo> restorePurchases();
  Future<CustomerInfo> getCustomerInfo();
  bool checkEntitlement(CustomerInfo info);
}
