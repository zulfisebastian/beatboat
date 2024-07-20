import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/widgets/components/ccached_image.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customCounter.dart';
import 'package:beatboat/widgets/components/customInputArea.dart';
import 'package:beatboat/widgets/sheets/sheet_another_package.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../controllers/package/package_controller.dart';
import '../../models/package/package_model.dart';
import '../../models/product/cart_package_model.dart';
import '../../utils/extensions.dart';
import '../components/customButton.dart';
import '../components/text/ctext.dart';

class SheetProductPackage extends StatefulWidget {
  final CartPackageData data;

  SheetProductPackage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SheetProductPackage> createState() => _SheetProductPackageState();
}

class _SheetProductPackageState extends State<SheetProductPackage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final PackageController _package = Get.find(tag: 'PackageController');

  @override
  void dispose() {
    super.dispose();
    _package.noteCtrl.value.text = "";
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
                        child: _package
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
                                              widget.data.addon_title,
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
                                          itemCount: _package
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
                                            var _data = _package
                                                .getProductByProductId(
                                                    widget.data)
                                                .addons!
                                                .items![index];
                                            return AddonCard(
                                                data: _data,
                                                theme: _theme,
                                                product: _package,
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
                              textEditingController: _package.noteCtrl.value,
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
                        child: CustomCounter(
                          qty: _package.listCart
                              .firstWhere((e) => e.id == widget.data.id)
                              .qty!,
                          onDecrease: () {
                            _package.decreaseCart(widget.data);
                            setState(() {});
                          },
                          onIncrease: () {
                            if (widget.data.stock! -
                                    _package.listCart
                                        .firstWhere(
                                            (e) => e.id == widget.data.id)
                                        .qty! !=
                                0) {
                              _package.increaseCart(widget.data);
                              setState(() {});
                            }
                          },
                          decreaseBackground: _theme.accent.value,
                          increaseBackground:
                              !_package.checkQtyIsEqual(widget.data.product_id!)
                                  ? _theme.accent.value
                                  : _theme.textSubtitle.value,
                          qtyColor: _theme.textTitle.value,
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
                    _package.editNote(
                        widget.data, _package.noteCtrl.value.text);
                    _package.noteCtrl.value.text = "";
                    _package.noteCtrl.refresh();
                    Get.back();
                    Get.bottomSheet(
                      SheetAnotherPackage(),
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
    required PackageAddonDetailData data,
    required ThemeController theme,
    required PackageController product,
    required this.widget,
  })  : _data = data,
        _theme = theme,
        _package = product,
        super(key: key);

  final PackageAddonDetailData _data;
  final ThemeController _theme;
  final PackageController _package;
  final SheetProductPackage widget;

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
              qty: _package.getAddonQty(_data.addon_id!, widget.data.id!),
              sizeQty: 14,
              onDecrease: () {
                if (_package.getAddonQtyLength(
                        _data.addon_id!, widget.data.id!) >
                    0) {
                  _package.decreaseAddons(
                    _data,
                    widget.data,
                  );
                }
              },
              onIncrease: () {
                if (widget.data.min_selection! -
                        _package.getAddonLength(
                            _data.addon_id!, widget.data.id!) !=
                    0) {
                  _package.increaseAddons(_data, widget.data);
                }
              },
              decreaseBackground:
                  _package.getAddonQtyLength(_data.addon_id!, widget.data.id!) >
                          0
                      ? _theme.accent.value
                      : _theme.textSubtitle.value,
              increaseBackground: widget.data.min_selection! -
                          _package.getAddonLength(
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
