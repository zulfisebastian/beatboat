import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/controllers/activity/activity_byid_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../components/customButton.dart';
import '../components/customInputForm.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetRefundTopup extends StatefulWidget {
  SheetRefundTopup({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetRefundTopup> createState() => _SheetRefundTopupState();
}

class _SheetRefundTopupState extends State<SheetRefundTopup> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ActivityByIdController _activity =
      Get.find(tag: 'ActivityByIdController');

  @override
  void dispose() {
    _activity.amount.value.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.3,
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
                  "Top Up Refund",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                CustomInputForm(
                  textEditingController: _activity.amount.value,
                  hintText: "Input Amount",
                  errorMessage: "",
                  keyboardType: TextInputType.number,
                  onChanged: (v) {},
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                CustomButtonBlue(
                  "Refund Now",
                  width: OtherExt().getWidth(context),
                  onPressed: () {
                    _activity.refundTransaction();
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
