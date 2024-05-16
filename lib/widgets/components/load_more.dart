import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme/theme_controller.dart';

class LoadMore extends StatelessWidget {
  LoadMore({Key? key}) : super(key: key);

  final ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        color: _theme.accent.value,
      ),
    );
  }
}
