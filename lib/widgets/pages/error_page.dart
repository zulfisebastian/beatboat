import 'dart:io';
import 'package:beatboat/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/text/ctext.dart';
import '../components/customButton.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  ErrorPage({
    Key? key,
    required this.error,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 90,
                width: 90,
              ),
              SizedBox(
                height: 20,
              ),
              CText(
                "Oops!! Look Like Something Went Wrong !",
                fontSize: 20,
                color: _theme.textTitle.value,
                overflow: TextOverflow.visible,
                align: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              CText(
                "Please try again later",
                fontSize: 14,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: 64,
              ),
              CustomButtonUntheme(
                "Close",
                onPressed: () => exit(0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
