import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:get/get.dart';
import '../../models/balance/balance_model.dart';
import '../../models/package/package_model.dart';
import '../../models/transaction/add_transaction_model.dart';
import '../../pages/home/home.dart';
import '../../pages/result/success.dart';
import '../../repositories/package/package_repo.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/ctoast.dart';
import '../../widgets/pages/loading.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../base/base_controller.dart';
import '../home/home_controller.dart';

class PackageController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");
  final PackageRepo _packageRepo = Get.put(PackageRepo());

  @override
  void onReady() {
    super.onReady();
  }

  Rx<BalanceData> balance = BalanceData().obs;

  RxList<PackageData> listPackage = <PackageData>[].obs;
  RxList<int> listQty = <int>[].obs;
  increaseQty(int index) {
    if (listQty[index] == listPackage[index].serve_qty) return;
    listQty[index]++;
    listQty.refresh();
  }

  decreaseQty(int index) {
    if (listQty[index] == 0) return;
    listQty[index]--;
    listQty.refresh();
  }

  getDataPackage() async {
    var _resp = await _packageRepo.getPackage(balance.value.nfc_uid);

    if (_resp.data != null) {
      listPackage.value = _resp.data!;
      listPackage.refresh();
      for (var _ in listPackage) {
        listQty.add(0);
      }
    }
  }

  servePackage() async {
    Get.dialog(Loading());
    var body = [];

    for (var i = 0; i < listPackage.length; i++) {
      body.add({
        "addon_id": listPackage[i].addon_uid,
        "serve_qty": listQty[i],
      });
    }

    var _resp = await _packageRepo.addPackage(body, balance.value.nfc_uid);
    Get.back();

    if (_resp.code != null) {
      printBillThermal(_resp.data!);
      Get.to(SuccessPage(
        title: "Served Successfully",
        subtitle: "Thank you, and please wait until your package delivered",
        action: "Done Serving!",
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

  printBillThermal(AddTransactionData _data) async {
    await _base.getProfile();
    for (var _printer in _base.printerThermal) {
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
            text: "N/A",
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
            text: balance.value.customer_name ?? "N/A",
            width: 9,
            styles: const PosStyles(align: PosAlign.left, underline: false),
          ),
        ]);
        //Item
        bytes += generator.feed(1);
        for (var _data in listPackage) {
          if (_printer.value == _data.order_serve) {
            bytes += generator.row([
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
                text: "x${_data.serve_qty!.toString()}",
                width: 4,
                styles: PosStyles(
                  align: PosAlign.right,
                  height: PosTextSize.size2,
                  width: PosTextSize.size2,
                ),
              ),
            ]);
          }
        }
        bytes += generator.feed(1);
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
          'Table Name: ${balance.value.table_name}',
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
    }
  }
}
