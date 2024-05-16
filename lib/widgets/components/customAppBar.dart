import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import 'text/ctext.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String title;
  final Widget? action;
  final Widget? leading;

  CustomAppBar({
    required this.context,
    required this.title,
    this.action,
    this.leading,
  });

  final ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: AppBar().preferredSize,
      child: Material(
        elevation: 4,
        shadowColor: Colors.black26,
        child: Container(
          color: _theme.backgroundApp.value,
          child: AppBar(
            scrolledUnderElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            elevation: 0,
            backgroundColor: _theme.backgroundApp.value,
            centerTitle: false,
            actions: [
              action ?? Container(),
            ],
            titleSpacing: 0,
            title: CText(
              title,
              color: _theme.textTitle.value,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            leading: leading ??
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: _theme.textTitle.value,
                      size: 20,
                    ),
                  ),
                ),
            leadingWidth: 45,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
