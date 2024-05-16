import 'package:flutter/material.dart';

class CTextDisplay extends StatelessWidget {
  final dynamic title;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextOverflow overflow;
  final TextAlign? align;
  final bool money;
  final bool number;
  final bool isItalic;
  final bool isBold;
  final bool isHeadline;
  final TextDecoration? decoration;
  final int? maxLines;
  final double thickness;
  final Color color;
  final double lineHeight;
  final double spacing;

  CTextDisplay(
    this.title, {
    this.fontSize = 28,
    this.fontWeight,
    this.overflow = TextOverflow.ellipsis,
    this.money = false,
    this.number = false,
    this.decoration,
    this.maxLines,
    this.align,
    this.isBold = false,
    this.isItalic = false,
    this.isHeadline = false,
    required this.color,
    this.lineHeight = 1,
    this.thickness = 4,
    this.spacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toString(),
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : fontWeight,
        decoration: decoration,
        decorationThickness: thickness,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        height: lineHeight,
        letterSpacing: spacing,
        fontFamily: "Gotham",
      ),
      overflow: overflow,
      textAlign: align,
      maxLines: maxLines,
    );
  }
}
