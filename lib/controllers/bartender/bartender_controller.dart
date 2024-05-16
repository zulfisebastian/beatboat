import 'package:beatboat/models/bartender/bartender_model.dart';
import 'package:beatboat/widgets/components/ctoast.dart';
import 'package:beatboat/widgets/pages/loading.dart';
import 'package:beatboat/widgets/sheets/sheet_failed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repositories/bartender/bartender_repo.dart';

class BartenderController extends GetxController {
  final BartenderRepo _bartenderRepo = Get.put(BartenderRepo());

  RxInt choosedTab = 0.obs;
  changeTab(_tab) {
    choosedTab.value = _tab;
    choosedTab.refresh();
  }

  @override
  void onReady() {
    super.onReady();
    getAllData();
  }

  getAllData() async {
    getDataBartender();
    getDataBartenderDone();
  }

  RxList<BartenderData> listBartender = <BartenderData>[].obs;
  RxList<BartenderData> listBartenderDone = <BartenderData>[].obs;
  getDataBartender() async {
    Get.dialog(Loading());
    var body = {
      "status": "active",
    };

    var _resp = await _bartenderRepo.getFoodOrder(body);
    Get.back();

    if (_resp.data!.length > 0) {
      listBartender.value = _resp.data!;
      listBartender.refresh();
    }
  }

  getDataBartenderDone() async {
    Get.dialog(Loading());
    var body = {
      "status": "done",
    };

    var _resp = await _bartenderRepo.getFoodOrder(body);
    Get.back();

    if (_resp.data!.length > 0) {
      listBartenderDone.value = _resp.data!;
      listBartenderDone.refresh();
    }
  }

  updateProductDone(String _id) async {
    Get.dialog(Loading());
    var body = {
      "status": "done",
    };

    var _resp = await _bartenderRepo.putMarkDone(body, _id);
    Get.back();

    if (_resp.code != null) {
      CToast.showWithoutCOntext(
        "Success Mark As Done",
        Colors.black87,
        Colors.white,
      );
      getAllData();
    } else {
      Get.bottomSheet(
        SheetFailed(errorMessage: _resp.message!),
      );
    }
  }
}
