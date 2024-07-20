import 'package:beatboat/widgets/sheets/sheet_product_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:get/get.dart';
import '../../models/balance/balance_model.dart';
import '../../models/package/package_model.dart';
import '../../models/product/addon_model.dart';
import '../../models/product/cart_package_model.dart';
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

  Rx<TextEditingController> noteCtrl = TextEditingController().obs;

  @override
  void onReady() {
    super.onReady();
  }

  Rx<BalanceData> balance = BalanceData().obs;

  RxList<PackageData> listPackage = <PackageData>[].obs;
  RxList<CartPackageData> listCart = <CartPackageData>[].obs;
  RxList<AddonData> listAddons = <AddonData>[].obs;

  getDataPackage() async {
    var _resp = await _packageRepo.getPackage(balance.value.nfc_uid);

    if (_resp.data != null) {
      listPackage.value = _resp.data!;
      listPackage.refresh();
    }
  }

  servePackage() async {
    Get.dialog(Loading());
    var body = [];

    body = listCart
        .map(
          (e) => {
            "addon_id": e.addon_uid,
            "serve_qty": e.qty,
            "note": e.note,
            "addons": listAddons
                .where((_data) => _data.cart_id == e.id)
                .map(
                  (_addon) => {
                    "id": _addon.addon_id,
                    "qty": _addon.qty,
                  },
                )
                .toList(),
          },
        )
        .toList();

    var _resp = await _packageRepo.addPackage(body, balance.value.nfc_uid);
    Get.back();

    if (_resp.code != null) {
      printBillThermal();
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

  printBillThermal() async {
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
        for (var _cart in listCart) {
          if (_printer.value == _cart.order_serve) {
            bytes += generator.row(
              [
                PosColumn(
                  text: _cart.name ?? "-",
                  width: 8,
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: PosTextSize.size2,
                    width: PosTextSize.size2,
                  ),
                ),
                PosColumn(
                  text: "x${_cart.qty.toString()}",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.right,
                    height: PosTextSize.size2,
                    width: PosTextSize.size2,
                  ),
                ),
              ],
            );
            if (listAddons.indexWhere((e) => e.cart_id == _cart.id) > -1) {
              bytes += generator.text(
                'AddOn: ${listAddons.where((e) => e.cart_id == _cart.id && e.product_id == _cart.product_id).map((e) => "x${e.qty} ${e.name!.capitalizeFirst}").join(", ")}',
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              );
            }
            if (_cart.note != null) {
              bytes += generator.text(
                'Note: ${_cart.note!}',
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              );
            }
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

  addPackageToCart(PackageData _product) async {
    CartPackageData _cart = new CartPackageData();
    _cart.id = DateTime.now().toString();
    _cart.product_id = _product.id;
    _cart.category_id = _product.category_id;
    _cart.sku = _product.sku;
    _cart.name = _product.name;
    _cart.description = _product.description;
    _cart.buy_price = _product.buy_price;
    _cart.sell_price = _product.sell_price;
    _cart.stock = _product.stock;
    _cart.status = _product.status;
    _cart.order_serve = _product.order_serve;
    _cart.serve_qty = _product.serve_qty;
    _cart.unit = _product.unit;
    _cart.image_url = _product.image_url;
    _cart.note = "";
    _cart.addon_uid = _product.addon_uid;
    _cart.qty = 1;
    _cart.addon_title =
        _product.addons != null ? _product.addons!.text : "AddOn";
    _cart.min_selection =
        _product.addons != null ? _product.addons!.min_selection : 0;
    _cart.qty = 1;

    listCart.add(_cart);

    Get.bottomSheet(
      SheetProductPackage(data: _cart),
      isScrollControlled: true,
    );
  }

  PackageData getProductByProductId(CartPackageData _cart) {
    return listPackage.where((e) => e.id == _cart.product_id).toList().first;
  }

  increaseCart(CartPackageData _cart) async {
    var _index = await listCart.indexWhere((element) => element.id == _cart.id);

    if (_index > -1) {
      if (checkQtyIsEqual(_cart.product_id!)) return;
      listCart[_index].qty = listCart[_index].qty! + 1;
    }
  }

  decreaseCart(CartPackageData _cart) async {
    var _index = await listCart.indexWhere((element) => element.id == _cart.id);

    if (_index > -1) {
      if (listCart[_index].qty! > 1) {
        listCart[_index].qty = listCart[_index].qty! - 1;
      } else {
        listCart.removeAt(_index);
        listCart.refresh();
        Get.back();
      }
    }
  }

  bool checkQtyIsEqual(String id) {
    PackageData _package = listPackage.where((e) => e.id == id).first;

    var totalCurrentQty = 0;
    for (var _data in listCart) {
      if (_data.product_id == id) {
        totalCurrentQty += _data.qty!;
      }
    }

    return _package.serve_qty == totalCurrentQty;
  }

  increaseAddons(PackageAddonDetailData _data, CartPackageData _cart) async {
    var _index = await listCart.indexWhere((element) => element.id == _cart.id);

    if (_index > -1) {
      if (listCart[_index].min_selection! -
              getAddonLength(_data.addon_id!, _cart.id!) ==
          0) {
        Get.bottomSheet(SheetFailed(
          errorMessage: "You cannot add Addon anymore",
        ));
      } else {
        var _indexAddons = await listAddons.indexWhere((element) =>
            element.cart_id == _cart.id && element.addon_id == _data.addon_id);

        if (_indexAddons > -1) {
          listAddons[_indexAddons].qty = listAddons[_indexAddons].qty! + 1;
          listAddons.refresh();
        } else {
          AddonData _addon = new AddonData();
          _addon.id = DateTime.now().toString();
          _addon.addon_id = _data.addon_id;
          _addon.product_id = _data.product_id;
          _addon.cart_id = _cart.id;
          _addon.name = _data.name;
          _addon.price = _data.price;
          _addon.qty = 1;
          listAddons.add(_addon);
        }
      }
    }
  }

  decreaseAddons(PackageAddonDetailData _data, CartPackageData _cart) async {
    var _index = await listAddons.indexWhere((element) =>
        element.cart_id == _cart.id && element.addon_id == _data.addon_id);

    if (_index > -1) {
      if (listAddons[_index].qty! > 1) {
        listAddons[_index].qty = listAddons[_index].qty! - 1;
        listAddons.refresh();
      } else {
        listAddons.removeAt(_index);
        listAddons.refresh();
      }
    }
    listAddons.refresh();
  }

  int getTotalCart() {
    int total = 0;
    for (var data in listCart) {
      total += data.sell_price! * data.qty!;
    }
    return total;
  }

  int getTotalPricePerItem(CartPackageData _cart) {
    var qty = listCart.firstWhere((e) => e.id == _cart.id).qty!;
    int total = 0;
    total += _cart.sell_price!;
    return total * qty;
  }

  editNote(CartPackageData _cart, _note) async {
    var _index = await listCart.indexWhere((element) => element.id == _cart.id);

    if (_index > -1) {
      listCart[_index].note = _note;
      listCart.refresh();
    }
  }

  PackageData getPackageByPackageId(CartPackageData _cart) {
    return listPackage.where((e) => e.id == _cart.product_id).toList().first;
  }

  List<CartPackageData> getAllCartByPackageId(String _product_id) {
    return listCart.where((e) => e.product_id == _product_id).toList();
  }

  CartPackageData getCartByPackageId(String _product_id) {
    return listCart.where((e) => e.product_id == _product_id).toList().first;
  }

  int getAddonQty(String _addon_id, String cart_id) {
    var data = listAddons
        .where((e) => e.addon_id == _addon_id && e.cart_id == cart_id)
        .toList();
    if (data.length > 0) {
      return data[0].qty!;
    } else {
      return 0;
    }
  }

  int getAddonLength(String _addon_id, String cart_id) {
    var data = listAddons.where((e) => e.cart_id == cart_id).toList();
    if (data.length > 0) {
      var total = 0;
      for (var _data in data) {
        total += _data.qty!;
      }
      return total;
    } else {
      return 0;
    }
  }

  int getCartQtyLength(PackageData _data) {
    var total = 0;
    for (var _data in listCart.where((e) => e.product_id == _data.id)) {
      total += _data.qty!;
    }
    return total;
  }

  int getAddonQtyLength(String _addon_id, String cart_id) {
    return listAddons
        .where((e) => e.addon_id == _addon_id && e.cart_id == cart_id)
        .toList()
        .length;
  }

  Rx<PackageData> choosedPackage = PackageData().obs;
}
