import 'package:beatboat/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import 'text/ctext.dart';

class CAlertConnection extends StatefulWidget {
  const CAlertConnection({key});
  @override
  State<CAlertConnection> createState() => _CAlertConnectionState();
}

class _CAlertConnectionState extends State<CAlertConnection> {
  final BaseController _base = Get.find(tag: "BaseController");
  final ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _base.isConnected.value
          ? SizedBox()
          : Container(
              margin: EdgeInsets.only(
                top: CDimension.space24,
                bottom: CDimension.space16,
                left: CDimension.space16,
                right: CDimension.space16,
              ),
              padding: EdgeInsets.symmetric(
                vertical: CDimension.space12,
                horizontal: CDimension.space16,
              ),
              decoration: BoxDecoration(
                color: _theme.error.value,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_warning.svg",
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: CDimension.space12,
                  ),
                  Column(
                    children: [
                      CText(
                        "Now you use the app in offline mode.",
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
