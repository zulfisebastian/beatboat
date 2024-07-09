import 'package:beatboat/widgets/card/package_card.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final PackageController _refundController = Get.find(
    tag: "PackageController",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Wristband Package",
      ),
      bottomSheet: Material(
        elevation: 20,
        child: Container(
          width: OtherExt().getWidth(context),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space16,
            vertical: CDimension.space12,
          ),
          child: CustomButtonBlue(
            "SERVE NOW",
            disabled: false,
            onPressed: () {
              _refundController.servePackage();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => _refundController.listPackage.length > 0
              ? Container(
                  child: ListView.separated(
                    itemCount: _refundController.listPackage.length,
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
                      var _data = _refundController.listPackage[index];
                      return PackageCard(
                        data: _data,
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(
                    CDimension.space16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
