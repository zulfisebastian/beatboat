import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:beatboat/models/balance/balance_model.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/pages/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';
import '../../models/voucher/voucher_model.dart';
import '../../repositories/balance/topup_repo.dart';
import '../../widgets/sheets/sheet_failed.dart';

class TopUpController extends GetxController {
  Rx<TextEditingController> amount = TextEditingController().obs;

  RxList<int> amountList = <int>[].obs;
  final TopUpRepo _topUpRepo = Get.put(TopUpRepo());

  @override
  void onReady() {
    super.onReady();
    initAmount();
  }

  initAmount() {
    amountList.addAll(
      [
        100000,
        200000,
        500000,
        1000000,
      ],
    );
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

  topUpBalance(
      BalanceData _balance, String type, VoidCallback _onFinish) async {
    String udid = Get.find(tag: "udid");

    String fileName = _photo.value.path.split('/').last;

    Get.dialog(Loading());
    var body = (type == "EDC")
        ? FormData.fromMap({
            "voucher_code": voucherData.value.voucher_code != null
                ? voucherData.value.voucher_code
                : null,
            "device_serial_number": udid,
            "nfc_uid": _balance.nfc_uid,
            "method": type,
            "nominal": amount.value.text.replaceAll(".", ""),
            "currency": "IDR",
            "photo": await MultipartFile.fromFile(
              _photo.value.path,
              filename: fileName,
              contentType: MediaType('image', 'png'),
            ),
          })
        : FormData.fromMap({
            "voucher_code": voucherData.value.voucher_code != null
                ? voucherData.value.voucher_code
                : null,
            "device_serial_number": udid,
            "nfc_uid": _balance.nfc_uid,
            "method": type,
            "nominal": amount.value.text.replaceAll(".", ""),
            "currency": "IDR",
          });

    var _resp = await _topUpRepo.topupBalance(body);
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

  Rx<TextEditingController> voucher = TextEditingController().obs;

  Rx<VoucherData> voucherData = VoucherData().obs;
  checkVoucher() async {
    Get.dialog(Loading());
    var body = {
      "voucher_code": voucher.value.text.toUpperCase(),
      "usage": "topup",
    };

    var _resp = await _topUpRepo.checkVoucher(body);
    Get.back();

    if (_resp.data != null) {
      Get.back();
      voucherData.value = _resp.data!;
      voucherData.refresh();
    } else {
      Get.back();
      Get.bottomSheet(
        SheetFailed(errorMessage: _resp.message!),
      );
    }
  }

  removeVoucher() {
    voucherData.value = VoucherData();
    voucherData.refresh();
    voucher.value.text = "";
  }

  calculateTotalTopup() {
    int _amount = int.parse(
        amount.value.text == "" ? "0" : amount.value.text.replaceAll(".", ""));
    if (voucherData.value.voucher_code != null) {
      if (voucherData.value.type!.toLowerCase() == "percentage") {
        int _disc = _amount * voucherData.value.nominal! ~/ 100;
        if (_disc > voucherData.value.max_discount!) {
          _disc = voucherData.value.max_discount!;
          return _amount + _disc;
        }
        return _amount + _disc;
      } else {
        return _amount + voucherData.value.nominal!;
      }
    } else {
      return _amount;
    }
  }
}
