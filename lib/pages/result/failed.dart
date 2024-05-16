import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/text/ctext.dart';

class FailedPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onFinish;

  FailedPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onFinish,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // _transactionCtrl.finishTransaction();
        onFinish();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: _theme.error.value,
        body: Container(
          width: OtherExt().getWidth(context),
          height: OtherExt().getHeight(context),
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: CDimension.space128,
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
                'assets/json/failed.json',
                width: 300,
              ),
              //Todo remove below code after scan code done
              SizedBox(
                height: CDimension.space40,
              ),
              CustomButtonWhite(
                "Retry Transaction",
                width: OtherExt().getWidth(context),
                onPressed: () {
                  onFinish();
                },
              ),
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
