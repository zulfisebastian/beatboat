import 'package:beatboat/constants/size.dart';
import 'package:beatboat/controllers/base/base_controller.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/popups/confirmation.dart';
import 'package:beatboat/widgets/sheets/sheet_voucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/balance/balance_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/transaction/transaction_controller.dart';
import '../../utils/extensions.dart';
import '../../utils/helpers.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/text/ctext.dart';

class TransactionPage extends StatefulWidget {
  final String nfcUid;

  const TransactionPage({
    Key? key,
    required this.nfcUid,
  }) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');
  final TransactionController _trxCtrl = Get.find(tag: 'TransactionController');
  final BalanceController _balanceController = Get.put(
    BalanceController(),
    tag: 'BalanceController',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _trxCtrl.uid.value = widget.nfcUid;
    });
    checkBalance();
  }

  checkBalance() async {
    await _balanceController.checkBalance(widget.nfcUid);
    if (_balanceController.balance.value.voucher_code != null) {
      _trxCtrl.voucher.value.text =
          _balanceController.balance.value.voucher_code!;
      _trxCtrl.checkVoucher();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Order",
      ),
      bottomSheet: Material(
        elevation: 20,
        child: Container(
          width: OtherExt().getWidth(context),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space16,
            vertical: CDimension.space12,
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomButtonBorderBlack(
                  "SPLIT BILL",
                  onPressed: () {
                    _trxCtrl.goToSplitBill(
                      _balanceController.balance.value,
                    );
                  },
                ),
              ),
              SizedBox(
                width: CDimension.space12,
              ),
              Expanded(
                child: CustomButtonBlue(
                  "PAY",
                  onPressed: () {
                    Get.dialog(
                      Confirmation(
                        title: "Warning!",
                        subtitle: "Are you sure want to pay now?",
                        onOk: () {
                          _trxCtrl.payStandAlone();
                        },
                      ),
                    );
                  },
                ),
              ),
              // SizedBox(
              //   width: CDimension.space12,
              // ),
              // Expanded(
              //   child: CustomButtonBlue(
              //     "PRINT",
              //     onPressed: () {
              //       _trxCtrl.printStruck(
              //         AddTransactionData(
              //           trx_number: "SLS-202403002",
              //           total_amount: 240000,
              //         ),
              //         "Stand Alone",
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _balanceController.checkBalance(widget.nfcUid);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: _theme.backgroundAppOther.value,
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space16,
                  vertical: CDimension.space16,
                ),
                child: Obx(
                  () => Container(
                    width: OtherExt().getWidth(context),
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: getLinearGradient(
                        _balanceController.balance.value.type ?? "",
                      ),
                      borderRadius: BorderRadius.circular(
                        CDimension.space16,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: CDimension.space24,
                      vertical: CDimension.space16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          "Balance",
                          fontSize: 11,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: CDimension.space8,
                        ),
                        Obx(
                          () => CText(
                            StringExt.formatRupiah(
                              _balanceController.balance.value.last_balance ??
                                  0,
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Obx(
                          () => CText(
                            StringExt.hideMiddleCode(
                              _balanceController.balance.value.wristband_code ??
                                  "",
                            ),
                            spacing: 4,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: CDimension.space8,
                        ),
                        Obx(
                          () => CText(
                            _balanceController.balance.value.customer_name ??
                                "",
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                width: OtherExt().getWidth(context),
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space24,
                  vertical: CDimension.space16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText(
                      "Items",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _theme.textTitle.value,
                    ),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CText(
                            "Product",
                            fontSize: 12,
                            color: _theme.textSubtitle.value,
                          ),
                        ),
                        SizedBox(
                          width: CDimension.space40,
                          child: CText(
                            "Qty",
                            fontSize: 12,
                            color: _theme.textSubtitle.value,
                          ),
                        ),
                        SizedBox(
                          width: CDimension.space80,
                          child: CText(
                            "Amount",
                            fontSize: 12,
                            align: TextAlign.end,
                            color: _theme.textSubtitle.value,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: CDimension.space8,
                    ),
                    CDivider(height: 0.5),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    ListView.separated(
                      itemCount: _trxCtrl.listCart.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: CDimension.space12,
                          ),
                          child: CDivider(height: 0.5),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        var _item = _trxCtrl.listCart[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// LEFT SIDE (Product Info)
                            Expanded(
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Product Name
                                  CText(
                                    _item.name?.capitalizeFirst ?? "-",
                                    color: _theme.textTitle.value,
                                  ),

                                  /// Addons (if any)
                                  Builder(builder: (_) {
                                    final addons = _trxCtrl.listAddons.where(
                                      (e) =>
                                          e.cart_id == _item.id &&
                                          e.product_id == _item.product_id,
                                    );
                                    if (addons.isEmpty)
                                      return SizedBox.shrink();
                                    return CText(
                                      addons
                                          .map((e) =>
                                              "x${e.qty} ${e.name?.capitalizeFirst ?? ''}")
                                          .join(", "),
                                      fontSize: 12,
                                      color: _theme.textSubtitle.value,
                                      overflow: TextOverflow.visible,
                                      lineHeight: 1.4,
                                    );
                                  }),

                                  /// Note (if any)
                                  if ((_item.note?.isNotEmpty ?? false))
                                    CText(
                                      _item.note!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _theme.textTitle.value,
                                      overflow: TextOverflow.visible,
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(width: CDimension.space12),

                            /// Quantity
                            SizedBox(
                              width: CDimension.space40,
                              child: CText(
                                "x ${_item.qty}",
                                fontSize: 14,
                                color: _theme.textTitle.value,
                              ),
                            ),

                            /// Total Price per Item
                            SizedBox(
                              width: CDimension.space80,
                              child: CText(
                                StringExt.thousandFormatter(
                                  _trxCtrl.getTotalPricePerItem(_item),
                                ),
                                fontSize: 14,
                                align: TextAlign.end,
                                color: _theme.textTitle.value,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    CDivider(
                      height: 1,
                    ),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    Obx(() {
                      final discount = _trxCtrl.calculateDiscount();
                      final hasDiscount = discount > 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Total Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CText(
                                "Total",
                                color: _theme.textTitle.value,
                                fontSize: 14,
                              ),
                              CText(
                                StringExt.formatRupiah(
                                  _trxCtrl.getTotalCart(),
                                ),
                                color: _theme.textTitle.value,
                                fontSize: 16,
                              ),
                            ],
                          ),
                          SizedBox(height: CDimension.space16),

                          /// Discount (only if > 0)
                          if (hasDiscount) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CText(
                                  "Discount",
                                  color: _theme.textTitle.value,
                                  fontSize: 14,
                                ),
                                CText(
                                  "- ${StringExt.formatRupiah(discount)}",
                                  color: _theme.accent.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                            SizedBox(height: CDimension.space16),

                            /// Subtotal after discount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CText(
                                  "Sub Total",
                                  color: _theme.textTitle.value,
                                  fontSize: 14,
                                ),
                                CText(
                                  StringExt.formatRupiah(
                                    _trxCtrl.getTotalCartAfterDiscount(),
                                  ),
                                  color: _theme.textTitle.value,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                            SizedBox(height: CDimension.space16),
                          ],
                        ],
                      );
                    }),
                    Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_base.dataFee.value.tax! > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CText(
                                _trxCtrl.listCart.any((e) => e.is_free_tax == 1)
                                    ? "Tax (Free)"
                                    : "Tax (${_base.dataFee.value.tax}%)",
                                color: _theme.textTitle.value,
                                fontSize: 14,
                              ),
                              Obx(
                                () => CText(
                                  StringExt.formatRupiah(_trxCtrl.getAdminTax(
                                    _trxCtrl.getTotalCartAfterDiscount(),
                                  )),
                                  color: _theme.textTitle.value,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        if (_base.dataFee.value.service_tax! > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CText(
                                _trxCtrl.listCart.any((e) => e.is_free_tax == 1)
                                    ? "Service Tax (Free)"
                                    : "Service Tax (${_base.dataFee.value.service_tax}%)",
                                color: _theme.textTitle.value,
                                fontSize: 14,
                              ),
                              Obx(
                                () => CText(
                                  StringExt.formatRupiah(_trxCtrl.getServiceTax(
                                    _trxCtrl.getTotalCartAfterDiscount(),
                                  )),
                                  color: _theme.textTitle.value,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                              _trxCtrl.getTotalAfterPPNCart(),
                            ),
                            color: _theme.accent.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: CDimension.space24,
                    ),
                    CDivider(height: 0.5),
                    SizedBox(
                      height: CDimension.space24,
                    ),
                    CText(
                      "Vouchers",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _theme.textTitle.value,
                    ),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    Obx(
                      () => _trxCtrl.voucherData.value.voucher_code != null
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: _theme.line.value,
                                ),
                                borderRadius: BorderRadius.circular(
                                  CDimension.space8,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: CDimension.space16,
                                vertical: CDimension.space12,
                              ),
                              child: Row(
                                children: [
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_voucher.svg",
                                    ),
                                  ),
                                  SizedBox(
                                    width: CDimension.space12,
                                  ),
                                  Expanded(
                                    child: CText(
                                      "Voucher Applied",
                                      color: _theme.accent.value,
                                      fontSize: CFontSize.font14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: CDimension.space12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.dialog(Confirmation(
                                        title: "Warning!",
                                        subtitle:
                                            "Are you sure want to unclaim this voucher?",
                                        onOk: () {
                                          Get.back();
                                          _trxCtrl.removeVoucher();
                                        },
                                      ));
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Get.bottomSheet(SheetVoucher());
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: _theme.line.value,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    CDimension.space8,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: CDimension.space16,
                                  vertical: CDimension.space8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText(
                                      "Add Voucher",
                                      color: _theme.textTitle.value,
                                    ),
                                    Icon(
                                      Icons.add,
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    SizedBox(
                      height: CDimension.space128,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
