// ignore_for_file: invalid_use_of_protected_member

import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/models/product/cart_model.dart';
import 'package:beatboat/models/product/product_model.dart';
import 'package:beatboat/widgets/components/ccached_image.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customCounter.dart';
import 'package:beatboat/widgets/components/customInputArea.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../utils/extensions.dart';
import '../components/customButton.dart';
import '../components/text/ctext.dart';
import 'sheet_another.dart';

class SheetProduct extends StatefulWidget {
  final CartData data;

  SheetProduct({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SheetProduct> createState() => _SheetProductState();
}

class _SheetProductState extends State<SheetProduct> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ProductController _product = Get.find(tag: 'ProductController');

  @override
  void dispose() {
    super.dispose();
    _product.noteCtrl.value.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.97,
      minChildSize: 0.55,
      maxChildSize: 0.97,
      builder: (context, scrollController) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: _theme.backgroundApp.value,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: _theme.line.value,
                          ),
                        ),
                        child: CCachedImage(
                          width: OtherExt().getWidth(context),
                          height: 240,
                          url: widget.data.image_url ?? Endpoint.defaultFood,
                          rounded: 0,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      SizedBox(
                        height: CDimension.space4,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: CDimension.space16,
                          vertical: CDimension.space16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CText(
                                    widget.data.name!.capitalizeFirst,
                                    color: _theme.textTitle.value,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.visible,
                                    lineHeight: 1.4,
                                  ),
                                ),
                                SizedBox(
                                  width: CDimension.space8,
                                ),
                                CText(
                                  StringExt.formatRupiah(
                                    widget.data.sell_price ?? 0,
                                  ),
                                  color: _theme.textTitle.value,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: CDimension.space12,
                            ),
                            CText(
                              widget.data.description!.capitalizeFirst,
                              color: _theme.textSubtitle.value,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                      //Add Ons
                      SizedBox(
                        child: _product
                                    .getProductByProductId(widget.data)
                                    .addons!
                                    .items!
                                    .length >
                                0
                            ? Column(
                                children: [
                                  CDivider(height: CDimension.space8),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: CDimension.space16,
                                      vertical: CDimension.space16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            CText(
                                              "Addon",
                                              color: _theme.textTitle.value,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: CDimension.space8,
                                            ),
                                            CText(
                                              "Max ${widget.data.min_selection ?? 0} item",
                                              color: _theme.textSubtitle.value,
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: CDimension.space12,
                                        ),
                                        ListView.separated(
                                          itemCount: _product
                                              .getProductByProductId(
                                                  widget.data)
                                              .addons!
                                              .items!
                                              .length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return CDivider(height: 1);
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var _data = _product
                                                .getProductByProductId(
                                                    widget.data)
                                                .addons!
                                                .items![index];
                                            return AddonCard(
                                                data: _data,
                                                theme: _theme,
                                                product: _product,
                                                widget: widget);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),

                      //Notes
                      CDivider(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: CDimension.space16,
                          vertical: CDimension.space16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CText(
                              "Notes",
                              color: _theme.textSubtitle.value,
                              fontSize: 14,
                            ),
                            SizedBox(
                              height: CDimension.space12,
                            ),
                            CustomInputArea(
                              textEditingController: _product.noteCtrl.value,
                              hintText: "Your Notes",
                              errorMessage: "",
                              maxInput: 100,
                              onChanged: (v) {},
                            ),
                          ],
                        ),
                      ),

                      //Qty
                      CDivider(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: CDimension.space16,
                          vertical: CDimension.space16,
                        ),
                        child: Obx(
                          () => CustomCounter(
                            qty: _product.listCart.value
                                .firstWhere((e) => e.id == widget.data.id)
                                .qty!,
                            onDecrease: () {
                              _product.decreaseCart(widget.data);
                              setState(() {});
                            },
                            onIncrease: () {
                              if (!_product
                                  .checkQtyIsEqual(widget.data.product_id!)) {
                                _product.increaseCart(widget.data);
                                setState(() {});
                              }
                            },
                            decreaseBackground: _theme.accent.value,
                            increaseBackground: !_product
                                    .checkQtyIsEqual(widget.data.product_id!)
                                ? _theme.accent.value
                                : _theme.textSubtitle.value,
                            qtyColor: _theme.textTitle.value,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: CDimension.space150,
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
                child: CustomButtonBlue(
                  "Update Cart",
                  width: OtherExt().getWidth(context) - 32,
                  onPressed: () {
                    _product.editNote(
                        widget.data, _product.noteCtrl.value.text);
                    _product.noteCtrl.value.text = "";
                    _product.noteCtrl.refresh();
                    Get.back();
                    Get.bottomSheet(
                      SheetAnother(),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddonCard extends StatelessWidget {
  const AddonCard({
    Key? key,
    required ProductAddonDetailData data,
    required ThemeController theme,
    required ProductController product,
    required this.widget,
  })  : _data = data,
        _theme = theme,
        _product = product,
        super(key: key);

  final ProductAddonDetailData _data;
  final ThemeController _theme;
  final ProductController _product;
  final SheetProduct widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: CDimension.space12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                _data.name!.capitalizeFirst,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space4,
              ),
              CText(
                _data.price != null
                    ? _data.price == 0
                        ? "Free"
                        : StringExt.formatRupiah(_data.price!)
                    : "Free",
                fontSize: 14,
                color: _theme.accent.value,
              ),
            ],
          ),
          Obx(
            () => CustomCounter(
              qty: _product.getAddonQty(_data.addon_id!, widget.data.id!),
              sizeQty: 14,
              onDecrease: () {
                if (_product.getAddonQtyLength(
                        _data.addon_id!, widget.data.id!) >
                    0) {
                  _product.decreaseAddons(
                    _data,
                    widget.data,
                  );
                }
              },
              onIncrease: () {
                if (widget.data.min_selection! -
                        _product.getAddonLength(
                            _data.addon_id!, widget.data.id!) !=
                    0) {
                  _product.increaseAddons(_data, widget.data);
                }
              },
              decreaseBackground:
                  _product.getAddonQtyLength(_data.addon_id!, widget.data.id!) >
                          0
                      ? _theme.accent.value
                      : _theme.textSubtitle.value,
              increaseBackground: widget.data.min_selection! -
                          _product.getAddonLength(
                              _data.addon_id!, widget.data.id!) !=
                      0
                  ? _theme.accent.value
                  : _theme.textSubtitle.value,
              qtyColor: _theme.textTitle.value,
              sizeIcon: CDimension.space32,
            ),
          ),
        ],
      ),
    );
  }
}
