import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/ccached_image.dart';
import '../components/text/ctext.dart';

class CategoryCircleCard extends StatelessWidget {
  final VoidCallback onClick;
  final String image_url;
  final String title;
  final double size;
  final double border;
  final bool active;

  CategoryCircleCard({
    Key? key,
    required this.onClick,
    required this.image_url,
    required this.title,
    required this.size,
    required this.border,
    required this.active,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size + border,
        child: Column(
          children: [
            SizedBox(
              width: size + border,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size + border,
                    height: size + border,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? _theme.accent.value : Colors.white,
                    ),
                  ),
                  CCachedImage(
                    width: size,
                    height: size,
                    url: image_url,
                    rounded: size,
                  ),
                ],
              ),
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
