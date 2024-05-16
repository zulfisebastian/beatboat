import 'package:beatboat/pages/refund/refund_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/refund/refund_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../models/transaction/transaction_model.dart';
import '../../utils/extensions.dart';
import '../components/ccached_image.dart';
import '../components/text/ctext.dart';

class CardTransaction extends StatelessWidget {
  final TransactionData data;

  CardTransaction({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  getIconTransaction() {
    if (data.payment_method!.toLowerCase() == "split_bill") {
      return "ic_split_bill";
    } else {
      return "ic_sales";
    }
  }

  final RefundController _refundController = Get.find(
    tag: "RefundController",
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.refunds!.length == 0) {
          _refundController.choosedTransaction.value = data;
          _refundController.choosedTransaction.refresh();
          Get.to(RefundDetailPage());
        }
      },
      behavior: HitTestBehavior.opaque,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          data.refunds!.length == 0 ? Colors.transparent : Colors.grey,
          BlendMode.saturation,
        ),
        child: Container(
          color: data.refunds!.length == 0 ? Colors.transparent : Colors.blue,
          width: OtherExt().getWidth(context),
          padding: EdgeInsets.symmetric(
            vertical: CDimension.space16,
            horizontal: CDimension.space16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                DateExt.reformat(
                  data.date!,
                  "yyyy-MM-DD",
                  "EEEE, d MMM yyyy",
                ),
                color: data.refunds!.length == 0
                    ? _theme.textSubtitle.value
                    : Colors.grey,
                fontSize: 12,
              ),
              SizedBox(
                height: CDimension.space12,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/${getIconTransaction()}.svg",
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
                          data.payment_method!.toLowerCase() == "split_bill"
                              ? "Transaction Split Bill"
                              : "Transaction",
                          color: data.refunds!.length == 0
                              ? _theme.textTitle.value
                              : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: CDimension.space8,
                        ),
                        CText(
                          data.number,
                          color: data.refunds!.length == 0
                              ? _theme.textSubtitle.value
                              : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: CDimension.space8,
                  ),
                  CText(
                    StringExt.formatRupiah(data.total_amount),
                    color: _theme.accent.value,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Container(
                height: CDimension.space64,
                child: ListView.separated(
                  itemCount: data.details!.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: CDimension.space12,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var _product = data.details![index];
                    return Container(
                      child: CCachedImage(
                        width: CDimension.space64,
                        height: CDimension.space56,
                        url: _product.product!.image_url!,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: CDimension.space16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
