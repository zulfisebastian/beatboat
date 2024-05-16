import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OtherExt {
  getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

class StringExt {
  static String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }

  static String formatRupiah(number) {
    var _formattedNumber = NumberFormat("#,##0", "id_ID").format(number);
    return "IDR $_formattedNumber";
  }

  static String hideMiddleCode(String code) {
    try {
      return "${code.substring(0, 3)}****${code.substring(7)}";
    } catch (er) {
      return "";
    }
  }

  static String thousandFormatter(number) {
    var _formattedNumber = NumberFormat("#,##0", "id_ID").format(number);
    return "$_formattedNumber";
  }

  static String getInitialTwoName(String name) {
    var _splitText = name.split(" ");
    if (_splitText.length > 1) {
      return "${_splitText[0].substring(0, 1)}${_splitText[1].substring(0, 1)}";
    } else {
      return name.substring(0, 2).toUpperCase();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class DateExt {
  static String reformat(
    String date,
    String realFormat,
    String expectedFormat,
  ) {
    var _result = DateFormat(expectedFormat, "EN").format(
      DateFormat(realFormat).parse(date),
    );
    return _result;
  }

  static String reformatToLocal(
    String date,
    String realFormat,
    String expectedFormat,
  ) {
    var dateValue = new DateFormat(realFormat).parseUTC(date).toLocal();
    String _result = DateFormat(expectedFormat).format(dateValue);
    return _result;
  }

  static calculateDiffDate(String date) {
    DateTime a = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);
    // a = a.add(Duration(hours: 7));

    final birthday = DateFormat("yyyy-MM-dd HH:mm:ss").parse(a.toString());
    final today = DateTime.now();

    Duration difference = today.difference(birthday);

    int week = difference.inDays > 7 ? difference.inDays ~/ 7 : 0;
    int month = (difference.inDays % 365) ~/ 30;
    int year = difference.inDays ~/ 365;
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;
    if (year > 0) {
      return "${year} tahun lalu";
    }
    if (month > 0) {
      return "${month} bulan lalu";
    }
    if (week > 0) {
      return "${week} minggu lalu";
    }
    if (days > 0) {
      return "${days} hari lalu";
    }
    if (hours > 1) {
      return "${hours} jam lalu";
    }
    if (minutes > 1) {
      return "${minutes} menit lalu";
    }
    if (seconds > 0) {
      return "${seconds} detik lalu";
    }
    return "beberapa detik lalu";
  }

  static calculateAge(String _tgl) {
    var age = "";
    DateTime today = DateTime.now();
    DateTime tgl = DateTime.parse(_tgl);
    final year = today.year - tgl.year;
    final mth = today.month - tgl.month;
    if (mth < 0) {
      age = "0";
    } else {
      age = year.toString();
    }
    return age;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension RGBAColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromRGBA(String string) {
    var _list = string.replaceAll("rgba(", "").replaceAll(")", "").trim();
    var _listColor = _list.split(",");
    return Color.fromARGB(
      int.parse(_listColor[3].replaceAll(".", "").toString()),
      int.parse(_listColor[0].toString()),
      int.parse(_listColor[1].toString()),
      int.parse(_listColor[2].toString()),
    );
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
