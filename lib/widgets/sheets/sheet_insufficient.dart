import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../pages/balance/topup.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetInsufficient extends StatelessWidget {
  final String uid;
  final int nominal;

  SheetInsufficient({
    Key? key,
    required this.uid,
    required this.nominal,
  }) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DraggableBottomSheet(),
              Lottie.asset(
                'assets/json/sad.json',
                width: 240,
              ),
              SizedBox(
                height: CDimension.space4,
              ),
              CText(
                "The user's balance is insufficient to complete this transaction. Your payment is short by ${StringExt.formatRupiah(nominal)}.",
                fontSize: 16,
                lineHeight: 1.5,
                align: TextAlign.center,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              CustomButtonBlue(
                "Top Up Now",
                width: OtherExt().getWidth(context),
                onPressed: () {
                  Get.off(TopUpPage(
                    nfcUid: uid,
                    nominal: nominal,
                    from: "Transaction",
                  ));
                },
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
