import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/components/customInputForm.dart';
import 'package:beatboat/widgets/components/customInputPass.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/theme/theme_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');

  final String _version = Get.find(tag: "appVersion");

  final AuthController _authController =
      Get.put(AuthController(), tag: 'AuthController');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _theme.backgroundAppOther.value,
        body: Container(
          width: OtherExt().getWidth(context),
          height: OtherExt().getHeight(context),
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space16,
            vertical: CDimension.space24,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: CDimension.space72,
                ),
                SvgPicture.asset(
                  "assets/icons/logo.svg",
                  width: 200,
                ),
                SizedBox(
                  height: CDimension.space64,
                ),
                Container(
                  padding: EdgeInsets.all(CDimension.space24),
                  decoration: BoxDecoration(
                    color: _theme.backgroundApp.value,
                    borderRadius: BorderRadius.circular(CDimension.space16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CText(
                        "Username",
                        color: _theme.textTitle.value,
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: CDimension.space16,
                      ),
                      CustomInputForm(
                        textEditingController: _authController.username.value,
                        hintText: "Input Your Username",
                        errorMessage: "Username false",
                        onChanged: (v) {
                          _authController.checkForm();
                        },
                      ),
                      SizedBox(
                        height: CDimension.space24,
                      ),
                      CText(
                        "Password",
                        color: _theme.textTitle.value,
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: CDimension.space16,
                      ),
                      CustomInputPass(
                        controller: _authController.password.value,
                        hintText: "Input Your Password",
                        errorMessage: "Password false",
                        keyboardType: TextInputType.text,
                        onChanged: (v) {
                          _authController.checkForm();
                        },
                      ),
                      SizedBox(
                        height: CDimension.space24,
                      ),
                      CustomButtonBlue(
                        "Login",
                        width: OtherExt().getWidth(context),
                        onPressed: () {
                          _authController.loginRequest();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: CDimension.space24,
                ),
                CText(
                  "Version $_version",
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
