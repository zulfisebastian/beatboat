import 'package:beatboat/widgets/components/customButton.dart';
import 'package:get/get.dart';
import 'package:beatboat/constants/dimension.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../components/text/ctext.dart';

class SheetTopupOption extends StatefulWidget {
  final VoidCallback onCash;
  final VoidCallback onEDC;

  SheetTopupOption({
    Key? key,
    required this.onCash,
    required this.onEDC,
  }) : super(key: key);

  @override
  State<SheetTopupOption> createState() => _SheetTopupOptionState();
}

class _SheetTopupOptionState extends State<SheetTopupOption> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  void initState() {
    super.initState();
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DraggableBottomSheet(),
              SizedBox(
                height: CDimension.space16,
              ),
              Obx(
                () => CText(
                  "Choose Payment Option",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButtonBlue(
                      "EDC",
                      onPressed: () async {
                        widget.onEDC();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: CustomButtonBlue(
                      "CASH",
                      onPressed: () async {
                        widget.onCash();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
