import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/models/balance/balance_model.dart';
import 'package:beatboat/models/product/cart_model.dart';
import 'package:beatboat/models/transaction/add_transaction_model.dart';
import 'package:beatboat/models/voucher/voucher_model.dart';
import 'package:beatboat/pages/home/home.dart';
import 'package:beatboat/pages/result/success.dart';
import 'package:beatboat/services/databases/transaction/cart_table.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/ctoast.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/pages/loading.dart';
import 'package:beatboat/widgets/sheets/sheet_failed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import '../../models/product/product_model.dart';
import '../../pages/transaction/splitbill.dart';
import '../../repositories/transaction/transaction_repo.dart';
import '../balance/balance_controller.dart';
import '../base/base_controller.dart';
import '../home/home_controller.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';

class TransactionController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");
  final scrollController = ScrollController();

  final TransactionRepo _transactionRepo = Get.put(TransactionRepo());

  @override
  void onReady() {
    super.onReady();
    _base.initConnectivity();
    scrollControllerListener();
    initAllData();
  }

  RxBool showScrollArrow = false.obs;
  void scrollControllerListener() async {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      showScrollArrow.value = true;
      showScrollArrow.refresh();
    } else {
      showScrollArrow.value = false;
      showScrollArrow.refresh();
    }
  }

  initAllData() {
    renewListCart();
  }

  RxList<CartData> listCart = <CartData>[].obs;
  renewListCart() async {
    var _resp = await CartTable().getAllCart();
    if (_resp != null) {
      listCart.value = _resp;
      listCart.refresh();
    }
  }

  addProductToCart(ProductData _product) async {
    CartData _cart = new CartData();
    _cart.id = _product.id;
    _cart.category_id = _product.category_id;
    _cart.sku = _product.sku;
    _cart.name = _product.name;
    _cart.description = _product.description;
    _cart.buy_price = _product.buy_price;
    _cart.sell_price = _product.sell_price;
    _cart.stock = _product.stock;
    _cart.status = _product.status;
    _cart.unit = _product.unit;
    _cart.image_url = _product.image_url;

    var _resp = await CartTable().getCartById(_cart);

    if (_resp != null) {
      _cart.qty = _resp[0].qty! + 1;
      CartTable().updateCart(_cart);
    } else {
      _cart.qty = 1;
      CartTable().addCart(_cart);
    }
    renewListCart();
  }

  deleteProductFromCart(ProductData _product) {
    CartData _cart = new CartData();
    _cart.id = _product.id;
    _cart.category_id = _product.category_id;
    _cart.sku = _product.sku;
    _cart.name = _product.name;
    _cart.description = _product.description;
    _cart.buy_price = _product.buy_price;
    _cart.sell_price = _product.sell_price;
    _cart.stock = _product.stock;
    _cart.status = _product.status;
    _cart.unit = _product.unit;
    _cart.image_url = _product.image_url;

    CartTable().getCartById(_cart).then((data) {
      if (data == null) {
        return;
      }

      if (data.length == 1) {
        CartTable().deleteCart(_cart);
        return;
      } else {
        _cart.qty = _cart.qty! - 1;
        CartTable().updateCart(_cart);
      }
    });
    renewListCart();
  }

  increaseCart(CartData _cart) async {
    var _resp = await CartTable().getCartById(_cart);

    if (_resp != null) {
      _cart.qty = _resp[0].qty! + 1;
      CartTable().updateCart(_cart);
    }
    renewListCart();
  }

  decreaseCart(CartData _cart) async {
    var _resp = await CartTable().getCartById(_cart);

    if (_resp != null) {
      if (_resp[0].qty! > 1) {
        _cart.qty = _resp[0].qty! - 1;
        CartTable().updateCart(_cart);
      } else {
        CartTable().deleteCart(_cart);
      }
    } else {
      CartTable().deleteCart(_cart);
    }
    renewListCart();
  }

  Rx<TextEditingController> voucher = TextEditingController().obs;

  Rx<VoucherData> voucherData = VoucherData().obs;
  checkVoucher() async {
    Get.dialog(Loading());
    var body = {
      "voucher_code": voucher.value.text.toUpperCase(),
      "usage": "transaction",
    };

    var _resp = await _transactionRepo.checkVoucher(body);
    Get.back();

    if (_resp.data != null) {
      Get.back();
      voucherData.value = _resp.data!;
      voucherData.refresh();
    } else {
      Get.back();
      Get.bottomSheet(
        SheetFailed(errorMessage: _resp.message!),
      );
    }
  }

  removeVoucher() {
    voucherData.value = VoucherData();
    voucherData.refresh();
    voucher.value.text = "";
  }

  int getTotalCart() {
    int total = 0;
    for (var data in listCart) {
      total += data.sell_price! * data.qty!;
    }
    return total;
  }

  int calculateDiscount() {
    if (voucherData.value.voucher_code != null) {
      if (voucherData.value.type!.toLowerCase() == "percentage") {
        int _totalBeforeLimitation =
            getTotalCart() * voucherData.value.nominal! ~/ 100;
        if (_totalBeforeLimitation > voucherData.value.max_discount!) {
          return voucherData.value.max_discount!;
        }
        return _totalBeforeLimitation;
      }
      return voucherData.value.nominal!;
    } else {
      return 0;
    }
  }

  int getTotalCartAfterDiscount() {
    return getTotalCart() - calculateDiscount();
  }

  double getAdminTax(total) {
    return total * 10 / 100;
  }

  double getServiceTax(total) {
    return total * 8 / 100;
  }

  double getTotalAfterPPNCart() {
    return getTotalCartAfterDiscount() +
        getAdminTax(getTotalCartAfterDiscount()) +
        getServiceTax(getTotalCartAfterDiscount());
  }

  RxString choosedPayment = "Cash".obs;
  changeChoosedPayment(String payment) {
    choosedPayment.value = payment;
    choosedPayment.refresh();
  }

  finishTransaction() {
    //
  }

  goToSplitBill(BalanceData _participant) {
    listParticipant.clear();
    listParticipantAmountController.clear();
    listIsManual.clear();
    listParticipant.refresh();
    listParticipantAmountController.refresh();
    listIsManual.refresh();
    Get.to(
      SplitBillPage(),
    );
    addParticipant(_participant);
  }

  RxList<BalanceData> listParticipant = <BalanceData>[].obs;
  RxList<bool> listIsManual = <bool>[].obs;
  RxList<TextEditingController> listParticipantAmountController =
      <TextEditingController>[].obs;

  addParticipant(BalanceData newParticipant) {
    if (listParticipant.length > 0) {
      if (listParticipant
              .indexWhere((e) => e.nfc_uid == newParticipant.nfc_uid) ==
          -1) {
        Get.back();
        listParticipant.add(newParticipant);
        listIsManual.add(false);
        listParticipantAmountController.add(TextEditingController());
        updateSplitBillAmountByQty();
      } else {
        Get.back();
        Get.bottomSheet(
          SheetFailed(errorMessage: "This NFC has been registered"),
        );
      }
    } else {
      listParticipant.add(newParticipant);
      listIsManual.add(false);
      listParticipantAmountController.add(TextEditingController());
      listParticipantAmountController[0].text =
          StringExt.thousandFormatter(getTotalAfterPPNCart());
    }
    listParticipant.refresh();
  }

  deleteParticipant(int index) {
    listParticipant.removeAt(index);
    listIsManual.removeAt(index);
    listParticipantAmountController.removeAt(index);
    updateSplitBillAmountByQty();
    listParticipant.refresh();
  }

  RxBool disabledSplitBill = true.obs;
  changeValidationSplitBillForm() {
    var _index =
        listParticipantAmountController.indexWhere((e) => e.text == "");
    disabledSplitBill.value = _index > -1;
    disabledSplitBill.refresh();
  }

  updateSplitBillAmountByQty() {
    var _diff = (getTotalAfterPPNCart() - getTotalManuallyChanged()).toInt();
    var _changedManuallyLength =
        listIsManual.where((p) => p == false).toList().length;

    print("INI TOTAL DIFF $_diff");
    print("INI TOTAL CHANGED $_changedManuallyLength");

    for (var i = 0; i < listIsManual.length; i++) {
      if (!listIsManual[i]) {
        listParticipantAmountController[i].text = StringExt.thousandFormatter(
          _diff ~/ _changedManuallyLength,
        );
      }
    }
  }

  updateByManualChanges(String _new, int index) {
    listIsManual[index] = true;
    listIsManual.refresh();

    var _diff = getTotalAfterPPNCart() - getTotalManuallyChanged();
    var _changedManuallyLength =
        listIsManual.where((p) => p == false).toList().length;

    for (var i = 0; i < listIsManual.length; i++) {
      if (i == index) {
        listParticipantAmountController[index].text = _new;
      } else {
        if (!listIsManual[i]) {
          listParticipantAmountController[i].text = StringExt.thousandFormatter(
            _diff ~/ _changedManuallyLength,
          );
        }
      }
    }
  }

  getTotalManuallyChanged() {
    double total = 0;
    for (var i = 0; i < listIsManual.length; i++) {
      if (listIsManual[i]) {
        total += double.parse(
            listParticipantAmountController[i].text.replaceAll(".", ""));
      }
    }
    return total;
  }

  payStandAlone() async {
    String udid = Get.find(tag: "udid");

    Get.dialog(
      Loading(),
    );
    final BalanceController _balanceController = Get.find(
      tag: 'BalanceController',
    );

    var body = {
      "device_serial_number": udid,
      "voucher_code": voucherData.value.voucher_code != null
          ? voucherData.value.voucher_code
          : null,
      "payment_method": "STANDALONE",
      "payments": [
        {
          "nfc_uid": _balanceController.balance.value.nfc_uid,
          "nominal": getTotalAfterPPNCart().toInt(),
        }
      ],
      "items": listCart
          .map(
            (e) => {
              "product_id": e.id,
              "qty": e.qty,
            },
          )
          .toList(),
    };

    var _resp = await _transactionRepo.payTransaction(body);
    Get.back();

    if (_resp.code != null) {
      CartTable().truncateCart();
      renewListCart();
      await printStruck(_resp.data!, "Stand Alone");
      Get.back();
      Get.to(SuccessPage(
        title: "Your Transaction Success",
        subtitle: "Thank you, and please wait until your order delivered",
        action: "Done Order!",
        otherWidget: Row(
          children: [
            Expanded(
              child: CustomButtonBlue(
                "Receipt Customer",
                onPressed: () async {
                  await printStruck(_resp.data!, "Stand Alone");
                },
              ),
            ),
            SizedBox(
              width: CDimension.space8,
            ),
            Expanded(
              child: CustomButtonBlue(
                "Receipt Waiter",
                onPressed: () async {
                  await printBillThermal(_resp.data!);
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
      Get.bottomSheet(SheetFailed(errorMessage: _resp.message!));
    }
  }

  payStandSplitBill() async {
    String udid = Get.find(tag: "udid");
    var body = {
      "device_serial_number": udid,
      "voucher_code": voucherData.value.voucher_code != null
          ? voucherData.value.voucher_code
          : null,
      "payment_method": "SPLIT_BILL",
      "payments": listParticipant
          .mapIndexed(
            (e, index) => {
              "nfc_uid": e.nfc_uid,
              "nominal": int.parse(
                listParticipantAmountController[index].text.replaceAll(".", ""),
              ),
            },
          )
          .toList(),
      "items": listCart
          .map(
            (e) => {
              "product_id": e.id,
              "qty": e.qty,
            },
          )
          .toList(),
    };

    var _resp = await _transactionRepo.payTransaction(body);

    if (_resp.data != null) {
      CartTable().truncateCart();
      renewListCart();
      await printStruck(_resp.data!, "Split Bill");
      Get.to(SuccessPage(
        title: "Your Transaction Success",
        subtitle: "Thank you, and please wait until your order delivered",
        action: "Done Order!",
        otherWidget: Row(
          children: [
            Expanded(
              child: CustomButtonBlue(
                "Receipt Customer",
                onPressed: () async {
                  await printStruck(_resp.data!, "Stand Alone");
                },
              ),
            ),
            SizedBox(
              width: CDimension.space8,
            ),
            Expanded(
              child: CustomButtonBlue(
                "Receipt Waiter",
                onPressed: () async {
                  await printBillThermal(_resp.data!);
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
        SheetFailed(errorMessage: _resp.message!),
      );
    }
  }

  printStruck(AddTransactionData _data, String type) async {
    await _base.getProfile();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.bindingPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    //Logo
    await SunmiPrinter.printText(
      'Order No: 1',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'No ${_data.trx_number}',
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
      'Bill Type: $type',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.line();
    //Item
    for (var _data in listCart) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: _data.name ?? "-",
          width: 22,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: _data.unit ?? "UNIT",
          width: 8,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "${StringExt.thousandFormatter(_data.sell_price)}",
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "x",
          width: 1,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: _data.qty!.toString(),
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
            _data.sell_price! * _data.qty!,
          )}",
          width: 14,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    }
    await SunmiPrinter.line();
    if (calculateDiscount() > 0) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: "Total",
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
          text: "Discount",
          width: 14,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "- ${StringExt.formatRupiah(calculateDiscount())}",
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
          text: StringExt.formatRupiah(getTotalCartAfterDiscount()),
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
          text: StringExt.formatRupiah(getTotalCart()),
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
        text: StringExt.formatRupiah(
          getAdminTax(getTotalCartAfterDiscount()),
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
          getServiceTax(getTotalCartAfterDiscount()),
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
    await SunmiPrinter.resetBold();
    await SunmiPrinter.lineWrap(1);
    // await SunmiPrinter.printText(
    //   'Items that have been purchased',
    //   style: SunmiStyle(
    //     fontSize: SunmiFontSize.MD,
    //     bold: false,
    //     align: SunmiPrintAlign.CENTER,
    //   ),
    // );
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

  printBill(AddTransactionData _data) async {
    await _base.getProfile();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.bindingPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.bold();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Order No: ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "200 / 1",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Customer: ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Zulfi",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    //Item
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setFontSize(SunmiFontSize.LG);
    for (var _data in listCart) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: _data.name ?? "-",
          width: 15,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "x${_data.qty!.toString()}",
          width: 4,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    }
    await SunmiPrinter.resetBold();
    await SunmiPrinter.resetFontSize();
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'No: ${_data.trx_number}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
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
    await SunmiPrinter.lineWrap(4);
    await SunmiPrinter.cut();
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.exitTransactionPrint(true);
  }

  printBillThermal(AddTransactionData _data) async {
    await _base.getProfile();
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final printer = PrinterNetworkManager(_base.printerLink.value);
    PosPrintResult connect = await printer.connect();

    if (connect == PosPrintResult.success) {
      await generator.row([
        PosColumn(
          text: "Order No: ",
          width: 3,
          styles: const PosStyles(align: PosAlign.left, underline: false),
        ),
        PosColumn(
          text: "200 / 1",
          width: 9,
          styles: const PosStyles(align: PosAlign.left, underline: false),
        ),
      ]);
      await generator.row([
        PosColumn(
          text: "Customer: ",
          width: 3,
          styles: const PosStyles(align: PosAlign.left, underline: false),
        ),
        PosColumn(
          text: "Zulfi",
          width: 9,
          styles: const PosStyles(align: PosAlign.left, underline: false),
        ),
      ]);
      //Item
      await generator.feed(1);
      for (var _data in listCart) {
        await generator.row([
          PosColumn(
            text: _data.name ?? "-",
            width: 8,
            styles: PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            ),
          ),
          PosColumn(
            text: "x${_data.qty!.toString()}",
            width: 4,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            ),
          ),
        ]);
      }
      await generator.feed(1);
      await generator.text(
        'No: ${_data.trx_number}',
        styles: PosStyles(
          align: PosAlign.left,
        ),
      );
      await generator.text(
        'Trx Date: ${DateExt.reformat(DateTime.now().toString(), "yyyy-MM-dd HH:mm", "dd MMM yyyy (HH:mm)")}',
        styles: PosStyles(
          align: PosAlign.left,
        ),
      );
      await generator.text(
        'Cashier: ${_base.dataProfile.value.full_name}',
        styles: PosStyles(
          align: PosAlign.left,
        ),
      );
      await generator.text(
        'Table Name: ${_data.table_name}',
        styles: PosStyles(
          align: PosAlign.left,
        ),
      );
      await generator.feed(4);
      await generator.cut();
      printer.disconnect();
    } else {
      CToast.showWithoutCOntext(
        "No printer found, check your printer thermal link in profile page",
        Colors.red,
        Colors.white,
      );
    }
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }
}
