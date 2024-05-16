import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';

class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  ThemeController _theme = Get.find(tag: "ThemeController");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: _theme.backgroundApp.value,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: _theme.textTitle.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
