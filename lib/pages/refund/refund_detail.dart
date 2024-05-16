import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/constants/size.dart';
import 'package:beatboat/widgets/components/ccached_image.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:beatboat/widgets/sheets/sheet_refund.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/refund/refund_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customButton.dart';

class RefundDetailPage extends StatefulWidget {
  const RefundDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RefundDetailPage> createState() => _RefundDetailPageState();
}

class _RefundDetailPageState extends State<RefundDetailPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final RefundController _refundController = Get.find(
    tag: "RefundController",
  );

  getIconTransaction(data) {
    if (data.payment_method!.toLowerCase() == "split_bill") {
      return "ic_split_bill";
    } else {
      return "ic_sales";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundAppOther.value,
      appBar: CustomAppBar(
        context: context,
        title: "Transaction Refund",
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
          child: Obx(
            () => CustomButtonBlue(
              "SETUP REFUND",
              disabled: _refundController.choosedProduct.length == 0,
              onPressed: () {
                Get.bottomSheet(
                  SheetRefund(),
                  isScrollControlled: true,
                );
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: CDimension.space16,
          vertical: CDimension.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => _refundController.choosedTransaction.value.id != null
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: CDimension.space20,
                        vertical: CDimension.space16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          CDimension.space16,
                        ),
                        color: _theme.backgroundApp.value,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CText(
                            DateExt.reformat(
                              _refundController.choosedTransaction.value.date!,
                              "yyyy-MM-DD",
                              "EEEE, d MMM yyyy",
                            ),
                            color: _theme.textSubtitle.value,
                            fontSize: CFontSize.font12,
                          ),
                          SizedBox(
                            height: CDimension.space12,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/${getIconTransaction(_refundController.choosedTransaction.value)}.svg",
                                color: _theme.accent.value,
                                width: CDimension.space24,
                              ),
                              SizedBox(
                                width: CDimension.space12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CText(
                                      _refundController.choosedTransaction.value
                                                  .payment_method!
                                                  .toLowerCase() ==
                                              "split_bill"
                                          ? "Transaction Split Bill"
                                          : "Transaction",
                                      color: _theme.textTitle.value,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: CDimension.space8,
                                    ),
                                    CText(
                                      _refundController
                                          .choosedTransaction.value.number,
                                      color: _theme.textSubtitle.value,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: CDimension.space16,
                          ),
                          CDivider(height: 1),
                          SizedBox(
                            height: CDimension.space16,
                          ),
                          ListView.separated(
                            itemCount: _refundController
                                .choosedTransaction.value.details!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: CDimension.space12,
                                  horizontal: CDimension.space8,
                                ),
                                child: CDivider(height: 1),
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              var _detail = _refundController
                                  .choosedTransaction.value.details![index];
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: CDimension.space4,
                                          ),
                                          CText(
                                            _detail
                                                .product!.name!.capitalizeFirst,
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
                                    Obx(
                                      () => _refundController.choosedProduct
                                                  .indexWhere((e) =>
                                                      e.id == _detail.id) ==
                                              -1
                                          ? CustomButtonBlue(
                                              "Select",
                                              onPressed: () {
                                                _refundController
                                                    .addProduct(_detail);
                                              },
                                            )
                                          : CustomButtonRed(
                                              "Unselect",
                                              onPressed: () {
                                                _refundController.removeProduct(
                                                  _refundController
                                                      .choosedProduct
                                                      .indexWhere((e) =>
                                                          e.id == _detail.id),
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: CDimension.space16,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(
              height: CDimension.space128,
            ),
          ],
        ),
      ),
    );
  }
}
