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
  final TransactionController _trxCtrl =
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
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow(
                title: CText(
                  "Sub Total",
                  color: _theme.textTitle.value,
                  fontSize: 14,
                ),
                value: Obx(
                  () => CText(
                    StringExt.formatRupiah(_trxCtrl.getTotalCart()),
                    color: _theme.textTitle.value,
                    fontSize: 16,
                  ),
                ),
              ),
              if ((_base.dataFee.value.tax ?? 0) > 0)
                _buildSummaryRow(
                  title: Obx(
                    () => CText(
                      _trxCtrl.listCart.any((e) => e.is_free_tax == 1)
                          ? "Tax (Free)"
                          : "Tax (${_base.dataFee.value.tax}%)",
                      color: _theme.textTitle.value,
                      fontSize: 14,
                    ),
                  ),
                  value: Obx(() => CText(
                        "+ ${StringExt.formatRupiah(_trxCtrl.getAdminTax(_trxCtrl.getTotalCartAfterDiscount()))}",
                        color: _theme.error.value,
                        fontSize: 14,
                      )),
                ),
              if ((_base.dataFee.value.service_tax ?? 0) > 0)
                _buildSummaryRow(
                  title: Obx(
                    () => CText(
                      _trxCtrl.listCart.any((e) => e.is_free_tax == 1)
                          ? "Service Fee (Free)"
                          : "Service Fee (${_base.dataFee.value.service_tax}%)",
                      color: _theme.textTitle.value,
                      fontSize: 14,
                    ),
                  ),
                  value: Obx(
                    () => CText(
                      "+ ${StringExt.formatRupiah(_trxCtrl.getServiceTax(_trxCtrl.getTotalCartAfterDiscount()))}",
                      color: _theme.error.value,
                      fontSize: 14,
                    ),
                  ),
                ),
              _buildSummaryRow(
                title: CText(
                  "Total Payment",
                  color: _theme.textTitle.value,
                  fontSize: 14,
                ),
                value: Obx(() => CText(
                      StringExt.formatRupiah(_trxCtrl.getTotalAfterPPNCart()),
                      color: _theme.accent.value,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox(height: 4),
              CustomButtonBlue(
                "Pay",
                width: OtherExt().getWidth(context),
                onPressed: () async {
                  await _base.initNFC();
                  Get.bottomSheet(
                    _base.nfcIsAvailable.value == NFCAvailability.available
                        ? SheetNFC(type: NFCModeType.Pay)
                        : SheetNoNFC(onTap: () {
                            Get.back();
                            _base.initNFC();
                          }),
                    isScrollControlled: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _trxCtrl.initAllData();
        },
        child: SingleChildScrollView(
          controller: _trxCtrl.scrollController,
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

  /// Helper widget for summary rows
  Widget _buildSummaryRow({
    required Widget title,
    required Widget value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        title,
        value,
      ],
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
            itemCount: _trxCtrl.listCart.where((e) => e.qty! > 0).length,
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
                  _trxCtrl.listCart.where((e) => e.qty! > 0).toList();
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
