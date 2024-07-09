import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../constants/dimension.dart';
import '../../controllers/product/product_controller.dart';
import '../components/customInputForm.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetNote extends StatelessWidget {
  final Function(String) onEditNote;

  SheetNote({
    Key? key,
    required this.onEditNote,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  final ProductController _productController =
      Get.find(tag: 'ProductController');

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.5,
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
                CText(
                  "Note",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                CustomInputForm(
                  textEditingController: _productController.noteCtrl.value,
                  hintText: "Input Note",
                  errorMessage: "",
                  onChanged: (v) {},
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                CustomButtonBlue(
                  "Save Note",
                  width: OtherExt().getWidth(context),
                  onPressed: () {
                    onEditNote(_productController.noteCtrl.value.text);
                    _productController.noteCtrl.value.text = "";
                    _productController.noteCtrl.refresh();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
