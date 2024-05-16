import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../components/text/ctext.dart';

class NoBalanceCard extends StatelessWidget {
  final VoidCallback onClick;
  final String label;

  NoBalanceCard({
    Key? key,
    required this.onClick,
    required this.label,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: OtherExt().getWidth(context),
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: _theme.line.value,
          ),
          borderRadius: BorderRadius.circular(
            CDimension.space16,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: CDimension.space24,
          vertical: CDimension.space16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: CDimension.space32,
            ),
            SizedBox(
              height: CDimension.space16,
            ),
            CText(
              label,
              color: _theme.textSubtitle.value,
            ),
          ],
        ),
      ),
    );
  }
}
