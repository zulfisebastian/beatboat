import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/enums.dart';
import 'package:beatboat/constants/size.dart';
import 'package:beatboat/controllers/refund/refund_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/sheets/sheet_nfc.dart';
import 'package:beatboat/widgets/sheets/sheet_reason.dart';
import 'package:beatboat/widgets/sheets/sheet_refund_qty.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../constants/endpoints.dart';
import '../components/ccached_image.dart';
import '../components/cdivider.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../popups/confirmation.dart';

class SheetRefund extends StatefulWidget {
  SheetRefund({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetRefund> createState() => _SheetRefundState();
}

class _SheetRefundState extends State<SheetRefund> {
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
                "Product",
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
                "Set the quantity of the product",
                fontSize: 14,
                color: _theme.textSubtitle.value,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              ListView.separated(
                itemCount: _refundController.choosedProduct.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: CDimension.space12,
                      horizontal: CDimension.space8,
                    ),
                    child: CDivider(height: 1),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  var _detail = _refundController.choosedProduct[index];
                  return Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CCachedImage(
                          width: CDimension.space64,
                          height: CDimension.space64,
                          url: _detail.product!.image_url ??
                              Endpoint.defaultFood,
                        ),
                        SizedBox(
                          width: CDimension.space12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: CDimension.space4,
                              ),
                              CText(
                                _detail.product!.name!.capitalizeFirst,
                                color: _theme.textTitle.value,
                              ),
                              SizedBox(
                                height: CDimension.space8,
                              ),
                              CText(
                                StringExt.formatRupiah(
                                  _detail.product!.sell_price,
                                ),
                                color: _theme.accent.value,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: CDimension.space12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              SheetRefundQty(
                                index: index,
                                data: _detail,
                              ),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(CDimension.space8),
                              border: Border.all(
                                width: 1,
                                color: _theme.line.value,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: CDimension.space12,
                              horizontal: CDimension.space16,
                            ),
                            child: Obx(
                              () => CText(
                                "Qty - ${_refundController.choosedProductQty[index]}",
                                color: _theme.textTitle.value,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: CDimension.space28,
              ),
              CText(
                "Reason",
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
                "Please tell us why you want to refund?",
                fontSize: 14,
                color: _theme.textSubtitle.value,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Get.bottomSheet(
                    SheetReason(
                      data: _refundController.listReason,
                      choosed: _refundController.choosedReason.value,
                      onChoose: (v) {
                        Get.back();
                        _refundController.choosedReason.value = v;
                      },
                    ),
                    isScrollControlled: true,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: CDimension.space16,
                    vertical: CDimension.space12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: _theme.line.value,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => CText(
                          _refundController.choosedReason.value == ""
                              ? "Your Reason"
                              : _refundController.choosedReason.value,
                          fontSize: CFontSize.font14,
                          color: _refundController.choosedReason.value == ""
                              ? _theme.textSubtitle.value
                              : _theme.textTitle.value,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: CDimension.space48,
              ),
              Obx(
                () => CustomButtonBlue(
                  "REFUND NOW",
                  width: OtherExt().getWidth(context),
                  disabled: _refundController.isSheetRefundDisabled.value,
                  onPressed: () {
                    Get.dialog(
                      Confirmation(
                        title: "Warning!",
                        subtitle: "Are you sure want to refund?",
                        onOk: () {
                          Get.back();
                          Get.bottomSheet(
                            SheetNFC(
                              type: NFCModeType.Refund,
                            ),
                          );
                        },
                      ),
                    );
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
