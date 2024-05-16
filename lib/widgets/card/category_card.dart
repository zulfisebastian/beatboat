import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/ccached_image.dart';
import '../components/text/ctext.dart';

class CategoryCard extends StatelessWidget {
  final VoidCallback onClick;
  final String image_url;
  final String title;
  final double size;

  CategoryCard({
    Key? key,
    required this.onClick,
    required this.image_url,
    required this.title,
    required this.size,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        child: Column(
          children: [
            CCachedImage(
              width: size,
              height: size,
              url: image_url,
            ),
            SizedBox(
              height: CDimension.space8,
            ),
            CText(
              title.capitalizeFirst,
              color: _theme.textTitle.value,
              fontSize: 14,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
