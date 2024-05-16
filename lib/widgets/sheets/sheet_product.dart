import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customButton.dart';

import '../../../controllers/theme/theme_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../pages/transaction/order.dart';
import '../card/cart_cart.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SheetProduct extends StatefulWidget {
  SheetProduct({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetProduct> createState() => _SheetProductState();
}

class _SheetProductState extends State<SheetProduct> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ProductController _productController =
      Get.find(tag: 'ProductController');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: _theme.backgroundApp.value,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DraggableBottomSheet(),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => CText(
                          "Your Cart",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _theme.textTitle.value,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => ListView.separated(
                          itemCount: _productController.listCart
                              .where((e) => e.qty! > 0)
                              .length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: CDimension.space12,
                              ),
                              child: CDivider(
                                height: 1,
                              ),
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            var _filtered = _productController.listCart
                                .where((e) => e.qty! > 0)
                                .toList();
                            var _data = _filtered[index];
                            return CartCard(
                              cart: _data,
                              onAdd: () {
                                _productController.increaseCart(_data);
                              },
                              onDelete: () {
                                _productController.decreaseCart(_data);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: CDimension.space128,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space16,
                  vertical: CDimension.space12,
                ),
                color: Colors.white,
                child: Obx(
                  () => CustomButtonBlue(
                    "Pay - ${StringExt.formatRupiah(
                      _productController.getTotalCart(),
                    )}",
                    width: OtherExt().getWidth(context) - CDimension.space32,
                    onPressed: () {
                      Get.off(OrderPage());
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
