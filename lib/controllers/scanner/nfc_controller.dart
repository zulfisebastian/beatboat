import 'package:beatboat/constants/enums.dart';
import 'package:beatboat/controllers/balance/transfer_controller.dart';
import 'package:beatboat/controllers/checkin/checkin_controller.dart';
import 'package:beatboat/controllers/refund/refund_controller.dart';
import 'package:beatboat/pages/home/home.dart';
import 'package:beatboat/pages/balance/topup.dart';
import 'package:beatboat/pages/balance/transfer.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/popups/update_balance.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:ndef/ndef.dart' as ndef;
import '../../models/balance/balance_model.dart';
import '../../pages/transaction/transaction.dart';
import '../../repositories/balance/balance_repo.dart';
import '../../widgets/pages/loading.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../transaction/transaction_controller.dart';

class NFCController extends GetxController {
  RxString resultData = "".obs;

  final BalanceRepo _repoBalance = Get.put(BalanceRepo());

  @override
  void onReady() {
    super.onReady();
  }

  Rx<BalanceData> balance = BalanceData().obs;

  readNFC(NFCModeType type) async {
    NFCTag tag = await FlutterNfcKit.poll(
      timeout: Duration(seconds: 30),
    );
    try {
      await FlutterNfcKit.setIosAlertMessage("Working on it...");
      if (tag.standard == "ISO 14443-4 (Type B)") {
        String result1 = await FlutterNfcKit.transceive("00B0950000");
        String result2 =
            await FlutterNfcKit.transceive("00A4040009A00000000386980701");
        resultData.value = '1: $result1\n2: $result2\n';
      } else if (tag.type == NFCTagType.iso18092) {
        String result1 = await FlutterNfcKit.transceive("060080080100");
        resultData.value = '1: $result1\n';
      } else if (tag.ndefAvailable ?? false) {
        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
        var ndefString = '';
        for (int i = 0; i < ndefRecords.length; i++) {
          ndefString += '${i + 1}: ${ndefRecords[i]}\n';
        }
        resultData.value = ndefString;
      } else if (tag.type == NFCTagType.webusb) {
        var r = await FlutterNfcKit.transceive("00A4040006D27600012401");
        print(r);
      }
      resultData.refresh();
      var _mapUUID =
          RegExp(r".{2}").allMatches(tag.id).map((e) => e.group(0)).join(":");

      String udid = Get.find(tag: "udid");

      Get.dialog(Loading());
      var body = {
        "device_serial_number": udid,
        "nfc_uid": _mapUUID,
      };

      var _resp = await _repoBalance.checkBalance(body);
      Get.back();

      if (_resp.data != null) {
        balance.value = _resp.data!;
        balance.refresh();
        if (type == NFCModeType.Pay) {
          Get.off(TransactionPage(
            nfcUid: balance.value.nfc_uid!,
          ));
        } else if (type == NFCModeType.TopUp) {
          Get.off(TopUpPage(
            nfcUid: balance.value.nfc_uid!,
          ));
        } else if (type == NFCModeType.TransferFrom) {
          Get.back();
          final TransferController _transferController =
              Get.put(TransferController(), tag: 'TransferController');
          _transferController.changeSourceCard(balance.value);
          Get.to(TransferPage());
        } else if (type == NFCModeType.TransferTo) {
          Get.back();
          final TransferController _transferController =
              Get.find(tag: 'TransferController');
          _transferController.changeDestinationCard(balance.value);
        } else if (type == NFCModeType.Participant) {
          final TransactionController _transController =
              Get.find(tag: 'TransactionController');
          _transController.addParticipant(balance.value);
        } else if (type == NFCModeType.Refund) {
          final RefundController _refundController =
              Get.find(tag: 'RefundController');
          _refundController.refundTransaction(_mapUUID);
        } else {
          //
        }
      } else {
        Get.back();
        Get.bottomSheet(
          SheetFailed(
            errorMessage: _resp.message!,
          ),
          isScrollControlled: true,
        );
      }
    } catch (e) {
      resultData.value = 'error: $e';
      resultData.refresh();
      Get.back();
    }
  }

  onboardNFC() async {
    NFCTag tag = await FlutterNfcKit.poll();
    try {
      await FlutterNfcKit.setIosAlertMessage("Working on it...");
      if (tag.standard == "ISO 14443-4 (Type B)") {
        String result1 = await FlutterNfcKit.transceive("00B0950000");
        String result2 =
            await FlutterNfcKit.transceive("00A4040009A00000000386980701");
        resultData.value = '1: $result1\n2: $result2\n';
      } else if (tag.type == NFCTagType.iso18092) {
        String result1 = await FlutterNfcKit.transceive("060080080100");
        resultData.value = '1: $result1\n';
      } else if (tag.ndefAvailable ?? false) {
        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
        var ndefString = '';
        for (int i = 0; i < ndefRecords.length; i++) {
          ndefString += '${i + 1}: ${ndefRecords[i]}\n';
        }
        resultData.value = ndefString;
      } else if (tag.type == NFCTagType.webusb) {
        var r = await FlutterNfcKit.transceive("00A4040006D27600012401");
        print(r);
      }
      resultData.refresh();
      var _mapUUID =
          RegExp(r".{2}").allMatches(tag.id).map((e) => e.group(0)).join(":");

      Get.dialog(Loading());
      final CheckinController _checkinController =
          Get.find(tag: "CheckinController");

      _checkinController.updatePairedUID(_mapUUID);
      var _data = _checkinController
          .listPairedUID[_checkinController.activeIndex.value];
      var body = {
        "device_serial_number": _data.device_serial_number,
        "booking_code": _data.booking_code,
        "nfc_uid": _data.nfc_uid,
        "customer_name": _data.customer_name,
        "nationality": _data.nationality,
        "dob": _data.dob,
        "gender": _data.gender!.toLowerCase(),
      };

      var _resp = await _repoBalance.onboard(body);
      Get.back();

      if (_resp.code != null) {
        if (_resp.code == "SCC-ONBOARD-001") {
          Get.back();
        } else {
          Get.back();
          Get.bottomSheet(
            SheetFailed(
              errorMessage: _resp.message!,
            ),
          );
        }
      } else {
        Get.back();
        Get.bottomSheet(
          SheetFailed(
            errorMessage: _resp.message!,
          ),
        );
      }
    } catch (e) {
      resultData.value = 'error: $e';
      resultData.refresh();
    }
  }

  writeNFC(NFCModeType type, String writeValue) async {
    try {
      NFCTag tag = await FlutterNfcKit.poll();

      if (tag.type == NFCTagType.mifare_ultralight ||
          tag.type == NFCTagType.mifare_classic ||
          tag.type == NFCTagType.iso15693) {
        await FlutterNfcKit.writeNDEFRecords(
          [
            ndef.TextRecord(
              encoding: ndef.TextEncoding.values[0],
              language: "en",
              text: writeValue,
            )
          ],
        );
        if (type == NFCModeType.UpdateAfterPay) {
          Get.offAll(HomePage());
          Get.dialog(
            UpdateBalance(
              title: "Your Balance Deducted",
              subtitle: "Now your balance is ${StringExt.formatRupiah(
                int.parse(writeValue.split("#")[4]),
              )}",
              onFinish: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        } else if (type == NFCModeType.UpdateAfterTopUp) {
          Get.offAll(HomePage());
          Get.dialog(
            UpdateBalance(
              title: "Your Balance Updated",
              subtitle: "Now your balance is ${StringExt.formatRupiah(
                int.parse(writeValue.split("#")[4]),
              )}",
              onFinish: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        } else if (type == NFCModeType.UpdateAfterTransfer) {
        } else {}
      } else {
        Get.bottomSheet(
          SheetFailed(errorMessage: "error: NDEF not supported: ${tag.type}"),
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    } finally {
      await FlutterNfcKit.finish();
    }
  }
}
