import 'package:beatboat/controllers/base/base_controller.dart';
import 'package:beatboat/widgets/card/order_cart.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/sheets/sheet_nfc.dart';
import 'package:beatboat/widgets/sheets/sheet_no_nfc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/enums.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/transaction/transaction_controller.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/cdivider.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/text/ctext.dart';
import '../../widgets/sheets/sheet_cart.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');
  final TransactionController _transController =
      Get.put(TransactionController(), tag: 'TransactionController');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Order Summary",
      ),
      bottomSheet: Material(
        elevation: 20,
        child: Container(
          width: OtherExt().getWidth(context),
          padding: EdgeInsets.all(
            CDimension.space16,
          ),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                        _transController.getTotalCart(),
                      ),
                      color: _theme.textTitle.value,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space6,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     CText(
              //       "Discount",
              //       color: _theme.textTitle.value,
              //       fontSize: 14,
              //     ),
              //     Obx(
              //       () => CText(
              //         "- " +
              //             StringExt.formatRupiah(
              //               _transController.calculateDiscount(),
              //             ),
              //         color: _theme.success.value,
              //         fontSize: 14,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: CDimension.space6,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    "Admin Fee (10%)",
                    color: _theme.textTitle.value,
                    fontSize: 14,
                  ),
                  Obx(
                    () => CText(
                      "+ " +
                          StringExt.formatRupiah(_transController.getAdminTax(
                            _transController.getTotalCartAfterDiscount(),
                          )),
                      color: _theme.error.value,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    "Service Fee (8%)",
                    color: _theme.textTitle.value,
                    fontSize: 14,
                  ),
                  Obx(
                    () => CText(
                      "+ " +
                          StringExt.formatRupiah(_transController.getServiceTax(
                            _transController.getTotalCartAfterDiscount(),
                          )),
                      color: _theme.error.value,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    "Total Payment",
                    color: _theme.textTitle.value,
                    fontSize: 14,
                  ),
                  Obx(
                    () => CText(
                      StringExt.formatRupiah(
                        _transController.getTotalAfterPPNCart(),
                        // _transController.getTotalCart(),
                      ),
                      color: _theme.accent.value,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CustomButtonBlue(
                "Pay",
                width: OtherExt().getWidth(context),
                onPressed: () async {
                  await _base.initNFC();
                  if (_base.nfcIsAvailable.value == NFCAvailability.available) {
                    Get.bottomSheet(
                      SheetNFC(
                        type: NFCModeType.Pay,
                      ),
                      isScrollControlled: true,
                    );
                  } else {
                    Get.bottomSheet(
                      SheetNoNFC(onTap: () {
                        Get.back();
                        _base.initNFC();
                      }),
                      isScrollControlled: true,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _transController.initAllData();
        },
        child: SingleChildScrollView(
          controller: _transController.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: CDimension.space16,
              ),
              OrderSummary(),
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget OrderSummary() {
    return Column(
      children: [
        Container(
          width: OtherExt().getWidth(context),
          margin: EdgeInsets.symmetric(
            horizontal: CDimension.space16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CText(
                "Items",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _theme.textTitle.value,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.bottomSheet(
                    SheetCart(),
                    isScrollControlled: true,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: CText(
                  "Edit items",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _theme.link.value,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: CDimension.space16,
        ),
        Obx(
          () => ListView.separated(
            itemCount:
                _transController.listCart.where((e) => e.qty! > 0).length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: CDimension.space12,
                ),
                child: CDivider(
                  height: 1,
                ),
              );
            },
            itemBuilder: (BuildContext context, int index) {
              var _filtered =
                  _transController.listCart.where((e) => e.qty! > 0).toList();
              var _data = _filtered[index];
              return OrderCard(cart: _data);
            },
          ),
        ),
        SizedBox(
          height: CDimension.space12,
        ),
        CDivider(
          height: 1,
        ),
        SizedBox(
          height: CDimension.space12,
        ),
      ],
    );
  }
}
