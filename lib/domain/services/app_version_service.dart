// import 'dart:convert';
//
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:package_info_plus/package_info_plus.dart';
//
// class AppVersionService {
//   PackageInfo? packageInfo;
//   // RemoteConfig? _remoteConfig;
//   bool? _isForceUpdate;
//
//   String get packageName => packageInfo?.packageName ?? '';
//   String get version => packageInfo?.version ?? '';
//   String get buildNumber => packageInfo?.buildNumber ?? '';
//   String get buildSignature => packageInfo?.buildSignature ?? '';
//   bool get isForceUpdate => _isForceUpdate ?? false;
//
//   Future<void> init() async {
//     packageInfo = await PackageInfo.fromPlatform();
//     _remoteConfig = RemoteConfig.instance;
//     await _remoteConfig?.setConfigSettings(
//       RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(seconds: 24),
//       ),
//     );
//     await _remoteConfig?.fetchAndActivate();
//   }
//
//   bool needsUpdate() {
//     final String? versionConfigString = _remoteConfig?.getString('version_config');
//     if (versionConfigString == null || versionConfigString.isEmpty) {
//       return false;
//     }
//     final versionConfig = jsonDecode(versionConfigString);
//     _isForceUpdate = versionConfig['force'] ?? false;
//     final String remoteVersion = versionConfig['version'];
//
//     final List<int> currentVersion = version.split('.').map((String number) => int.tryParse(number) ?? 0).toList();
//     final List<int> enforcedVersion =
//         remoteVersion.split('.').map((String number) => int.tryParse(number) ?? 0).toList();
//     for (int i = 0; i < 3; i++) {
//       if (enforcedVersion[i] > currentVersion[i]) return true;
//     }
//
//     return false;
//   }
// }
