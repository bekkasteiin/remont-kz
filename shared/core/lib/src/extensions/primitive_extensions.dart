import 'package:dependencies/dependencies.dart';

final _phoneRegExp = RegExp(r'\+(\d{1,11})');

extension StringExtension on String {
  Uri get toUri => Uri.parse(this);

  String get formattedPhone {
    var source = this;
    if (!source.startsWith('+')) {
      source = '+$source';
    }
    final match = _phoneRegExp.firstMatch(source);
    if (match == null) {
      return this;
    }
    final digits = match[0]!.split('');
    var formatted = '';
    for (var i = 0; i < digits.length; i++) {
      if (i == 2) {
        formatted += ' (';
      } else if (i == 5) {
        formatted += ') ';
      } else if (i == 8 || i == 10) {
        formatted += '-';
      }
      formatted += digits[i];
    }
    return formatted;
  }
}

extension IntExtension on int {
  String get formattedCurrency => '${NumberFormat.simpleCurrency(locale: 'ru').format(this).split(',').first} ₸';
}
