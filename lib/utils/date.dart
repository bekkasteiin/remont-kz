import 'package:intl/intl.dart';

String formatDate(DateTime dateTime, {String? locale}) {
  return DateFormat.yMd(locale).format(dateTime);
}

DateTime dateFromString(String source, {String? locale}) {
  return DateFormat.yMd(locale).parse(source);
}

String formatDateHumanReadable(DateTime dateTime, {String? locale}) {
  return DateFormat.yMMMMd(locale).format(dateTime);
}

String formatOrderDate(DateTime? dateTime, {String? locale}) {
  return dateTime == null ? '' : DateFormat('dd MMMM, E', locale).format(dateTime);
}

String formatDayOfWeekHumanReadable(DateTime dateTime, {String? locale}) {
  return DateFormat.E(locale).format(dateTime);
}

String formatDateTimeHumanReadable(DateTime dateTime, {String? locale, bool dayOfWeek = false}) {
  final List<String> items = [formatDateHumanReadable(dateTime, locale: locale)];
  if (dayOfWeek) {
    items.add(formatDayOfWeekHumanReadable(dateTime, locale: locale));
  }
  items.add(formatTimeHoursAndMinutes(dateTime, locale: locale));
  return items.join(', ');
}

String formatTime(DateTime dateTime, {String? locale}) {
  return DateFormat.Hms(locale).format(dateTime);
}

String formatTimeHoursAndMinutes(DateTime dateTime, {String? locale}) {
  return DateFormat.Hm(locale).format(dateTime);
}

String formatDateIso8601(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

DateTime dateFromIso8601(String source) {
  return DateFormat('yyyy-MM-dd').parse(source);
}

bool equalDates(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

String age(String date) {
  final birthDate = DateTime.parse(date);
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age.toString();
}
