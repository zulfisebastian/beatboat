import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/theme/theme_controller.dart';

class CHtml extends StatelessWidget {
  final dynamic title;
  final double fontSize;
  final FontWeight fontWeight;
  final int? maxline;
  final double lineHeight;
  final TextOverflow overflow;

  CHtml(
    this.title, {
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.maxline = 0,
    this.lineHeight = 1.5,
    this.overflow = TextOverflow.visible,
  });

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return Html(
      data: title.toString(),
      shrinkWrap: true,
      style: {
        "body": Style(
          maxLines: maxline,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(fontSize),
          fontFamily: GoogleFonts.inter().fontFamily,
          fontWeight: fontWeight,
          lineHeight: LineHeight(lineHeight),
          color: _theme.textTitle.value,
        ),
        "p": Style(
          maxLines: maxline,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(fontSize),
          fontFamily: GoogleFonts.inter().fontFamily,
          lineHeight: LineHeight(lineHeight),
          fontWeight: fontWeight,
          textOverflow: overflow,
          color: _theme.textTitle.value,
        ),
        "span": Style(
          maxLines: maxline,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(fontSize),
          fontFamily: GoogleFonts.inter().fontFamily,
          lineHeight: LineHeight(lineHeight),
          fontWeight: fontWeight,
          textOverflow: overflow,
          color: _theme.textTitle.value,
        ),
        "ol": Style(
          margin: Margins.only(left: 8),
          padding: HtmlPaddings.only(left: 8),
          textOverflow: overflow,
          fontWeight: fontWeight,
          color: _theme.textTitle.value,
        ),
        "ul": Style(
          margin: Margins.only(left: 8),
          padding: HtmlPaddings.only(left: 8),
          fontWeight: fontWeight,
          textOverflow: overflow,
          color: _theme.textTitle.value,
        ),
        "li": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontWeight: fontWeight,
          textOverflow: overflow,
          color: _theme.textTitle.value,
        ),
      },
    );
  }
}
