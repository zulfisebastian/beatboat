import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/pages/result/failed.dart';
import 'package:beatboat/pages/result/success.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/transaction/transaction_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final TransactionController _transactionCtrl =
      Get.find(tag: 'TransactionController');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: OtherExt().getWidth(context),
          height: OtherExt().getHeight(context),
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: CDimension.space128,
              ),
              CText(
                "Scan your wristband",
                color: _theme.textTitle.value,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CText(
                "Please dont move your wristband until scanning process finished",
                color: _theme.textSubtitle.value,
                overflow: TextOverflow.visible,
                align: TextAlign.center,
                lineHeight: 1.4,
                fontSize: 14,
              ),
              SizedBox(
                height: CDimension.space20,
              ),
              Lottie.asset('assets/json/scanning.json'),
              SizedBox(
                height: CDimension.space24,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButtonBlue(
                      "Success",
                      width: OtherExt().getWidth(context),
                      onPressed: () {
                        Get.to(SuccessPage(
                          title: "Transaction Success",
                          subtitle:
                              "Please wait, the kitchen preparing your orders",
                          action: "",
                          onFinish: () {
                            _transactionCtrl.finishTransaction();
                          },
                        ));
                      },
                    ),
                  ),
                  SizedBox(
                    width: CDimension.space24,
                  ),
                  Expanded(
                    child: CustomButtonRed(
                      "Error",
                      width: OtherExt().getWidth(context),
                      onPressed: () {
                        Get.to(FailedPage(
                          title: "Transaction Failed",
                          subtitle:
                              "Please try again by clicking the button below",
                          onFinish: () {
                            Get.back();
                          },
                        ));
                      },
                    ),
                  ),
                ],
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
