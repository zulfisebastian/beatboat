import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/customButton.dart';
import '../components/text/ctext.dart';

class UpdateBalance extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onFinish;

  UpdateBalance({
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
        onFinish();
        return Future.value(true);
      },
      child: Dialog(
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
                Lottie.asset(
                  'assets/json/balance_update.json',
                  width: 240,
                  repeat: false,
                ),
                SizedBox(
                  height: 24,
                ),
                CText(
                  subtitle,
                  fontSize: 16,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: 16,
                ),
                CustomButtonBorderBlack(
                  "Good!",
                  width: OtherExt().getWidth(context),
                  onPressed: () async {
                    onFinish();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
