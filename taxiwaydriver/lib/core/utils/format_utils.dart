import 'package:intl/intl.dart';

final _rupeeFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

String formatRupees(num amount) => _rupeeFormat.format(amount);

final _dateFormat = DateFormat('dd MMM');
final _timeFormat = DateFormat('hh:mm a');

String formatRideDate(DateTime dt) => _dateFormat.format(dt).toUpperCase();

String formatRideTime(DateTime dt) => _timeFormat.format(dt);
