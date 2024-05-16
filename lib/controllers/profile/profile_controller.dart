import 'package:beatboat/models/auth/profile_model.dart';
import 'package:beatboat/services/databases/profile/profile_table.dart';
import 'package:beatboat/widgets/components/ctoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repositories/auth/profile_repo.dart';
import '../../widgets/pages/loading.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../base/base_controller.dart';

class ProfileController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");

  final ProfileRepo _profileRepo = Get.put(ProfileRepo());

  @override
  void onReady() {
    super.onReady();
    _base.initConnectivity();
    getProfileData();
  }

  Rx<ProfileData> dataProfile = ProfileData().obs;

  RxBool kitchenPrinter = false.obs;

  getProfileData() async {
    if (_base.isConnected.value) {
      var _resp = await _profileRepo.getProfile();

      if (_resp.data != null) {
        dataProfile.value = _resp.data!;
        dataProfile.refresh();

        _base.isDeviceKitchen.value = dataProfile.value.is_listen_printer ?? 0;
        _base.isDeviceKitchen.refresh();
        kitchenPrinter.value = _base.isDeviceKitchen.value == 1;
      }
    } else {
      var _resp = await ProfileTable().getProfile();

      if (_resp != null) {
        dataProfile.value = _resp;
        dataProfile.refresh();
      }
    }
  }

  changeKitchenPrinter() {
    kitchenPrinter.value = !kitchenPrinter.value;
    kitchenPrinter.refresh();

    _base.isDeviceKitchen.value = kitchenPrinter.value ? 1 : 0;
    _base.isDeviceKitchen.refresh();

    makeAsListenPrinter();
  }

  makeAsListenPrinter() async {
    Get.dialog(
      Loading(),
    );
    String udid = Get.find(tag: "udid");

    var body = {
      "device_serial_number": udid,
      "is_listen_printer": kitchenPrinter.value ? 1 : 0,
    };
    var _resp = await _profileRepo.editProfile(body);
    Get.back();

    if (_resp.code != null) {
      CToast.showWithoutCOntext(
        kitchenPrinter.value
            ? "Now this device is a kitchen printer"
            : "Now this device is not a kitchen printer",
        Colors.black87,
        Colors.white,
      );
    } else {
      Get.bottomSheet(
        SheetFailed(
          errorMessage: _resp.message!,
        ),
      );
    }
  }
}
