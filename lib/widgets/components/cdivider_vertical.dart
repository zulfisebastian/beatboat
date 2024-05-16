import 'package:flutter/material.dart';

class CDividerVertical extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final EdgeInsets margin;

  const CDividerVertical({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    this.margin = const EdgeInsets.only(
      left: 11,
      top: 8,
      bottom: 8,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      color: color,
    );
  }
}
