import 'package:beatboat/models/activity/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../components/text/ctext.dart';

class CardActivity extends StatelessWidget {
  final ActivityData data;
  CardActivity({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');

  getIconActivity() {
    if (data.activity!.toLowerCase() == "sales") {
      if (data.bill_type!.toLowerCase() == "split_bill") {
        return "ic_split_bill";
      } else {
        return "ic_sales";
      }
    } else {
      if (data.activity!.toLowerCase() == "top_up") {
        return "ic_top_up";
      } else if (data.activity!.toLowerCase() == "transfer_in") {
        return "ic_transfer_in";
      } else if (data.activity!.toLowerCase() == "transfer_out") {
        return "ic_transfer_out";
      } else if (data.activity!.toLowerCase() == "refund") {
        return "ic_menu_refund";
      } else {
        return "ic_market";
      }
    }
  }

  getTypeActivity() {
    if (data.activity!.toLowerCase() == "sales") {
      if (data.bill_type!.toLowerCase() == "split_bill") {
        return "Split Bill - ${data.customer_name!.capitalizeFirst}";
      } else {
        return "Stand Alone - ${data.customer_name!.capitalizeFirst}";
      }
    } else {
      if (data.activity!.toLowerCase() == "top_up") {
        return "Top Up Account - ${data.customer_name!.capitalizeFirst}";
      } else if (data.activity!.toLowerCase() == "transfer_in") {
        return "Transfer In From ${data.customer_name!.capitalizeFirst}";
      } else if (data.activity!.toLowerCase() == "transfer_out") {
        return "Transfer Out To ${data.customer_name!.capitalizeFirst}";
      } else if (data.activity!.toLowerCase() == "refund") {
        return "Refund - ${data.customer_name!.capitalizeFirst}";
      } else {
        return "Other";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OtherExt().getWidth(context),
      padding: EdgeInsets.symmetric(
        vertical: CDimension.space12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          CDimension.space12,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(
              CDimension.space12,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _theme.accent.value,
            ),
            child: SvgPicture.asset(
              "assets/icons/${getIconActivity()}.svg",
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: CDimension.space16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  data.number ?? "-",
                  color: _theme.textSubtitle.value,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: CDimension.space8,
                ),
                CText(
                  getTypeActivity(),
                  color: _theme.textTitle.value,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                  lineHeight: 1.4,
                ),
                SizedBox(
                  height: CDimension.space8,
                ),
                CText(
                  DateExt.reformatToLocal(
                    data.last_update!,
                    "yyyy-MM-DDTHH:mm:ss",
                    "EEEE, d MMM yyyy",
                  ),
                  color: _theme.textSubtitle.value,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          SizedBox(
            width: CDimension.space16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CText(
                StringExt.thousandFormatter(data.amount!),
                color: data.amount!.toString().contains("-")
                    ? _theme.error.value
                    : _theme.accent.value,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: CDimension.space8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: _theme.textSubtitle.value,
                    size: 16,
                  ),
                  SizedBox(
                    width: CDimension.space4,
                  ),
                  CText(
                    DateExt.reformatToLocal(
                      data.last_update!,
                      "yyyy-MM-DDTHH:mm:ss",
                      "HH:mm",
                    ),
                    color: _theme.textSubtitle.value,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
