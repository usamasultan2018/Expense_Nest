import 'package:purchases_flutter/purchases_flutter.dart';

String trialLabel(IntroductoryPrice trial) {
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

String periodLabel(Package package) {
  return switch (package.packageType) {
    PackageType.monthly => 'per month',
    PackageType.annual => 'per year',
    PackageType.weekly => 'per week',
    PackageType.lifetime => 'one-time',
    _ => '',
  };
}
