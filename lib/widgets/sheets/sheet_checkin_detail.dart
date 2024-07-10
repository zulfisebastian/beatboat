import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/models/checkin/checkin_model.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetCheckinDetail extends StatefulWidget {
  final CheckinData data;

  SheetCheckinDetail({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SheetCheckinDetail> createState() => _SheetCheckinDetailState();
}

class _SheetCheckinDetailState extends State<SheetCheckinDetail> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: _theme.backgroundApp.value,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DraggableBottomSheet(),
                CText(
                  "Detail Checkin",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: CDimension.space20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CText(
                      "Booker Name",
                      fontSize: 14,
                      color: _theme.textTitle.value,
                    ),
                    CText(
                      widget.data.booker_name,
                      fontSize: 14,
                      color: _theme.textTitle.value,
                      fontWeight: FontWeight.bold,
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
                      "Booking Date",
                      fontSize: 14,
                      color: _theme.textTitle.value,
                    ),
                    CText(
                      DateExt.reformat(
                        widget.data.booking_date!,
                        "yyyy-MM-dd",
                        "EEE, dd MMM yyyy",
                      ),
                      fontSize: 14,
                      color: _theme.textTitle.value,
                      fontWeight: FontWeight.bold,
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
                      "Payment Status",
                      fontSize: 14,
                      color: _theme.textTitle.value,
                    ),
                    CText(
                      widget.data.payment_status,
                      fontSize: 14,
                      color: _theme.textTitle.value,
                      fontWeight: FontWeight.bold,
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
                      "Validity Ticket",
                      fontSize: 14,
                      color: _theme.textTitle.value,
                    ),
                    CText(
                      widget.data.valid! ? "Ticket Valid" : "Ticket Invalid",
                      fontSize: 14,
                      color: widget.data.valid!
                          ? _theme.success.value
                          : _theme.error.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
