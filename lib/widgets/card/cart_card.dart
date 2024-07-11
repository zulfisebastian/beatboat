import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/controllers/product/product_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/sheets/sheet_note.dart';
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
  final Function(String) onEditNote;
  final CartData cart;

  CartCard({
    Key? key,
    required this.onAdd,
    required this.onDelete,
    required this.onEditNote,
    required this.cart,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ProductController _productController =
      Get.find(tag: 'ProductController');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OtherExt().getWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: _theme.line.value,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CCachedImage(
                  width: 80,
                  height: 80,
                  url: cart.image_url ?? Endpoint.defaultFood,
                ),
              ),
              SizedBox(
                width: CDimension.space16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CText(
                      cart.name!.capitalizeFirst,
                      color: _theme.textTitle.value,
                      fontSize: 14,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                    Obx(
                      () => _productController.listAddons
                                  .where((e) =>
                                      e.cart_id == cart.id &&
                                      e.product_id == cart.product_id)
                                  .length >
                              0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: CDimension.space6,
                              ),
                              child: CText(
                                _productController.listAddons
                                    .where((e) =>
                                        e.cart_id == cart.id &&
                                        e.product_id == cart.product_id)
                                    .map((e) =>
                                        "x${e.qty} ${e.name!.capitalizeFirst}")
                                    .join(", "),
                                fontSize: 12,
                                color: _theme.textSubtitle.value,
                                overflow: TextOverflow.visible,
                                lineHeight: 1.4,
                              ),
                            )
                          : SizedBox(
                              height: CDimension.space12,
                            ),
                    ),
                    Row(
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
                                              .firstWhere(
                                                  (e) => e.id == cart.id)
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
                  ],
                ),
              ),
              SizedBox(
                width: CDimension.space16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                    height: CDimension.space6,
                  ),
                  Row(
                    children: [
                      CText(
                        "+ ${StringExt.formatRupiah(
                          _productController.getTotalAddonPricePerItem(cart),
                        )}",
                        color: _theme.error.value,
                        fontSize: 12,
                      ),
                      CText(
                        " / item",
                        color: _theme.textSubtitle.value,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: CDimension.space12,
          ),
          GestureDetector(
            onTap: () {
              _productController.noteCtrl.value.text = cart.note ?? "";
              Get.bottomSheet(
                SheetNote(onEditNote: onEditNote),
                isScrollControlled: true,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: _theme.line.value,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: CDimension.space8,
                vertical: CDimension.space4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cart.note != "" ? Icons.edit : Icons.edit_note,
                    color: _theme.textSubtitle.value,
                    size: 14,
                  ),
                  SizedBox(
                    width: CDimension.space8,
                  ),
                  CText(
                    cart.note != "" ? cart.note! : "Input Your Note",
                    color: cart.note != ""
                        ? _theme.textTitle.value
                        : _theme.textSubtitle.value,
                    overflow: TextOverflow.visible,
                    fontSize: 12,
                    fontWeight: cart.note != "" ? FontWeight.bold : null,
                    lineHeight: 1.4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
