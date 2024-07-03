import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/package/package_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../models/package/package_model.dart';
import '../../utils/extensions.dart';
import '../components/ccached_image.dart';
import '../components/text/ctext.dart';

class CardPackage extends StatelessWidget {
  final PackageData data;

  CardPackage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  final PackageController _packageController = Get.find(
    tag: "PackageController",
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.white,
        width: OtherExt().getWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(
              data.name,
              color: Colors.white,
              fontSize: 12,
            ),
            SizedBox(
              height: CDimension.space12,
            ),
            CCachedImage(
              width: OtherExt().getWidth(context),
              height: 160,
              url: data.image_url!,
            ),
            SizedBox(
              width: CDimension.space16,
            ),
          ],
        ),
      ),
    );
  }
}
