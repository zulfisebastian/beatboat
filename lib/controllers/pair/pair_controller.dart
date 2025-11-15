import 'package:beatboat/models/checkin/checkin_model.dart';
import 'package:beatboat/repositories/global/global_repo.dart';
import 'package:beatboat/widgets/sheets/sheet_failed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/balance/balance_model.dart';
import '../../models/transaction/onboard_model.dart';
import '../../widgets/pages/loading.dart';

class PairController extends GetxController {
  final scrollController = ScrollController();

  final GlobalRepo _globalRepo = Get.put(GlobalRepo());

  RxBool isFlashOpen = false.obs;
  RxBool isCameraFront = false.obs;

  @override
  void onReady() {
    super.onReady();
    onRefresh();
  }

  onRefresh() {
    getNationality();
  }

  Rx<BalanceData> nfcCard = BalanceData().obs;

  changeNfcCard(BalanceData _balance) {
    nfcCard.value = _balance;
    nfcCard.refresh();
  }

  RxString bookingCode = "".obs;

  Rx<CheckinData> checkinData = CheckinData().obs;
  Rx<OnboardRequest> pairedUID = OnboardRequest().obs;
  Rx<TextEditingController> nameCtrl = TextEditingController().obs;
  Rx<TextEditingController> dateCtrl = TextEditingController().obs;
  Rx<TextEditingController> nationalityCtrl = TextEditingController().obs;
  Rx<TextEditingController> genderCtrl = TextEditingController().obs;
  Rx<TextEditingController> tableCtrl = TextEditingController().obs;
  Rx<TextEditingController> tagCtrl = TextEditingController().obs;
  Rx<DateTime> date = DateTime.now().obs;
  RxBool sameWithBooker = false.obs;
  RxBool targetGroup = false.obs;
  String get targetGroupValue => targetGroup.value ? "yes" : "no";

  RxList<String> listNationality = <String>[].obs;
  getNationality() async {
    Get.dialog(
      Loading(),
      barrierDismissible: false,
    );

    var _resp = await _globalRepo.getNationality();
    Get.back();

    if (_resp.data != null) {
      listNationality.value = _resp.data!;
      listNationality.refresh();
    } else {
      Get.bottomSheet(
        SheetFailed(
          errorMessage: _resp.message!,
        ),
      );
    }
  }

  bool checkPairDisable() {
    return dateCtrl.value.text == "" ||
        genderCtrl.value.text == "" ||
        nationalityCtrl.value.text == "" ||
        nameCtrl.value.text == "";
  }
}
