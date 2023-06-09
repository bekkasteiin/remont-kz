import 'dart:io';

import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'http_call_utils.dart';
export 'indicators_utils.dart';
export 'network_utils.dart';

// ignore: avoid_classes_with_only_static_members
/// Basic Utils
class Utils {
  /// Example format : 22:00:00
  /// [hour]:[minutes]:[seconds]
  static Duration? durationTimeParse(String? time) {
    if (time == null) {
      return null;
    }
    var _parse = time.split(':');
    return Duration(
      hours: int.parse(_parse.first),
      minutes: int.parse(_parse[1]),
      seconds: int.parse(_parse[2]),
    );
  }

  /// Format from duration to valid duration string
  ///
  /// Example output: 22:00:00
  static String? durationTimeToString(Duration? duration) {
    if (duration == null) {
      return null;
    }

    return duration.toString().split('.').first.padLeft(8, "0");
  }

  /// Convert from duration to String time clock
  ///
  /// Example output: 18.00
  static String? durationToClock(Duration? duration) {
    if (duration == null) {
      return null;
    }

    var _parse = duration.toString().split(':');
    final _hours = _parse.first;
    final _minutes = _parse[1];

    return '$_hours.$_minutes';
  }

  /// Converting from dynamic value type,
  /// for example when from API response String or double value,
  ///
  /// But you don't know type data
  ///
  /// Example use:
  ///
  /// ```dart
  /// Utils.intParser('123'); // return 123
  /// Utils.intParser('123.1'); // return 123
  /// Utils.intParser(123.1); // return 123
  /// ```
  static int? intParser(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      return int.tryParse(value);
    }
    // ignore: avoid_returning_null
    return null;
  }

  /// Converting from dynamic value type,
  /// for example when from API response String or int value,
  ///
  /// But you don't know type data
  ///
  /// Example use:
  ///
  /// ```dart
  /// Utils.intParser('123'); // return 123.0
  /// Utils.intParser('123.1'); // return 123.1
  /// Utils.intParser(123.1); // return 123.1
  /// Utils.intParser(123); // return 123.0
  /// ```
  static double? doubleParser(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value);
    }
    // ignore: avoid_returning_null
    return null;
  }

  /// Default price format
  static String? priceFormatter(double price) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'IDR',
      decimalDigits: 0,
    );

    return formatCurrency.format(price);
  }

  /// Removing all html tags to plain text
  static String cleanerHTMLTags(String data) {
    var exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return data.replaceAll(exp, '');
  }

  /// Static function to launch whatsApp app
  static void launchWhatsApp(String phone, String? messagePattern) async {
    var url = Uri();
    if (Platform.isIOS) {
      url = Uri.parse('https://wa.me/$phone'
          '?text=${messagePattern ?? ''}');
    } else {
      url = Uri.parse('https://wa.me/$phone?'
          'text=${messagePattern ?? ''}');
    }
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Could not launch $url || $e');
    }
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static String convertPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'([() +-]+)'), '');
  }
}

void debugPrint(String v) {
  if (kDebugMode) {
    print(v);
  }
}
