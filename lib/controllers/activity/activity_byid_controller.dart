import 'package:beatboat/models/activity/activity_model.dart';
import 'package:beatboat/models/balance/balance_model.dart';
import 'package:beatboat/repositories/activity/activity_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/result/success.dart';
import '../../repositories/balance/balance_repo.dart';
import '../../widgets/sheets/sheet_failed.dart';

class ActivityByIdController extends GetxController {
  final ActivityRepo _activityRepo = Get.put(ActivityRepo());
  final BalanceRepo _repoBalance = Get.put(BalanceRepo());

  final scrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
    scrollController.addListener(scrollControllerListener);
  }

  bool isLoading = false;
  RxBool isLoadMoreData = false.obs;
  RxInt page = 0.obs;
  RxInt totalPage = 1.obs;

  void scrollControllerListener() async {
    if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels &&
        !isLoading &&
        page.value < totalPage.value) {
      isLoading = true;
      isLoadMoreData.value = true;
      getDataActivity(true);
    }
  }

  Rx<BalanceData> balance = BalanceData().obs;

  RxList<ActivityData> listActivity = <ActivityData>[].obs;
  getDataActivity([bool isMore = false]) async {
    var body = {
      "per_page": 10,
      "page": page.value + 1,
      "nfc_uid": balance.value.nfc_uid,
    };

    var _resp = await _activityRepo.getActivity(body);

    if (_resp.data != null) {
      if (isMore) {
        listActivity.addAll(_resp.data!);
      } else {
        listActivity.value = _resp.data!;
      }
      page.value = _resp.paging!.current_page!;
      totalPage.value = _resp.paging!.last_page!;
      isLoadMoreData.value = false;
      isLoading = false;
      listActivity.refresh();
    }
  }

  checkBalance() async {
    String udid = Get.find(tag: "udid");

    var body = {
      "device_serial_number": udid,
      "nfc_uid": balance.value.nfc_uid,
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

  Rx<TextEditingController> amount = TextEditingController().obs;
  refundTransaction() async {
    String udid = Get.find(tag: "udid");

    var body = {
      "device_serial_number": udid,
      "refund_nominal": amount.value.text.replaceAll(".", ""),
    };

    var _resp = await _activityRepo.postRefundTopUp(
      balance.value.nfc_uid,
      body,
    );

    if (_resp.code != null) {
      checkBalance();
      page.value = 0;
      totalPage.value = 1;
      getDataActivity(false);
      Get.to(
        SuccessPage(
          title: "Your Refund Success",
          subtitle: "Thank you, and please wait until you get the email",
          action: "Done Refund!",
          onFinish: () {
            Get.back();
            Get.back();
          },
        ),
      );
    } else {
      Get.back();
      Get.bottomSheet(
        SheetFailed(
          errorMessage: _resp.message!,
        ),
      );
    }
  }
}
