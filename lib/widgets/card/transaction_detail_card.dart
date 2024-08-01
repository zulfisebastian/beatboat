import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../models/transaction/transaction_model.dart';
import '../components/ccached_image.dart';
import '../components/text/ctext.dart';

class TransactionDetailCard extends StatelessWidget {
  final DetailTransactionData data;

  TransactionDetailCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OtherExt().getWidth(context),
      padding: EdgeInsets.only(
        left: CDimension.space16,
        right: CDimension.space16,
        top: CDimension.space8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: _theme.line.value,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CCachedImage(
                      width: 56,
                      height: 56,
                      url: data.product!.image_url ?? Endpoint.defaultFood,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: CDimension.space20,
                  height: CDimension.space20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _theme.accent.value,
                  ),
                  child: Center(
                    child: CText(
                      data.qty,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: CDimension.space16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CText(
                        data.product!.name!.capitalizeFirst,
                        color: _theme.accent.value,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        maxLines: 2,
                        lineHeight: 1.3,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    SizedBox(
                      width: CDimension.space8,
                    ),
                    CText(
                      StringExt.formatRupiah(data.total_price),
                      color: _theme.textTitle.value,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: CDimension.space12),
                CDivider(height: 1),
                SizedBox(height: CDimension.space4),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: CDimension.space4,
                  ),
                  child: CText(
                    data.note != null ? data.note! : "No note",
                    color: _theme.textSubtitle.value,
                    fontSize: 16,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
