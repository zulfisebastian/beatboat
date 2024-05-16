import 'package:flutter/material.dart';

class CTextButton extends StatelessWidget {
  final dynamic title;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextOverflow overflow;
  final TextAlign? align;
  final bool money;
  final bool number;
  final bool isItalic;
  final bool isHeadline;
  final TextDecoration? decoration;
  final int? maxLines;
  final double thickness;
  final Color color;
  final double lineHeight;
  final double spacing;

  CTextButton(
    this.title, {
    this.fontSize = 15,
    this.fontWeight,
    this.overflow = TextOverflow.ellipsis,
    this.money = false,
    this.number = false,
    this.decoration,
    this.maxLines,
    this.align,
    this.isItalic = false,
    this.isHeadline = false,
    required this.color,
    this.lineHeight = 0,
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
        fontWeight: fontWeight,
        decoration: decoration,
        decorationThickness: thickness,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        letterSpacing: spacing,
        // fontFamily: "Gotham",
      ),
      overflow: overflow,
      textAlign: align,
      maxLines: maxLines,
    );
  }
}
