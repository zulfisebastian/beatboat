import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/controllers/product/product_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../models/product/cart_model.dart';
import '../components/ccached_image.dart';
import '../components/text/ctext.dart';

class CartCard extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final CartData cart;

  CartCard({
    Key? key,
    required this.onAdd,
    required this.onDelete,
    required this.cart,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ProductController _productController =
      Get.find(tag: 'ProductController');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OtherExt().getWidth(context),
      child: Row(
        children: [
          CCachedImage(
            width: 80,
            height: 80,
            url: cart.image_url ?? Endpoint.defaultFood,
          ),
          SizedBox(
            width: CDimension.space16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                cart.name!.capitalizeFirst,
                color: _theme.textTitle.value,
                fontSize: 14,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
              SizedBox(
                height: CDimension.space12,
              ),
              Row(
                children: [
                  CText(
                    StringExt.formatRupiah(cart.sell_price!),
                    color: _theme.textTitle.value,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  CText(
                    " / item",
                    color: _theme.textSubtitle.value,
                    fontSize: 12,
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space12,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onDelete();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: CDimension.space28,
                        height: CDimension.space28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _theme.accent.value,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: CDimension.space20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: CDimension.space8,
                      ),
                      child: CText(
                        _productController.listCart
                            .firstWhere((e) => e.id == cart.id)
                            .qty,
                        color: _theme.textTitle.value,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (cart.stock! -
                                _productController.listCart
                                    .firstWhere((e) => e.id == cart.id)
                                    .qty! !=
                            0) {
                          onAdd();
                        } else {
                          print("HABIIISS");
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: CDimension.space28,
                        height: CDimension.space28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cart.stock! -
                                      _productController.listCart
                                          .firstWhere((e) => e.id == cart.id)
                                          .qty! !=
                                  0
                              ? _theme.accent.value
                              : _theme.textSubtitle.value,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: CDimension.space20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
