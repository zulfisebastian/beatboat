import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/size.dart';
import 'package:beatboat/controllers/refund/refund_controller.dart';
import 'package:beatboat/models/transaction/transaction_model.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SheetRefundQty extends StatefulWidget {
  final int index;
  final DetailTransactionData data;

  SheetRefundQty({
    Key? key,
    required this.index,
    required this.data,
  }) : super(key: key);

  @override
  State<SheetRefundQty> createState() => _SheetRefundQtyState();
}

class _SheetRefundQtyState extends State<SheetRefundQty> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final RefundController _refundController = Get.find(tag: 'RefundController');

  @override
  void initState() {
    super.initState();
  }

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
                "Product Qty",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                lineHeight: 1.5,
                overflow: TextOverflow.visible,
                color: _theme.textTitle.value,
              ),
              SizedBox(
                height: CDimension.space8,
              ),
              CText(
                "Please select the quantity that you want to refund",
                fontSize: 14,
                color: _theme.textSubtitle.value,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              ListView.separated(
                itemCount: widget.data.qty!,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: CDimension.space12,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      _refundController.updateProductQty(
                        widget.index,
                        index + 1,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(CDimension.space8),
                          border: Border.all(
                            width: 1,
                            color: _refundController
                                        .choosedProductQty[widget.index] ==
                                    index + 1
                                ? _theme.accent.value
                                : _theme.line.value,
                          ),
                          color: _refundController
                                      .choosedProductQty[widget.index] ==
                                  index + 1
                              ? _theme.accent.value
                              : Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: CDimension.space16,
                          horizontal: CDimension.space16,
                        ),
                        child: Center(
                          child: CText(
                            index + 1,
                            fontSize: CFontSize.font16,
                            color: _refundController
                                        .choosedProductQty[widget.index] ==
                                    index + 1
                                ? Colors.white
                                : _theme.textTitle.value,
                          ),
                        ),
                      ),
                    ),
                  );
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
