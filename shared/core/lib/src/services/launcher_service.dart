import 'package:dependencies/dependencies.dart';

import '../extensions/primitive_extensions.dart';

class LauncherService {
  void sendSupportEmail(String email) async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    final canLaunch = await canLaunchUrl(emailLaunchUri);

    if (canLaunch) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> launchApp({
    required String androidPackageName,
    required String iosUrlScheme,
    required String appStoreLink,
    required String? link,
  }) async {
    if (link == null ||
        !await LaunchApp.isAppInstalled(
          androidPackageName: androidPackageName,
          iosUrlScheme: iosUrlScheme,
        )) {
      await LaunchApp.openApp(
        androidPackageName: androidPackageName,
        iosUrlScheme: iosUrlScheme,
        appStoreLink: appStoreLink,
        openStore: true,
      );
      return;
    }

    if (!await canLaunchUrl(link.toUri)) {
      return;
    }
    // forceSafariVC: true, forceWebView: true, enableJavaScript: true
    await launchUrl(link.toUri);
  }

  Future<void> launchLink({
    required String link,
  }) async {
    if (!await canLaunchUrl(link.toUri)) {
      return;
    }
    // forceSafariVC: true, forceWebView: true, enableJavaScript: true
    await launchUrl(link.toUri);
  }
}
