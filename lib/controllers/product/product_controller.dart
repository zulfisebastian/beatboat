import 'dart:async';

import 'package:beatboat/models/product/addon_model.dart';
import 'package:beatboat/models/product/cart_model.dart';
import 'package:beatboat/models/product/category_model.dart';
import 'package:beatboat/repositories/product/product_repo.dart';
import 'package:beatboat/services/databases/transaction/addon_table.dart';
import 'package:beatboat/services/databases/transaction/cart_table.dart';
import 'package:beatboat/widgets/pages/loading.dart';
import 'package:beatboat/widgets/sheets/sheet_failed.dart';
import 'package:beatboat/widgets/sheets/sheet_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../models/product/product_model.dart';
import '../../services/databases/product/category_table.dart';
import '../../widgets/components/ctoast.dart';
import '../base/base_controller.dart';

class ProductController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");
  final scrollController = ScrollController();
  Rx<TextEditingController> search = TextEditingController().obs;

  final ProductRepo _productRepo = Get.put(ProductRepo());

  RxString choosedCategory = "All".obs;

  @override
  void onReady() {
    super.onReady();
    _base.initConnectivity();
    scrollController.addListener(scrollControllerListener);
  }

  bool isLoading = false;
  RxBool isLoadMoreData = false.obs;
  RxInt page = 0.obs;
  RxInt totalPage = 1.obs;

  RxBool showBottomBar = true.obs;

  void scrollControllerListener() async {
    if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels &&
        !isLoading &&
        page.value < totalPage.value) {
      isLoading = true;
      isLoadMoreData.value = true;
      getDataProduct(true);
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (showBottomBar.value != false) {
        showBottomBar.value = false;
        showBottomBar.refresh();
      }
    } else {
      if (showBottomBar.value != true) {
        showBottomBar.value = true;
        showBottomBar.refresh();
      }
    }
  }

  Timer? _debounce;
  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      page.value = 0;
      totalPage.value = 1;
      print("SEARCH TRIGGERED");
      getDataProduct(false);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  initAllData() {
    getDataCategory();
    renewListCart();
    renewListAddOn();
  }

  RxList<CategoryData> listCategory = <CategoryData>[].obs;
  getDataCategory() async {
    if (_base.isConnected.value) {
      var _resp = await _productRepo.getCategory();

      if (_resp.data!.length > 0) {
        listCategory.value = _resp.data!;
        listCategory.refresh();
      }
    } else {
      var _resp = await CategoryTable().getAllCategory();

      if (_resp != null) {
        listCategory.value = _resp;
        listCategory.refresh();
      }
    }
  }

  RxList<ProductData> listProduct = <ProductData>[].obs;
  getDataProduct([bool isMore = false]) async {
    var body = {
      "per_page": 10,
      "page": page.value + 1,
      "search": search.value.text,
    };

    if (choosedCategory.value != "All")
      body["category_id"] = choosedCategory.value;

    var _resp = await _productRepo.getProduct(body);

    if (_resp.data!.data != null) {
      if (isMore) {
        listProduct.addAll(_resp.data!.data!.where((e) => e.show! == 1));
      } else {
        listProduct.value =
            _resp.data!.data!.where((e) => e.show! == 1).toList();
      }

      page.value = _resp.data!.current_page!;
      totalPage.value = _resp.data!.last_page!;
      isLoadMoreData.value = false;
      isLoading = false;
      listProduct.refresh();
    }
  }

  onChooseCategory(String category) {
    choosedCategory.value = category;
    choosedCategory.refresh();

    page.value = 0;
    totalPage.value = 1;
    getDataProduct(false);
  }

  onSubmitFilter(String category) {
    choosedCategory.value = category;
    choosedCategory.refresh();

    page.value = 0;
    totalPage.value = 1;
    getDataProduct(false);
    Get.back();
  }

  RxList<CartData> listCart = <CartData>[].obs;
  renewListCart() async {
    var _resp = await CartTable().getAllCart();
    if (_resp != null) {
      listCart.value = _resp;
      listCart.refresh();
    }
  }

  RxList<AddonData> listAddons = <AddonData>[].obs;
  renewListAddOn() async {
    var _resp = await AddonTable().getAllData();
    listAddons.clear();
    if (_resp != null) {
      listAddons.value = _resp;
    }
    listAddons.refresh();
  }

  addProductToCart(ProductData _product) async {
    CartData _cart = new CartData();
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
    _cart.unit = _product.unit;
    _cart.image_url = _product.image_url;
    _cart.note = "";
    _cart.qty = 1;
    _cart.min_selection =
        _product.addons != null ? _product.addons!.min_selection : 0;
    _cart.qty = 1;
    CartTable().addCart(_cart);
    await renewListCart();
    Get.bottomSheet(
      SheetProduct(data: _cart),
      isScrollControlled: true,
    );
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
        renewListCart();
      } else {
        CartTable().deleteCart(_cart);
        if (listCart.length > 1) {
          renewListCart();
          Get.back();
        } else {
          Get.back();
          listCart.clear();
          listCart.refresh();
        }
      }
    } else {
      CartTable().deleteCart(_cart);
      renewListCart();
    }
  }

  bool checkQtyIsEqual(String id) {
    ProductData _product = listProduct.where((e) => e.id == id).first;

    var totalCurrentQty = 0;
    for (var _data in listCart) {
      if (_data.product_id == id) {
        totalCurrentQty += _data.qty!;
      }
    }

    return _product.stock == totalCurrentQty;
  }

  increaseAddons(ProductAddonDetailData _data, CartData _cart) async {
    var _resp = await CartTable().getCartById(_cart);

    if (_resp != null) {
      if (_resp[0].min_selection! -
              getAddonLength(_data.addon_id!, _cart.id!) ==
          0) {
        Get.bottomSheet(SheetFailed(
          errorMessage: "You cannot add Add-ons anymore",
        ));
      } else {
        var _searchAddon =
            await AddonTable().getAddonByCartId(_data.addon_id!, _cart);

        if (_searchAddon != null) {
          _searchAddon[0].qty = _searchAddon[0].qty! + 1;
          AddonTable().updateAddon(_searchAddon[0], _cart);
        } else {
          AddonData _addon = new AddonData();
          _addon.id = DateTime.now().toString();
          _addon.addon_id = _data.addon_id;
          _addon.product_id = _data.product_id;
          _addon.cart_id = _cart.id;
          _addon.name = _data.name;
          _addon.price = _data.price;
          _addon.qty = 1;
          _addon.counter = _data.counter;
          AddonTable().addAddon(_addon);
        }
      }
    }
    renewListAddOn();
  }

  decreaseAddons(ProductAddonDetailData _data, CartData _cart) async {
    var _resp = await AddonTable().getAddonByCartId(_data.addon_id!, _cart);

    if (_resp != null) {
      if (_resp[0].qty! > 1) {
        _resp[0].qty = _resp[0].qty! - 1;
        AddonTable().updateAddon(_resp[0], _cart);
      } else {
        AddonTable().deleteAddon(_resp[0]);
      }
    }
    await renewListAddOn();
  }

  int getTotalCart() {
    int total = 0;
    for (var data in listCart) {
      int totalAddon = 0;
      for (var addon in listAddons.where((e) => e.cart_id == data.id)) {
        totalAddon += addon.price! * addon.qty!;
      }
      total += (data.sell_price! + totalAddon) * data.qty!;
    }
    return total;
  }

  int getTotalPricePerItem(CartData _cart) {
    var qty = listCart.firstWhere((e) => e.id == _cart.id).qty!;
    int total = 0;
    total += _cart.sell_price!;
    for (var data in listAddons.where((e) => e.cart_id == _cart.id)) {
      total += data.price! * data.qty!;
    }
    return total * qty;
  }

  int getTotalAddonPricePerItem(CartData _cart) {
    int total = 0;
    for (var data in listAddons.where((e) => e.cart_id == _cart.id)) {
      total += data.price! * data.qty!;
    }
    return total;
  }

  Rx<TextEditingController> noteCtrl = TextEditingController().obs;
  editNote(CartData _cart, _note) async {
    var _resp = await CartTable().getCartById(_cart);

    if (_resp != null) {
      _cart.note = _note;
      CartTable().updateCart(_cart);
    }
    renewListCart();
  }

  ProductData getProductByProductId(CartData _cart) {
    return listProduct.where((e) => e.id == _cart.product_id).toList().first;
  }

  List<CartData> getAllCartByProductId(String _product_id) {
    return listCart.where((e) => e.product_id == _product_id).toList();
  }

  CartData getCartByProductId(String _product_id) {
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
        total += (_data.qty! * _data.counter!);
      }
      return total;
    } else {
      return 0;
    }
  }

  int getCartQtyLength(ProductData _data) {
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

  checkIfCanIncrease(ProductAddonDetailData _addon, CartData _cart) {
    var remainderQty =
        _cart.min_selection! - getAddonLength(_addon.addon_id!, _cart.id!);
    if (remainderQty != 0) {
      if (_addon.counter! <= remainderQty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Rx<ProductData> choosedProduct = ProductData().obs;

  Rx<TextEditingController> stock = TextEditingController().obs;
  RxBool fromStockNull = false.obs;
  adjustStock() async {
    Get.dialog(
      Loading(),
    );
    var body = {
      "sku": choosedProduct.value.sku,
      "stock": stock.value.text,
    };

    var _resp = await _productRepo.postAdjustStock(body);
    Get.back();

    if (_resp.code != null) {
      stock.value.text = "";
      page.value = 0;
      totalPage.value = 1;
      getDataProduct(false);
      if (fromStockNull.value) {
        fromStockNull.value = false;
        choosedProduct.value = ProductData();
        Get.back();
      } else {
        Get.back();
        Get.back();
      }
    } else {
      CToast.showWithoutCOntext(
        "Stock Adjust Failed",
        Colors.red,
        Colors.white,
      );
    }
  }
}
