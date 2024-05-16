import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'extensions.dart';

LinearGradient getLinearGradient(String type) {
  if (type == "general") {
    return LinearGradient(
      colors: [
        HexColor.fromHex("#2193b0"),
        HexColor.fromHex("#6dd5ed"),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.4,
        0.9,
      ],
    );
  } else if (type == "vip") {
    return LinearGradient(
      colors: [
        HexColor.fromHex("#2b5876"),
        HexColor.fromHex("#4e4376"),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.4,
        0.9,
      ],
    );
  } else if (type == "v_vip") {
    return LinearGradient(
      colors: [
        HexColor.fromHex("#141e30"),
        HexColor.fromHex("#243b55"),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.4,
        0.9,
      ],
    );
  } else {
    return LinearGradient(
      colors: [
        HexColor.fromHex("#2193b0"),
        HexColor.fromHex("#6dd5ed"),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.4,
        0.9,
      ],
    );
  }
}

launchURL(_url) async {
  final Uri url = Uri.parse(_url);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $_url');
  }
}

List<String> parseStringToList(String text) {
  var _data = json.decode(text).cast<String>().toList();
  return _data;
}

Alignment getGradientRotate(num degree) {
  degree -= 90;
  final x = cos(degree * pi / 180);
  final y = sin(degree * pi / 180);
  final xAbs = x.abs();
  final yAbs = y.abs();

  if ((0.0 < xAbs && xAbs < 1.0) || (0.0 < yAbs && yAbs < 1.0)) {
    final magnification = (1 / xAbs) < (1 / yAbs) ? (1 / xAbs) : (1 / yAbs);
    return Alignment(x, y) * magnification;
  } else {
    return Alignment(x, y);
  }
}

openMap(address) async {
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$address';
  if (await canLaunchUrl(Uri.parse(googleUrl))) {
    await launchUrl(Uri.parse(googleUrl));
  } else {
    throw 'Could not open the map.';
  }
}

String getExtensionFromFile(String file) {
  return file.split("/").last.split(".").last;
}

String getGreetingByHour() {
  var _hour = DateTime.now();

  if (_hour.hour >= 4 && _hour.hour < 12) {
    return "Good Morning";
  } else if (_hour.hour >= 12 && _hour.hour <= 18) {
    return "Good Afternoon";
  } else if (_hour.hour > 18 && _hour.hour < 4) {
    return "Good Evening";
  } else if (_hour.hour == 0) {
    return "Good Evening";
  } else {
    return "Good Morning";
  }
}

String getDateAutoName(String _startDate, String _endDate) {
  if (_startDate.substring(5, 7) == _endDate.substring(5, 7)) {
    if (_startDate.substring(8, 10) == _endDate.substring(8, 10)) {
      return "${DateExt.reformat(_startDate, "yyyy-MM-dd", "d MMM yyyy")}";
    } else {
      return "${DateExt.reformat(_startDate, "yyyy-MM-dd", "d")} - ${DateExt.reformat(_endDate, "yyyy-MM-dd", "d MMM yyyy")}";
    }
  } else {
    return "${DateExt.reformat(_startDate, "yyyy-MM-dd", "d MMM")} - ${DateExt.reformat(_endDate, "yyyy-MM-dd", "d MMM yyyy")}";
  }
}

openDialog(context, child) {
  FocusScope.of(context).unfocus();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxWidth: OtherExt().getWidth(context),
    ),
    builder: (context) {
      return child;
    },
  );
}
