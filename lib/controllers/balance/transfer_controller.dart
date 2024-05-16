import 'package:beatboat/widgets/popups/confirmation.dart';
import 'package:beatboat/widgets/sheets/sheet_insufficient_balance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/balance/balance_model.dart';
import '../../pages/home/home.dart';
import '../../pages/result/success.dart';
import '../../repositories/balance/balance_repo.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../home/home_controller.dart';

class TransferController extends GetxController {
  Rx<TextEditingController> amount = TextEditingController().obs;

  final BalanceRepo _balanceRepo = Get.put(BalanceRepo());

  @override
  void onReady() {
    super.onReady();
  }

  Rx<BalanceData> sourceCard = BalanceData().obs;
  Rx<BalanceData> destinationCard = BalanceData().obs;

  changeSourceCard(BalanceData _balance) {
    sourceCard.value = _balance;
    sourceCard.refresh();
    destinationCard.value = BalanceData();
    destinationCard.refresh();
  }

  changeDestinationCard(BalanceData _balance) {
    destinationCard.value = _balance;
    destinationCard.refresh();
  }

  switchCard() {
    BalanceData _temp = BalanceData();
    _temp = sourceCard.value;

    sourceCard.value = destinationCard.value;
    sourceCard.refresh();

    destinationCard.value = _temp;
    destinationCard.refresh();
  }

  transferBalance() async {
    int _amount = int.parse(amount.value.text.replaceAll(".", ""));
    if (_amount > sourceCard.value.last_balance!) {
      Get.bottomSheet(
        SheetInsufficientBalance(nfcUid: sourceCard.value.nfc_uid!),
      );
      return;
    }

    Get.dialog(
      Confirmation(
        title: "Warning!",
        subtitle:
            "Are you sure want to transfer your balance to ${destinationCard.value.customer_name!.capitalize}?",
        onOk: () async {
          String udid = Get.find(tag: "udid");

          var body = {
            "device_serial_number": udid,
            "source_nfc_uid": sourceCard.value.nfc_uid,
            "destination_nfc_uid": destinationCard.value.nfc_uid,
            "nominal": _amount,
          };

          var _resp = await _balanceRepo.transferBalance(body);

          if (_resp.data != null) {
            Get.to(SuccessPage(
              title: "Transfer Success",
              subtitle:
                  "Congratulations, Your balance has been transfered successfully to ${destinationCard.value.customer_name!.capitalize}",
              action: "Done Transfer!",
              onFinish: () {
                final HomeController _homeController =
                    Get.find(tag: 'HomeController');
                _homeController.initAllData();
                Get.offAll(HomePage());
              },
            ));
          } else {
            Get.back();
            Get.bottomSheet(
              SheetFailed(
                  errorMessage:
                      "Transfer balance failed, please contact our admin"),
            );
          }
        },
      ),
    );
  }
}
