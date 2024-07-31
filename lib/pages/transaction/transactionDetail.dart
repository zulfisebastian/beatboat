import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/controllers/transaction/transaction_detail_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/card/transaction_detail_card.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/customAppBar.dart';

class TransactionDetailPage extends StatefulWidget {
  final String transId;
  const TransactionDetailPage({
    Key? key,
    required this.transId,
  }) : super(key: key);

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final TransactionDetailController _trans = Get.put(
      TransactionDetailController(),
      tag: "TransactionDetailController");

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _trans.getTransactionDetail(widget.transId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "DETAIL",
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // _balanceController.checkBalance(widget.nfcUid);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space20,
            vertical: CDimension.space24,
          ),
          child: Column(
            children: [
              Container(
                width: OtherExt().getWidth(context),
                decoration: BoxDecoration(
                  color: _theme.success.value,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/json/success.json',
                      width: 120,
                      repeat: false,
                    ),
                    CText(
                      "Transaction Success",
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: CDimension.space12,
                    ),
                    Obx(
                      () => CText(
                        StringExt.thousandFormatter(
                            _trans.transactionData.value.subtotal ?? 0),
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: CDimension.space24,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              Obx(
                () => _trans.transactionData.value.details != null
                    ? _trans.transactionData.value.details!.length > 0
                        ? Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CText(
                                  "Detail",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _theme.textTitle.value,
                                ),
                                SizedBox(
                                  height: CDimension.space20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText(
                                      "Transaction Number",
                                      fontSize: 16,
                                      color: _theme.textSubtitle.value,
                                    ),
                                    CText(
                                      _trans.transactionData.value.number,
                                      fontSize: 16,
                                      color: _theme.textTitle.value,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: CDimension.space16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText(
                                      "Transaction Date",
                                      fontSize: 16,
                                      color: _theme.textSubtitle.value,
                                    ),
                                    CText(
                                      DateExt.reformat(
                                        _trans
                                            .transactionData.value.created_at!,
                                        "yyyy-MM-ddTHH:mm:ss",
                                        "dd MMM yyyy, HH:mm",
                                      ),
                                      fontSize: 16,
                                      color: _theme.textTitle.value,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: CDimension.space16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText(
                                      "Table Name",
                                      fontSize: 16,
                                      color: _theme.textSubtitle.value,
                                    ),
                                    CText(
                                      _trans.transactionData.value.table_name,
                                      fontSize: 16,
                                      color: _theme.textTitle.value,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: CDimension.space16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText(
                                      "Customer Name",
                                      fontSize: 16,
                                      color: _theme.textSubtitle.value,
                                    ),
                                    CText(
                                      _trans
                                          .transactionData.value.customer_name!,
                                      fontSize: 16,
                                      color: _theme.textTitle.value,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: CDimension.space16,
                                ),
                                SizedBox(
                                  height: CDimension.space12,
                                ),
                                CDivider(height: 1),
                                SizedBox(
                                  height: CDimension.space12,
                                ),
                                CText(
                                  "Product",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _theme.textTitle.value,
                                ),
                                SizedBox(
                                  height: CDimension.space20,
                                ),
                                ListView.separated(
                                  itemCount: _trans
                                      .transactionData.value.details!.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(height: CDimension.space8);
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var _data = _trans
                                        .transactionData.value.details![index];
                                    return TransactionDetailCard(data: _data);
                                  },
                                ),
                              ],
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButtonBorderBlack(
                      "Print Struct",
                      onPressed: () {
                        _trans.printStruck(_trans.transactionData.value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: CDimension.space12,
                  ),
                  Expanded(
                    child: CustomButtonBlue(
                      "Print Bar",
                      onPressed: () {
                        _trans.printBillThermal(_trans.transactionData.value);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
