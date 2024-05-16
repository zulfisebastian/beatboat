import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/components/customInputForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/transaction/transaction_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetVoucher extends StatelessWidget {
  SheetVoucher({
    Key? key,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final TransactionController _transactionController =
      Get.find(tag: 'TransactionController');

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
              CText(
                "Voucher Code",
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
                textEditingController: _transactionController.voucher.value,
                hintText: "",
                errorMessage: "",
                onChanged: (v) {
                  //
                },
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Obx(
                () => CustomButtonBlue(
                  "Claim Voucher",
                  width: OtherExt().getWidth(context),
                  disabled: _transactionController.voucher.value.text == "",
                  onPressed: () {
                    _transactionController.checkVoucher();
                  },
                ),
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
