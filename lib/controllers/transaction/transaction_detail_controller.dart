import 'package:beatboat/models/transaction/transaction_model.dart';
import 'package:beatboat/repositories/transaction/transaction_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/ctoast.dart';
import '../balance/balance_controller.dart';
import '../base/base_controller.dart';

class TransactionDetailController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");
  TransactionRepo _transactionRepo = TransactionRepo();

  Rx<TransactionData> transactionData = TransactionData().obs;
  getTransactionDetail(id) async {
    var _resp = await _transactionRepo.getDetailTransaction(id);

    transactionData.value = TransactionData();
    if (_resp.data != null) {
      transactionData.value = _resp.data!;
      transactionData.refresh();
    }
  }

  printStruck(TransactionData _data) async {
    final BalanceController _balanceController = Get.put(
      BalanceController(),
      tag: "BalanceController",
    );

    await _base.getProfile();
    await _balanceController.checkBalance(_data.nfc_uid!);
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.bindingPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    //Logo
    await SunmiPrinter.printText(
      'Order No: ' + _data.order_no.toString(),
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'No ${_data.number}',
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
      'Table Name: ${_data.table_name}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.printText(
      'Bill Type: ${_data.payment_method}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.line();
    //Item
    for (var _item in _data.details!) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: _item.product!.name ?? "-",
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
          text: "${StringExt.thousandFormatter(_item.product!.sell_price)}",
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "x",
          width: 1,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: _item.qty!.toString(),
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
            _item.total_price,
          )}",
          width: 14,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      if (_item.addons!.length > 0) {
        await SunmiPrinter.printText(
          'AddOn: ${_item.addons!.map((e) => "x${e.qty} ${e.addons!.capitalizeFirst}").join(", ")}',
          style: SunmiStyle(
            fontSize: SunmiFontSize.MD,
            bold: false,
            align: SunmiPrintAlign.LEFT,
          ),
        );
      }
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
    }
    await SunmiPrinter.line();
    if (_data.discount_amount! > 0) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "Total",
          width: 14,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: StringExt.formatRupiah(
              _data.total_amount! + _data.discount_amount!),
          width: 16,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "Discount",
          width: 14,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "- ${StringExt.formatRupiah(_data.discount_amount)}",
          width: 16,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "Sub Total",
          width: 14,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: StringExt.formatRupiah(_data.total_amount),
          width: 16,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    } else {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "Sub Total",
          width: 14,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: StringExt.formatRupiah(_data.total_amount),
          width: 16,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    }
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Tax (10%)",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: StringExt.formatRupiah(_data.tax),
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
        text: StringExt.formatRupiah(_data.service_tax),
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
        text: StringExt.formatRupiah(_data.subtotal),
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    if (_data.payment_method == "STANDALONE") {
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

  printBillThermal(TransactionData _data) async {
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
            text: _data.order_no.toString(),
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
            text: _data.customer_name ?? "-",
            width: 9,
            styles: const PosStyles(align: PosAlign.left, underline: false),
          ),
        ]);
        //Item
        bytes += generator.feed(1);
        for (var _item in _data.details!) {
          // if (_printer.value == _item.order_serve) {
          bytes += generator.row(
            [
              PosColumn(
                text: _item.product!.name ?? "-",
                width: 8,
                styles: PosStyles(
                  align: PosAlign.left,
                  height: PosTextSize.size2,
                  width: PosTextSize.size2,
                ),
              ),
              PosColumn(
                text: "x${_item.qty!.toString()}",
                width: 4,
                styles: PosStyles(
                  align: PosAlign.right,
                  height: PosTextSize.size2,
                  width: PosTextSize.size2,
                ),
              ),
            ],
          );
          if (_item.addons!.length > 0) {
            bytes += generator.text(
              'AddOn: ${_item.addons!.map((e) => "x${e.qty} ${e.addons!.capitalizeFirst}").join(", ")}',
              styles: PosStyles(
                align: PosAlign.left,
              ),
            );
          }
          if (_item.note != null) {
            bytes += generator.text(
              'Note: ${_item.note!}',
              styles: PosStyles(
                align: PosAlign.left,
              ),
            );
          }
        }
        bytes += generator.feed(1);
        bytes += generator.text(
          'No: ${_data.number}',
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
          'Table Name: ${_data.table_name}',
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
