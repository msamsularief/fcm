import 'package:intl/intl.dart';

const String _localization = 'id_ID';

extension IntUtils on int {
  /// Digunakan untuk memformat tanggal dari `millisecondsSinceEpoch()`
  /// menjadi String berformat `'yyyy-MM-d-HHmmssS'`
  ///
  /// Example :
  /// ``` dart
  /// int myTimeStamp = DateTime.now().millisecondsSinceEpoch;
  /// String newTs = myTimeStamp.toString();
  /// print(newTs); //return 1667944890563
  ///
  /// String fileNamed = newTs.fileNameFormat();
  /// print(fileNamed); //return 2022-11-9-050130563
  /// ```
  /// Read this page for more informations : https://api.flutter.dev/flutter/intl/DateFormat-class.html#constructors
  ///
  String fileNameFormatter([String? locale = _localization]) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    final DateFormat formatter = DateFormat('yyyy-M-d-HHmmssS', locale);
    return formatter.format(dateTime);
  }
}
