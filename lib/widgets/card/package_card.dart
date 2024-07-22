import 'package:beatboat/widgets/sheets/sheet_another_package.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/endpoints.dart';
import '../../controllers/package/package_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../models/package/package_model.dart';
import '../../utils/extensions.dart';
import '../components/ccached_image.dart';
import '../components/text/ctext.dart';

class PackageCard extends StatelessWidget {
  final PackageData data;
  final int index;

  PackageCard({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final PackageController _package = Get.find(
    tag: "PackageController",
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_package.listCart.where((e) => e.product_id == data.id).length >
            0) {
          _package.choosedPackage.value = data;
          _package.choosedPackage.refresh();

          Get.bottomSheet(
            SheetAnotherPackage(),
            isScrollControlled: true,
          );
        } else {
          _package.choosedPackage.value = data;
          _package.choosedPackage.refresh();
          _package.addPackageToCart(data);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
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
                      url: data.image_url ?? Endpoint.defaultFood,
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
                        data.serve_qty.toString(),
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
                    data.name!.capitalizeFirst,
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
                    (data.description ?? "-").capitalizeFirst,
                    color: _theme.textTitle.value,
                    fontSize: 12,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  // Obx(
                  //   () => _package.list.length > 0
                  //       ? CustomCounter(
                  //           qty: _package.listQty[index],
                  //           onDecrease: () {
                  //             _package.decreaseQty(index);
                  //           },
                  //           onIncrease: () {
                  //             _package.increaseQty(index);
                  //           },
                  //           decreaseBackground: _package.listQty[index] > 0
                  //               ? _theme.accent.value
                  //               : _theme.textSubtitle.value,
                  //           increaseBackground: _package.listQty[index] <
                  //                   _package.listPackage[index].serve_qty!
                  //               ? _theme.accent.value
                  //               : _theme.textSubtitle.value,
                  //           qtyColor: _theme.textTitle.value,
                  //           sizeIcon: CDimension.space28,
                  //           sizeQty: 14,
                  //         )
                  //       : SizedBox(),
                  // ),
                ],
              ),
            ),
            SizedBox(
              width: CDimension.space16,
            ),
            Row(
              children: [
                CText(
                  StringExt.thousandFormatter(data.sell_price!),
                  color: _theme.textTitle.value,
                  fontWeight: FontWeight.bold,
                ),
                CText(
                  " / item",
                  color: _theme.textSubtitle.value,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
