import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';

class CCopy extends StatelessWidget {
  final VoidCallback onCopy;

  CCopy({
    Key? key,
    required this.onCopy,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCopy();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Icon(
          Icons.copy,
          color: _theme.textSubtitle.value,
          size: 20,
        ),
      ),
    );
  }
}
