import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetDeviceRegistered extends StatelessWidget {
  SheetDeviceRegistered({
    Key? key,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: _theme.backgroundApp.value,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DraggableBottomSheet(),
              Lottie.asset(
                'assets/json/device_registered.json',
                width: 240,
              ),
              SizedBox(
                height: CDimension.space4,
              ),
              CText(
                "This device successfully registered",
                fontSize: 16,
                lineHeight: 1.5,
                align: TextAlign.center,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              CustomButtonBorderWhite(
                "Done!",
                width: OtherExt().getWidth(context),
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(
                height: CDimension.space24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
