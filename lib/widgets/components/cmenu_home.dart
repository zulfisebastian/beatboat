import 'package:beatboat/constants/size.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import 'text/ctext.dart';

class CMenuHome extends StatelessWidget {
  final VoidCallback onClick;
  final String icon;
  final String title;
  final String subtitle;

  CMenuHome({
    Key? key,
    required this.onClick,
    required this.icon,
    required this.title,
    required this.subtitle,
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
        width: (OtherExt().getWidth(context) - (CDimension.space24 * 2)) / 2,
        padding: EdgeInsets.symmetric(
          vertical: CDimension.space8,
          horizontal: CDimension.space16,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: _theme.line.value,
          ),
          borderRadius: BorderRadius.circular(
            CDimension.space16,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _theme.backgroundCard.value,
                borderRadius: BorderRadius.circular(
                  50,
                ),
              ),
              padding: EdgeInsets.all(
                CDimension.space12,
              ),
              child: SvgPicture.asset(
                "assets/icons/ic_menu_$icon.svg",
                width: CDimension.space20,
              ),
            ),
            SizedBox(
              width: CDimension.space8,
            ),
            CText(
              title.capitalizeFirst,
              color: _theme.accent.value,
              fontSize: CFontSize.font14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
