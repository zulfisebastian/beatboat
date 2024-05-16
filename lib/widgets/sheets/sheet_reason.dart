import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetReason extends StatefulWidget {
  final List<String> data;
  final String choosed;
  final Function(String) onChoose;

  SheetReason({
    Key? key,
    required this.data,
    required this.choosed,
    required this.onChoose,
  }) : super(key: key);

  @override
  State<SheetReason> createState() => _SheetReasonState();
}

class _SheetReasonState extends State<SheetReason> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  TextEditingController search = TextEditingController();
  late List<String> filterData;

  @override
  void initState() {
    super.initState();
    filterData = widget.data;
  }

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
                  "Reason",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  itemCount: filterData.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onChoose(filterData[index]);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: CText(
                          filterData[index],
                          color: (filterData[index].toLowerCase() ==
                                  widget.choosed.toLowerCase())
                              ? _theme.accent.value
                              : _theme.textTitle.value,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
