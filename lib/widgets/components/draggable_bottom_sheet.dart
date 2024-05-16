import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme/theme_controller.dart';

class DraggableBottomSheet extends StatelessWidget {
  DraggableBottomSheet({Key? key}) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 5.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: _theme.accent.value,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
