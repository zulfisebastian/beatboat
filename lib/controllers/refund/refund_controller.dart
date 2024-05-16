import 'package:beatboat/models/transaction/transaction_model.dart';
import 'package:beatboat/widgets/pages/loading.dart';
import 'package:get/get.dart';
import '../../pages/home/home.dart';
import '../../pages/result/success.dart';
import '../../repositories/transaction/transaction_repo.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../home/home_controller.dart';

class RefundController extends GetxController {
  final TransactionRepo _transactionRepo = Get.put(TransactionRepo());

  @override
  void onReady() {
    super.onReady();
    getListReason();
    getDataTransaction();
  }

  RxList<TransactionData> listTransaction = <TransactionData>[].obs;
  getDataTransaction() async {
    Get.dialog(Loading());
    var _resp = await _transactionRepo.getAllTransaction();
    Get.back();

    if (_resp.data!.length > 0) {
      listTransaction.value = _resp.data!;
      listTransaction.refresh();
    }
  }

  Rx<TransactionData> choosedTransaction = TransactionData().obs;

  RxList<DetailTransactionData> choosedProduct = <DetailTransactionData>[].obs;
  RxList<int> choosedProductQty = <int>[].obs;

  addProduct(DetailTransactionData _product) {
    choosedProduct.add(_product);
    choosedProductQty.add(0);
    choosedProduct.refresh();
    choosedProductQty.refresh();
    changeSheetRefundForm();
  }

  updateProductQty(index, qty) {
    choosedProductQty[index] = qty;
    choosedProductQty.refresh();
    changeSheetRefundForm();
  }

  removeProduct(int _index) {
    choosedProduct.removeAt(_index);
    choosedProductQty.removeAt(_index);
    choosedProduct.refresh();
    choosedProductQty.refresh();
    changeSheetRefundForm();
  }

  RxBool isSheetRefundDisabled = true.obs;
  changeSheetRefundForm() {
    isSheetRefundDisabled.value =
        choosedProductQty.indexWhere((e) => e == 0) > -1 ||
            choosedReason.value == "";
  }

  refundTransaction(String nfc_uid) async {
    String udid = Get.find(tag: "udid");

    List refundItems = [];
    var index = 0;
    for (var _data in choosedProduct) {
      refundItems.add({
        "trx_detail_id": _data.id,
        "qty": choosedProductQty[index],
      });
      index += 1;
    }

    var body = {
      "device_serial_number": udid,
      "trx_number": choosedTransaction.value.number,
      "reason": choosedReason.value,
      "nfc_uid": nfc_uid,
      "refund_items": refundItems,
    };

    var _resp = await _transactionRepo.refundTransaction(body);

    if (_resp.code != null) {
      Get.to(SuccessPage(
        title: "Your Refund Success",
        subtitle: "Thank you, and please wait until you get the email",
        action: "Done Refund!",
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
          errorMessage: _resp.message!,
        ),
      );
    }
  }

  RxList<String> listReason = <String>[].obs;
  RxString choosedReason = "".obs;
  getListReason() async {
    Get.dialog(
      Loading(),
    );
    var _resp = await _transactionRepo.getListReason();
    Get.back();

    if (_resp.data != null) {
      listReason.value = _resp.data!.reasons!;
      listReason.refresh();
    } else {
      Get.bottomSheet(
        SheetFailed(
          errorMessage: _resp.message!,
        ),
      );
    }
  }
}
