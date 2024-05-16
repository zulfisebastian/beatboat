import 'package:beatboat/models/checkin/checkin_model.dart';
import 'package:beatboat/pages/home/home.dart';
import 'package:beatboat/repositories/global/global_repo.dart';
import 'package:beatboat/repositories/transaction/transaction_repo.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/sheets/sheet_failed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../models/balance/balance_model.dart';
import '../../models/transaction/onboard_model.dart';
import '../../pages/checkin/checkin_success.dart';
import '../../widgets/pages/loading.dart';
import '../../widgets/popups/wristband_registered.dart';

class CheckinController extends GetxController {
  final scrollController = ScrollController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  final TransactionRepo _transactionRepo = Get.put(TransactionRepo());
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
  RxList<OnboardRequest> listPairedUID = <OnboardRequest>[].obs;
  RxList<TextEditingController> listNameCtrl = <TextEditingController>[].obs;
  RxList<TextEditingController> listDateCtrl = <TextEditingController>[].obs;
  RxList<TextEditingController> listNationalityCtrl =
      <TextEditingController>[].obs;
  RxList<TextEditingController> listGenderCtrl = <TextEditingController>[].obs;
  RxList<DateTime> listDate = <DateTime>[].obs;
  RxBool sameWithBooker = false.obs;

  changeSameWithBooker() {
    sameWithBooker.value = !sameWithBooker.value;
    sameWithBooker.refresh();

    if (sameWithBooker.value) {
      listNameCtrl[0].text = checkinData.value.booker_name!;
      listDate[0] = DateFormat("yyyy-MM-dd").parse(checkinData.value.dob!);
      listDateCtrl[0].text = checkinData.value.dob!;
      listNationalityCtrl[0].text = checkinData.value.nationality!;
      listGenderCtrl[0].text = checkinData.value.gender!;
    } else {
      listNameCtrl[0].text = "";
      listDate[0] = DateTime.now();
      listDateCtrl[0].text = "";
      listNationalityCtrl[0].text = "";
      listGenderCtrl[0].text = "";
    }

    changeName(0, listNameCtrl[0].text);
    changeNationality(0, listNationalityCtrl[0].text);
    changeDOB(0, listDateCtrl[0].text);
    changeGender(0, listGenderCtrl[0].text);
  }

  checkInEvent(context, id) async {
    String udid = Get.find(tag: "udid");

    Get.dialog(
      Loading(),
      barrierDismissible: false,
    );
    var body = {
      "device_serial_number": udid,
      "booking_code": id,
    };

    var _resp = await _transactionRepo.checkIn(body);
    Get.back();

    if (_resp.data != null) {
      checkinData.value = _resp.data!;
      checkinData.refresh();

      var index = 0;
      for (var _data in _resp.data!.details!) {
        listNameCtrl
            .add(TextEditingController(text: _data.customer_name ?? ""));
        listDateCtrl.add(
          TextEditingController(
            text: _data.dob != null
                ? DateExt.reformat(_data.dob!, "yyyy-MM-dd", "EEE, dd MMM yyyy")
                : "",
          ),
        );
        listNationalityCtrl.add(
          TextEditingController(
              text: _data.nationality != null
                  ? _data.nationality!.capitalizeFirst
                  : ""),
        );
        listGenderCtrl.add(
          TextEditingController(
              text: _data.gender != null ? _data.gender!.capitalizeFirst : ""),
        );
        listDate.add(
          _data.dob != null
              ? DateFormat("yyyy-MM-dd").parse(_data.dob!)
              : DateTime.now(),
        );

        listPairedUID.add(
          OnboardRequest(
            device_serial_number: udid,
            booking_code: _data.booking_code,
            name: _data.name,
            nfc_uid: _data.wristband_nfc_uid ?? "",
            customer_name: listNameCtrl[index].text,
            nationality: listNationalityCtrl[index].text,
            dob: listDateCtrl[index].text,
            gender: listGenderCtrl[index].text,
            isFromResp: _data.wristband_nfc_uid != null ? true : false,
          ),
        );
        index += 1;
      }
      checkFormDisabled();

      Get.to(
        CheckinSuccessPage(
          title: "Checkin Success",
          data: _resp.data!,
          action: "Scan Wristband",
          onFinish: () {
            qrController!.resumeCamera();
            Get.offAll(HomePage());
            Get.dialog(
              WristbandRegistered(
                title: "The wristband has been paired with customer data",
                onFinish: () {
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          },
        ),
      );
    } else {
      qrController!.resumeCamera();
      Get.bottomSheet(
        SheetFailed(
          errorMessage: _resp.message!,
        ),
      );
    }
  }

  changeName(index, val) {
    listPairedUID[index].customer_name = val;
    listPairedUID.refresh();
    checkFormDisabled();
  }

  changeDOB(index, val) {
    listPairedUID[index].dob = val;
    listPairedUID.refresh();
    checkFormDisabled();
  }

  changeNationality(index, val) {
    listPairedUID[index].nationality = val;
    listPairedUID.refresh();
    checkFormDisabled();
  }

  changeGender(index, val) {
    listPairedUID[index].gender = val;
    listPairedUID.refresh();
    checkFormDisabled();
  }

  RxInt activeIndex = 0.obs;
  updatePairedUID(String _uid) {
    listPairedUID[activeIndex.value].nfc_uid = _uid;
    checkFormDisabled();
  }

  RxBool disabledForm = true.obs;
  checkFormDisabled() {
    disabledForm.value = listPairedUID.indexWhere((e) =>
            e.nfc_uid == "" ||
            e.customer_name == "" ||
            e.nationality == "" ||
            e.dob == "" ||
            e.gender == "") >
        -1;
  }

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

  bool checkPairDisable(index) {
    return listDateCtrl[index].text == "" ||
        listGenderCtrl[index].text == "" ||
        listNationalityCtrl[index].text == "" ||
        listNameCtrl[index].text == "";
  }
}
