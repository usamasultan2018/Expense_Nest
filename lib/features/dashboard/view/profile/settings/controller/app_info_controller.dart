import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoController extends ChangeNotifier {
  String version = '';

  Future<void> loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    version = '${info.version} (${info.buildNumber})';
    notifyListeners();
  }
}
