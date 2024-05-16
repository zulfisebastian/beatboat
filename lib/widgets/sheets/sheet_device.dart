import 'dart:io';
import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/controllers/base/base_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/popups/confirmation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetDevice extends StatelessWidget {
  SheetDevice({
    Key? key,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');
  final String _udid = Get.find(tag: 'udid');

  getDeviceName() {
    if (Platform.isIOS) {
      final IosDeviceInfo deviceInfo = Get.find(tag: "deviceInfo");
      return deviceInfo.name;
    } else {
      final AndroidDeviceInfo deviceInfo = Get.find(tag: "deviceInfo");
      return deviceInfo.brand +
          " " +
          deviceInfo.device +
          " " +
          deviceInfo.model;
    }
  }

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
            children: <Widget>[
              DraggableBottomSheet(),
              SizedBox(
                height: CDimension.space24,
              ),
              CText(
                "Device Name",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    padding: EdgeInsets.all(
                      CDimension.space12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: _theme.line.value,
                      ),
                    ),
                    child: Image.asset(
                      "assets/images/ic_device_${Platform.isAndroid ? 'android' : Platform.isIOS ? 'apple' : 'other'}.png",
                      width: 80,
                    ),
                  ),
                  SizedBox(
                    width: CDimension.space16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          "Device Type",
                          fontSize: 14,
                          color: _theme.textSubtitle.value,
                        ),
                        SizedBox(
                          height: CDimension.space8,
                        ),
                        CText(
                          "This device is ${Platform.isAndroid ? 'Android' : Platform.isIOS ? 'IOs' : 'not a mobile device'}",
                          fontSize: 16,
                          color: _theme.textTitle.value,
                        ),
                        SizedBox(
                          height: CDimension.space24,
                        ),
                        CText(
                          "Device Name",
                          fontSize: 14,
                          color: _theme.textSubtitle.value,
                        ),
                        SizedBox(
                          height: CDimension.space8,
                        ),
                        CText(
                          getDeviceName(),
                          fontSize: 16,
                          color: _theme.textTitle.value,
                        ),
                        SizedBox(
                          height: CDimension.space24,
                        ),
                        CText(
                          "Device UDID",
                          fontSize: 14,
                          color: _theme.textSubtitle.value,
                        ),
                        SizedBox(
                          height: CDimension.space8,
                        ),
                        CText(
                          _udid,
                          fontSize: 16,
                          color: _theme.textTitle.value,
                        ),
                        SizedBox(
                          height: CDimension.space24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CustomButtonBlue(
                "Add This Device",
                width: OtherExt().getWidth(context),
                onPressed: () {
                  Get.dialog(
                    Confirmation(
                      title: "Warning!",
                      subtitle: "Do you want to register this device?",
                      onOk: () {
                        Get.back();
                        _base.registerDevice(
                          _udid,
                          getDeviceName(),
                        );
                      },
                    ),
                  );
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
