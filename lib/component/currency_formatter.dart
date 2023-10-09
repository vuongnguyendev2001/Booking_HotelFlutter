import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// MARK: - Initials;
  static String convertPrice({required num price}) {
    return NumberFormat.currency(locale: 'vi').format(price);
  }

  static String numFormat({required num number}) {
    return NumberFormat(null, 'vi').format(number);
  }

  static String formattedDate(timeStamp) {
    var dateFormTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFormTimeStamp);
  }

  static String formattedDatebook(timeStamp) {
    var dateFormTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateFormTimeStamp);
  }
}
