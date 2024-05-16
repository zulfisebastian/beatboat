import 'package:beatboat/controllers/base/base_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../constants/dimension.dart';
import '../components/customInputForm.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetPrinterThermal extends StatefulWidget {
  SheetPrinterThermal({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetPrinterThermal> createState() => _SheetPrinterThermalState();
}

class _SheetPrinterThermalState extends State<SheetPrinterThermal> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');

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
                "Printer Thermal Url",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                lineHeight: 1.5,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CustomInputForm(
                textEditingController: _base.printer.value,
                hintText: "",
                errorMessage: "",
                onChanged: (v) {
                  // _base.changePrinterLink(v);
                },
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CustomButtonBlue(
                "Simpan",
                width: OtherExt().getWidth(context),
                disabled: _base.printer.value.text == "",
                onPressed: () {
                  _base.changePrinterLink();
                },
              ),
              SizedBox(
                height: CDimension.space16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
