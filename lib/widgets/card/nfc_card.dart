import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/controllers/theme/theme_controller.dart';
import 'package:beatboat/models/balance/balance_model.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/utils/helpers.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NFCCard extends StatelessWidget {
  final BalanceData balance;
  final bool showBalance;

  NFCCard({
    Key? key,
    required this.balance,
    required this.showBalance,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _theme.backgroundAppOther.value,
      padding: EdgeInsets.symmetric(
        horizontal: CDimension.space16,
        vertical: CDimension.space16,
      ),
      child: Container(
        width: OtherExt().getWidth(context),
        height: showBalance ? 210 : 150,
        decoration: BoxDecoration(
          gradient: getLinearGradient(balance.table_name ?? ""),
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
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: getColorType(balance.table_name ?? ""),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: CDimension.space12,
                    vertical: CDimension.space6,
                  ),
                  child: CText(
                    getNameFromType(balance.table_name ?? ""),
                    color: getColorType(
                      balance.table_name ?? "",
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: CDimension.space12,
                ),
                CText(
                  "Balance",
                  fontSize: 11,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: CDimension.space8,
            ),
            CText(
              StringExt.formatRupiah(
                balance.last_balance ?? 0,
              ),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            SizedBox(
              child: showBalance
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: CDimension.space12,
                        ),
                        CText(
                          "Total Credit : ${StringExt.formatRupiah(
                            balance.total_credit ?? 0,
                          )}",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: CDimension.space8,
                        ),
                        CText(
                          "Refundable Top Up : ${StringExt.formatRupiah(
                            balance.refundable_top_up ?? 0,
                          )}",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ],
                    )
                  : SizedBox(),
            ),
            Expanded(
              child: SizedBox(),
            ),
            CText(
              StringExt.hideMiddleCode(
                balance.wristband_code ?? "",
              ),
              spacing: 4,
              fontSize: 20,
              color: Colors.white,
            ),
            SizedBox(
              height: CDimension.space8,
            ),
            CText(
              "${balance.customer_name ?? ""} / ${balance.table_name ?? ""}",
              fontSize: 12,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
