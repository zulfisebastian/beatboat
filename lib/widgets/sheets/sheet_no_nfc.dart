import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetNoNFC extends StatefulWidget {
  final VoidCallback onTap;

  SheetNoNFC({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SheetNoNFC> createState() => _SheetNoNFCState();
}

class _SheetNoNFCState extends State<SheetNoNFC> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
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
            children: <Widget>[
              DraggableBottomSheet(),
              SizedBox(
                height: CDimension.space16,
              ),
              CText(
                "Something When Wrong!",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                lineHeight: 1.5,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CText(
                "Sorry, but you have to turn on the NFC reader feature.",
                fontSize: 14,
                lineHeight: 1.5,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              CustomButtonBorderBlack(
                "Try Again",
                width: OtherExt().getWidth(context),
                onPressed: () {
                  widget.onTap();
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
