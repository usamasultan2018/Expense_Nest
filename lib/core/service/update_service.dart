import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateService {
  static Future<bool> isUpdateAvailable() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await remoteConfig.fetchAndActivate();

  final packageInfo = await PackageInfo.fromPlatform();

    final currentVersion = packageInfo.version;

    final latestVersion = remoteConfig.getString('latest_version');

    print('Current Version: $currentVersion');
    print('Latest Version: $latestVersion');

    return currentVersion != latestVersion;
  }

  static String get updateTitle =>
      FirebaseRemoteConfig.instance.getString('update_title');

  static bool get forceUpdate =>
      FirebaseRemoteConfig.instance.getBool('force_update');
}
