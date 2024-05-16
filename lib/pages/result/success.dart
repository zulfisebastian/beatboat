import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/text/ctext.dart';

class SuccessPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onFinish;
  final Widget? otherWidget;

  SuccessPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onFinish,
    this.otherWidget,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onFinish();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: _theme.backgroundSuccess.value,
        body: Container(
          width: OtherExt().getWidth(context),
          height: OtherExt().getHeight(context),
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: CDimension.space48,
              ),
              CText(
                title,
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CText(
                subtitle,
                color: Colors.white,
                overflow: TextOverflow.visible,
                align: TextAlign.center,
                lineHeight: 1.4,
                fontSize: 14,
              ),
              SizedBox(
                height: CDimension.space20,
              ),
              Lottie.asset(
                'assets/json/success.json',
                width: 240,
                repeat: false,
              ),
              SizedBox(
                height: CDimension.space40,
              ),
              CustomButtonWhite(
                action,
                width: OtherExt().getWidth(context),
                onPressed: () {
                  onFinish();
                },
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              otherWidget ?? SizedBox(),
              SizedBox(
                height: CDimension.space16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
