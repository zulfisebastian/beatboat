import 'package:beatboat/widgets/card/package_card.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:beatboat/widgets/sheets/sheet_cart_package.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../constants/dimension.dart';
import '../../controllers/package/package_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customButton.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final PackageController _package = Get.find(
    tag: "PackageController",
  );

  @override
  void dispose() {
    Get.delete<PackageController>(
      tag: "PackageController",
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Package",
      ),
      bottomSheet: Material(
        elevation: 20,
        child: Obx(
          () => _package.listCart.length > 0
              ? GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      SheetCartPackage(),
                      isScrollControlled: true,
                    );
                  },
                  child: Container(
                    width: OtherExt().getWidth(context) - CDimension.space32,
                    height: 56,
                    margin: EdgeInsets.only(
                      left: CDimension.space16,
                      right: CDimension.space16,
                      bottom: CDimension.space16,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: CDimension.space24,
                      vertical: CDimension.space12,
                    ),
                    decoration: BoxDecoration(
                      color: _theme.accent.value,
                      borderRadius: BorderRadius.circular(
                        CDimension.space48,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                          "${_package.listCart.length} item",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        CText(
                          StringExt.formatRupiah(
                            _package.getTotalCart(),
                          ),
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => _package.listPackage.length > 0
              ? Container(
                  child: ListView.separated(
                    itemCount: _package.listPackage.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: CDimension.space4,
                        ),
                        child: CDivider(height: 1),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var _data = _package.listPackage[index];
                      return PackageCard(
                        data: _data,
                        index: index,
                      );
                    },
                  ),
                )
              : Container(
                  width: OtherExt().getWidth(context),
                  padding: const EdgeInsets.all(
                    CDimension.space16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/json/sad.json',
                        width: 240,
                      ),
                      Container(
                        child: CText(
                          "No Package Data",
                          color: _theme.textTitle.value,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
