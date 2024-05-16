import 'package:beatboat/models/balance/balance_model.dart';
import 'package:beatboat/repositories/balance/balance_repo.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:get/get.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../base/base_controller.dart';

class BalanceController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");

  final BalanceRepo _repoBalance = Get.put(BalanceRepo());

  @override
  void onReady() {
    super.onReady();
    _base.initConnectivity();
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

  getWriteValue(BalanceData balance, int newAmount) {
    return "${balance.wristband_code}#${balance.nfc_uid}#${balance.type}#${balance.customer_name}#${newAmount}#${DateExt.reformat(DateTime.now().toString(), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")}";
  }
}
