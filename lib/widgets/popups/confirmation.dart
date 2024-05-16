import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/size.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/customButton.dart';
import '../components/text/ctext.dart';

class Confirmation extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onOk;

  Confirmation({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onOk,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _theme.backgroundApp.value,
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CText(
                title,
                fontSize: CFontSize.font14,
                color: _theme.textSubtitle.value,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CText(
                subtitle,
                fontSize: CFontSize.font18,
                overflow: TextOverflow.visible,
                lineHeight: 1.5,
                color: _theme.textTitle.value,
                align: TextAlign.center,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButtonBorderBlack(
                      "Cancel",
                      width: OtherExt().getWidth(context),
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                  ),
                  SizedBox(
                    width: CDimension.space16,
                  ),
                  Expanded(
                    child: CustomButtonBlue(
                      "Continue",
                      width: OtherExt().getWidth(context),
                      onPressed: () async {
                        onOk();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
