import 'package:beatboat/models/product/cart_model.dart';
import 'package:beatboat/models/product/category_model.dart';
import 'package:beatboat/repositories/product/product_repo.dart';
import 'package:beatboat/services/databases/transaction/cart_table.dart';
import 'package:get/get.dart';

import '../../models/product/product_model.dart';
import '../../services/databases/product/category_table.dart';
import '../../services/databases/product/product_table.dart';
import '../base/base_controller.dart';

class ProductController extends GetxController {
  final BaseController _base = Get.find(tag: "BaseController");

  final ProductRepo _productRepo = Get.put(ProductRepo());

  RxString choosedCategory = "All".obs;

  @override
  void onReady() {
    super.onReady();
    _base.initConnectivity();
    initAllData();
  }

  initAllData() {
    getDataCategory();
    getDataProduct();
    renewListCart();
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
  getDataProduct() async {
    if (_base.isConnected.value) {
      var _resp = await _productRepo.getProduct();

      if (_resp.data!.length > 0) {
        listProduct.value = _resp.data!.where((e) => e.show! == 1).toList();
        listProduct.refresh();
      }
    } else {
      var _resp = await ProductTable().getAllProduct();

      if (_resp != null) {
        listProduct.value = _resp.where((e) => e.show! == 1).toList();
        listProduct.refresh();
      }
    }
    checkIsCategoryChecked();
  }

  checkIsCategoryChecked() {
    if (choosedCategory.value != "All") {
      getProductByCategory(choosedCategory.value);
    }
  }

  onChooseCategory(String category) {
    choosedCategory.value = category;
    choosedCategory.refresh();
  }

  RxList<ProductData> listProductCategory = <ProductData>[].obs;
  getProductByCategory(String category) {
    onChooseCategory(category);
    listProductCategory.value =
        listProduct.where((e) => e.category_id == category).toList();
    listProductCategory.refresh();
  }

  List<ProductData> getProductAll(String category) {
    return listProduct;
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

  int getTotalCart() {
    int total = 0;
    for (var data in listCart) {
      total += data.sell_price! * data.qty!;
    }
    return total;
  }
}
