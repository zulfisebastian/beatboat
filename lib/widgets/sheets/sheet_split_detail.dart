import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/transaction/transaction_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetSplitDetail extends StatelessWidget {
  SheetSplitDetail({
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
                "Amount Detail",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                lineHeight: 1.5,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CText(
                        "Total",
                        color: _theme.textTitle.value,
                        fontSize: 14,
                      ),
                      Obx(
                        () => CText(
                          StringExt.formatRupiah(
                            _transactionController.getTotalCart(),
                          ),
                          color: _theme.textTitle.value,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CText(
                        "Discount",
                        color: _theme.textTitle.value,
                        fontSize: 14,
                      ),
                      Obx(
                        () => CText(
                          "- ${StringExt.formatRupiah(
                            _transactionController.calculateDiscount(),
                          )}",
                          color: _theme.accent.value,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CText(
                        "Sub Total",
                        color: _theme.textTitle.value,
                        fontSize: 14,
                      ),
                      Obx(
                        () => CText(
                          StringExt.formatRupiah(
                            _transactionController.getTotalCartAfterDiscount(),
                          ),
                          color: _theme.textTitle.value,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CText(
                        "Tax (10%)",
                        color: _theme.textTitle.value,
                        fontSize: 14,
                      ),
                      Obx(
                        () => CText(
                          StringExt.formatRupiah(
                              _transactionController.getAdminTax(
                            _transactionController.getTotalCartAfterDiscount(),
                          )),
                          color: _theme.textTitle.value,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CText(
                        "Service Tax (8%)",
                        color: _theme.textTitle.value,
                        fontSize: 14,
                      ),
                      Obx(
                        () => CText(
                          StringExt.formatRupiah(
                              _transactionController.getServiceTax(
                            _transactionController.getTotalCartAfterDiscount(),
                          )),
                          color: _theme.textTitle.value,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CText(
                        "Grand Total",
                        color: _theme.textTitle.value,
                        fontSize: 14,
                      ),
                      Obx(
                        () => CText(
                          StringExt.formatRupiah(
                            _transactionController.getTotalAfterPPNCart(),
                          ),
                          color: _theme.accent.value,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
