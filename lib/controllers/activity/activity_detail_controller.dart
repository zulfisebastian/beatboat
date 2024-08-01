import 'dart:io';
import 'package:beatboat/repositories/activity/activity_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';
import '../../models/activity/activity_detail_model.dart';
import '../../models/balance/balance_model.dart';
import '../../repositories/balance/balance_repo.dart';
import '../../repositories/balance/topup_repo.dart';
import '../../utils/extensions.dart';
import '../../widgets/pages/loading.dart';
import '../../widgets/sheets/sheet_failed.dart';

class ActivityDetailController extends GetxController {
  final ActivityRepo _activityRepo = Get.put(ActivityRepo());
  final TopUpRepo _topUpRepo = Get.put(TopUpRepo());
  final BalanceRepo _repoBalance = Get.put(BalanceRepo());

  @override
  void onReady() {
    super.onReady();
    initAmount();
  }

  Rx<TextEditingController> amount = TextEditingController().obs;

  RxList<int> amountList = <int>[].obs;

  initAmount() async {
    var _resp = await _topUpRepo.getListAmount();

    if (_resp.data != null) {
      amountList.value = _resp.data!;
    } else {
      amountList.value = [
        500000,
        1000000,
        1500000,
        2000000,
      ];
    }
    amountList.refresh();
  }

  changeAmount(_amount) {
    amount.value.text = StringExt.thousandFormatter(_amount);
    amount.refresh();
  }

  Rx<File> _photo = File("").obs;
  Rx<File> get photo => _photo;

  Future getCamera(context, VoidCallback onFinish) async {
    if (Platform.isAndroid) {
      var permission = await Permission.camera.status;

      if (permission != PermissionStatus.granted) {
        await Permission.camera.request();
        permission = await Permission.camera.status;
        getCamera(context, onFinish);
      } else {
        var _image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 25,
        );
        _photo.value = File(_image!.path);
        _photo.refresh();
        onFinish();
      }
    } else {
      var _image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
      _photo.value = File(_image!.path);
      _photo.refresh();
      onFinish();
    }
  }

  Rx<ActivityDetailData> dataActivity = ActivityDetailData().obs;
  getDataActivity(id) async {
    var _resp = await _activityRepo.getDetailActivity(id);

    if (_resp.data != null) {
      dataActivity.value = _resp.data!;
      dataActivity.refresh();

      checkBalance(dataActivity.value.nfc_uid!);
      changeAmount(dataActivity.value.amount!);
    }
  }

  Rx<BalanceData> balance = BalanceData().obs;
  checkBalance(String nfcUid) async {
    String udid = Get.find(tag: "udid");

    var body = {
      "device_serial_number": udid,
      "nfc_uid": nfcUid,
    };

    var _resp = await _repoBalance.checkBalance(body);

    if (_resp.data != null) {
      balance.value = _resp.data!;
      balance.refresh();
    } else {
      Get.bottomSheet(
        SheetFailed(
          errorMessage: _resp.message!,
        ),
        isScrollControlled: true,
      );
    }
  }

  topUpBalance(
      BalanceData _balance, String type, VoidCallback _onFinish) async {
    String fileName = _photo.value.path.split('/').last;

    Get.dialog(Loading());
    var body = (type == "EDC")
        ? FormData.fromMap({
            "id": dataActivity.value.number,
            "method": dataActivity.value.method,
            "nominal": amount.value.text.replaceAll(".", ""),
            "photo": await MultipartFile.fromFile(
              _photo.value.path,
              filename: fileName,
              contentType: MediaType('image', 'png'),
            ),
          })
        : FormData.fromMap({
            "id": dataActivity.value.number,
            "method": dataActivity.value.method,
            "nominal": amount.value.text.replaceAll(".", ""),
          });

    var _resp = await _activityRepo.topupBalance(body);
    Get.back();

    if (_resp.data != null) {
      _onFinish();
    } else {
      Get.back();
      Get.bottomSheet(
        SheetFailed(
            errorMessage: "TopUp balance failed, please contact our admin"),
      );
    }
  }

  calculateTotalTopup() {
    int _amount = int.parse(
        amount.value.text == "" ? "0" : amount.value.text.replaceAll(".", ""));

    return _amount;
  }
}
