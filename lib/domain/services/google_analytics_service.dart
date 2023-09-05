// import 'dart:developer' as dev;
//
// import 'package:firebase_analytics/firebase_analytics.dart';
//
// import 'analytics_service.dart';
//
// class GoogleAnalyticsService implements AnalyticsService {
//   final _analytics = FirebaseAnalytics.instance;
//
//   @override
//   void event(String name, [Map<String, dynamic>? parameters]) {
//     try {
//       _analytics.logEvent(name: name, parameters: parameters);
//     } on ArgumentError catch (e) {
//       dev.log('Unable to send analytics event $name');
//       dev.log(e.toString());
//     }
//   }
// }
