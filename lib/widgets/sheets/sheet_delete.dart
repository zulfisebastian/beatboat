import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetDelete extends StatelessWidget {
  final VoidCallback onTap;

  SheetDelete({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.22,
      builder: (context, scrollController) {
        return Container(
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
                SizedBox(height: 16),
                Obx(
                  () => CText(
                    "Are you sure want to delete your account?",
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
                        "Cancel",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomButtonRed(
                        "Delete",
                        onPressed: () {
                          onTap();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
