import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/dimension.dart';
import 'text/ctext.dart';

class CMenu extends StatelessWidget {
  final VoidCallback onClick;
  final String icon;
  final String title;

  CMenu({
    Key? key,
    required this.onClick,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: CDimension.space12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/$icon.svg",
              width: CDimension.space16,
              color: Colors.white,
            ),
            SizedBox(
              width: CDimension.space12,
            ),
            CText(
              title,
              fontSize: CDimension.space16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
