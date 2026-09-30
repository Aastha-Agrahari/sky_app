import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String temp(double value) => '${value.round()}°';
  static String hour(DateTime time) => DateFormat('h a').format(time);
  static String weekday(DateTime time) => DateFormat('EEE').format(time);
  static String clock(DateTime time) => DateFormat('h:mm a').format(time);
}
