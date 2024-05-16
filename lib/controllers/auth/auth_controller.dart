import 'package:beatboat/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repositories/auth/auth_repo.dart';
import '../../utils/shared_pref.dart';
import '../base/base_controller.dart';

class AuthController extends GetxController {
  Rx<TextEditingController> username = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;

  final BaseController _base = Get.find(tag: "BaseController");

  final AuthRepo _repoAuth = Get.put(AuthRepo());

  RxBool isError = false.obs;
  RxString errorMessage = "".obs;

  RxBool isDisabled = true.obs;
  checkForm() {
    isDisabled.value = username.value.text == "" || password.value.text == "";
  }

  loginRequest() async {
    var body = {
      "username": username.value.text,
      "password": password.value.text,
    };

    var _resp = await _repoAuth.postLogin(body);

    if (_resp.data != null) {
      await SharedPref.setAccessToken(_resp.data!.token!);
      _base.changeIsLogedIn();
      _base.getProfile();
      Get.offAll(HomePage());
    } else {
      isError.value = true;
      Future.delayed(Duration(seconds: 5), () {
        isError.value = false;
      });
      errorMessage.value = _resp.message!;
    }
  }
}
