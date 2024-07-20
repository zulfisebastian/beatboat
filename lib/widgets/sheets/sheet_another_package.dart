import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/sheets/sheet_product_package.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../controllers/package/package_controller.dart';
import '../../utils/extensions.dart';
import '../card/order_package_cart.dart';
import '../components/customButton.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetAnotherPackage extends StatefulWidget {
  SheetAnotherPackage({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetAnotherPackage> createState() => _SheetAnotherPackageState();
}

class _SheetAnotherPackageState extends State<SheetAnotherPackage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final PackageController _package = Get.find(tag: 'PackageController');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.96,
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
                      CText(
                        _package.choosedPackage.value.name!.capitalizeFirst,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _theme.textTitle.value,
                      ),
                      SizedBox(
                        height: CDimension.space16,
                      ),
                      Obx(
                        () => ListView.separated(
                          itemCount: _package
                              .getAllCartByPackageId(
                                _package.choosedPackage.value.id!,
                              )
                              .length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: CDimension.space12,
                              ),
                              child: CDivider(height: 1),
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            var _data = _package.getAllCartByPackageId(
                                _package.choosedPackage.value.id!)[index];
                            return GestureDetector(
                              onTap: () {
                                Get.back();
                                _package.noteCtrl.value.text = _data.note ?? "";
                                Get.bottomSheet(
                                  SheetProductPackage(data: _data),
                                  isScrollControlled: true,
                                );
                              },
                              child: OrderPackageCard(
                                cart: _data,
                              ),
                            );
                          },
                        ),
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
                    "Make Another Order",
                    width: OtherExt().getWidth(context) - 32,
                    disabled: _package
                        .checkQtyIsEqual(_package.choosedPackage.value.id!),
                    onPressed: () {
                      Get.back();
                      _package.addPackageToCart(
                        _package.choosedPackage.value,
                      );
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
