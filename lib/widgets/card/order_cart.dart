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

class OrderCard extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final CartData cart;

  OrderCard({
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
      padding: EdgeInsets.only(
        left: CDimension.space16,
        right: CDimension.space16,
        top: CDimension.space8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: CCachedImage(
                    width: 56,
                    height: 56,
                    url: cart.image_url ?? Endpoint.defaultFood,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: CDimension.space20,
                  height: CDimension.space20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _theme.accent.value,
                  ),
                  child: Center(
                    child: CText(
                      _productController.listCart
                          .firstWhere((e) => e.id == cart.id)
                          .qty,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: CDimension.space16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  cart.name!.capitalizeFirst,
                  color: _theme.accent.value,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(
                  height: CDimension.space8,
                ),
                CText(
                  (cart.description ?? "-").capitalizeFirst,
                  color: _theme.textTitle.value,
                  fontSize: 12,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
          SizedBox(
            width: CDimension.space16,
          ),
          CText(
            StringExt.formatRupiah(cart.sell_price! * cart.qty!),
            color: _theme.textTitle.value,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
