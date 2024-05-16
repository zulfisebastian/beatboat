import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetUpload extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  SheetUpload({
    Key? key,
    required this.onCamera,
    required this.onGallery,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OtherExt().getWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: _theme.backgroundApp.value,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DraggableBottomSheet(),
            SizedBox(height: 16),
            Obx(
              () => CText(
                "Change Photo Profile",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                lineHeight: 1.5,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButtonBorderBlack(
                    "Gallery",
                    rightIcon: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SvgPicture.asset(
                        "assets/icons/ic_gallery.svg",
                        color: _theme.textTitle.value,
                      ),
                    ),
                    onPressed: () {
                      onGallery();
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomButtonBorderBlack(
                    "Camera",
                    rightIcon: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SvgPicture.asset(
                        "assets/icons/ic_camera.svg",
                        color: _theme.textTitle.value,
                      ),
                    ),
                    onPressed: () {
                      onCamera();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
