import 'package:flutter/material.dart';

class CTextHeading extends StatelessWidget {
  final dynamic title;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextOverflow overflow;
  final TextAlign? align;
  final bool isItalic;
  final TextDecoration? decoration;
  final int? maxLines;
  final double thickness;
  final Color color;
  final double lineHeight;
  final double spacing;

  CTextHeading(
    this.title, {
    this.fontSize = 20,
    this.fontWeight,
    this.overflow = TextOverflow.ellipsis,
    this.decoration,
    this.maxLines,
    this.align,
    this.isItalic = false,
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
        fontWeight: FontWeight.bold,
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
