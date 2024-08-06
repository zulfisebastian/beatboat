import 'package:beatboat/models/transaction/transaction_model.dart';
import 'package:beatboat/widgets/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import '../../constants/dimension.dart';
import '../../pages/home/home.dart';
import '../../pages/result/success.dart';
import '../../repositories/transaction/transaction_repo.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/ctoast.dart';
import '../../widgets/components/customButton.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../balance/balance_controller.dart';
import '../base/base_controller.dart';
import '../home/home_controller.dart';

class RefundController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");
  final TransactionRepo _transactionRepo = Get.put(TransactionRepo());

  @override
  void onReady() {
    super.onReady();
    getListReason();
  }

  RxString uuid = "".obs;

  RxList<TransactionData> listTransaction = <TransactionData>[].obs;
  getDataTransaction() async {
    Get.dialog(Loading());
    var _resp = await _transactionRepo.getRefundTransaction(uuid.value);
    Get.back();

    if (_resp.data != null) {
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

  refundTransaction() async {
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
      "nfc_uid": uuid.value,
      "refund_items": refundItems,
    };

    var _resp = await _transactionRepo.refundTransaction(body);

    if (_resp.code != null) {
      printStruck();
      printBillThermal();
      Get.to(SuccessPage(
        title: "Your Refund Success",
        subtitle: "Thank you, and please wait until you get the email",
        action: "Done Refund!",
        otherWidget: Row(
          children: [
            Expanded(
              child: CustomButtonBlue(
                "Receipt Customer",
                onPressed: () async {
                  await printStruck();
                },
              ),
            ),
            SizedBox(
              width: CDimension.space8,
            ),
            Expanded(
              child: CustomButtonBlue(
                "Receipt Bar",
                onPressed: () async {
                  await printBillThermal();
                },
              ),
            ),
          ],
        ),
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

  int getTotalCart() {
    int total = 0;
    int index = 0;
    for (var data in choosedProduct) {
      var price = data.discounted_unit_price! > 0
          ? data.discounted_unit_price!
          : data.unit_price!;
      total += price * choosedProductQty[index];
      index++;
    }
    return total;
  }

  double getAdminTax(total) {
    return total * 10 / 100;
  }

  double getServiceTax(total) {
    return total * 8 / 100;
  }

  double getTotalAfterPPNCart() {
    return getTotalCart() +
        getAdminTax(getTotalCart()) +
        getServiceTax(getTotalCart());
  }

  printStruck() async {
    final BalanceController _balanceController = Get.put(
      BalanceController(),
    );

    await _base.getProfile();
    await _balanceController.checkBalance(choosedTransaction.value.nfc_uid!);
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.bindingPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    //Logo
    await SunmiPrinter.printText(
      'Order No: ' + choosedTransaction.value.order_no.toString(),
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'No ${choosedTransaction.value.number}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'Trx Date: ${DateExt.reformat(DateTime.now().toString(), "yyyy-MM-dd HH:mm", "dd MMM yyyy (HH:mm)")}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.printText(
      'Cashier: ${_base.dataProfile.value.full_name}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.printText(
      'Table Name: ${choosedTransaction.value.table_name}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.printText(
      'Bill Type: ${choosedTransaction.value.payment_method}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.line();
    //Item
    var index = 0;
    for (var _item in choosedProduct) {
      var price = _item.discounted_unit_price! > 0
          ? _item.discounted_unit_price!
          : _item.unit_price!;
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "[REFUND] ${_item.product!.name ?? "-"}",
          width: 22,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: _item.product!.unit ?? "UNIT",
          width: 8,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "${StringExt.thousandFormatter(price)}",
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "x",
          width: 1,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: choosedProductQty[index].toString(),
          width: 2,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "=",
          width: 1,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "${StringExt.formatRupiah(
            (price) * choosedProductQty[index],
          )}",
          width: 14,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      if (_item.note != null) {
        await SunmiPrinter.printText(
          'Note: ${_item.note!}',
          style: SunmiStyle(
            fontSize: SunmiFontSize.MD,
            bold: false,
            align: SunmiPrintAlign.LEFT,
          ),
        );
      }
      index++;
    }
    await SunmiPrinter.line();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Sub Total",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: StringExt.formatRupiah(getTotalCart()),
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Tax (10%)",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: StringExt.formatRupiah(
          getAdminTax(getTotalCart()),
        ),
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Service (8%)",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: StringExt.formatRupiah(
          getServiceTax(getTotalCart()),
        ),
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.line();
    await SunmiPrinter.bold();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Grand Total",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: StringExt.formatRupiah(getTotalAfterPPNCart()),
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    if (choosedTransaction.value.payment_method == "STANDALONE") {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "Last Balance",
          width: 14,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: StringExt.thousandFormatter(
              _balanceController.balance.value.last_balance),
          width: 16,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    }
    await SunmiPrinter.resetBold();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'cannot be returned',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'Thank you for your purchase.',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    await SunmiPrinter.lineWrap(4);
    await SunmiPrinter.cut();
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.exitTransactionPrint(true);
  }

  printBillThermal() async {
    await _base.getProfile();
    for (var _printer in _base.printerThermal) {
      // if (listCart.indexWhere((e) => e.order_serve == _printer.value) > -1) {
      final printer = PrinterNetworkManager(_printer.ip!);

      PosPrintResult connect = await printer.connect();

      CToast.showWithoutCOntext(
        "Connecting to ${_printer.ip!}",
        Colors.black,
        Colors.white,
      );
      if (connect == PosPrintResult.success) {
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm80, profile);
        List<int> bytes = [];
        bytes += generator.feed(1);
        bytes += generator.row([
          PosColumn(
            text: "Order No: ",
            width: 3,
            styles: const PosStyles(align: PosAlign.left, underline: false),
          ),
          PosColumn(
            text: choosedTransaction.value.order_no.toString(),
            width: 9,
            styles: const PosStyles(align: PosAlign.left, underline: false),
          ),
        ]);
        bytes += generator.row([
          PosColumn(
            text: "Customer: ",
            width: 3,
            styles: const PosStyles(align: PosAlign.left, underline: false),
          ),
          PosColumn(
            text: choosedTransaction.value.customer_name ?? "-",
            width: 9,
            styles: const PosStyles(align: PosAlign.left, underline: false),
          ),
        ]);
        //Item
        bytes += generator.feed(1);
        var index = 0;
        for (var _data in choosedProduct) {
          bytes += generator.row(
            [
              PosColumn(
                text: "[REFUND] ${_data.product!.name ?? "-"}",
                width: 8,
                styles: PosStyles(
                  align: PosAlign.left,
                  height: PosTextSize.size2,
                  width: PosTextSize.size2,
                ),
              ),
              PosColumn(
                text: "x${choosedProductQty[index].toString()}",
                width: 4,
                styles: PosStyles(
                  align: PosAlign.right,
                  height: PosTextSize.size2,
                  width: PosTextSize.size2,
                ),
              ),
            ],
          );

          if (_data.note != null) {
            bytes += generator.text(
              'Note: ${_data.note!}',
              styles: PosStyles(
                align: PosAlign.left,
              ),
            );
          }
          index++;
        }
        bytes += generator.feed(1);
        bytes += generator.text(
          'No: ${choosedTransaction.value.number}',
          styles: PosStyles(
            align: PosAlign.left,
          ),
        );
        bytes += generator.text(
          'Trx Date: ${DateExt.reformat(DateTime.now().toString(), "yyyy-MM-dd HH:mm", "dd MMM yyyy (HH:mm)")}',
          styles: PosStyles(
            align: PosAlign.left,
          ),
        );
        bytes += generator.text(
          'Cashier: ${_base.dataProfile.value.full_name}',
          styles: PosStyles(
            align: PosAlign.left,
          ),
        );
        bytes += generator.text(
          'Table Name: ${choosedTransaction.value.table_name}',
          styles: PosStyles(
            align: PosAlign.left,
          ),
        );
        bytes += generator.feed(1);
        bytes += generator.cut();
        PosPrintResult printing = await printer.printTicket(bytes);

        print(printing.msg);
        await printer.disconnect();
      } else {
        CToast.showWithoutCOntext(
          connect.msg,
          Colors.red,
          Colors.white,
        );
      }
      // }
    }
  }
}
