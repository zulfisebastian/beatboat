import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';

class CDivider extends StatelessWidget {
  final double height;

  CDivider({
    Key? key,
    required this.height,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OtherExt().getWidth(context),
      height: height,
      color: _theme.line.value,
    );
  }
}
