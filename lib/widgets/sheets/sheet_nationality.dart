import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../components/csearch.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetNationality extends StatefulWidget {
  final List<String> data;
  final String choosed;
  final Function(String) onChoose;

  SheetNationality({
    Key? key,
    required this.data,
    required this.choosed,
    required this.onChoose,
  }) : super(key: key);

  @override
  State<SheetNationality> createState() => _SheetNationalityState();
}

class _SheetNationalityState extends State<SheetNationality> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  TextEditingController search = TextEditingController();
  late List<String> filterData;

  @override
  void initState() {
    super.initState();
    filterData = widget.data;
  }

  searchData(text) {
    filterData = widget.data
        .where(
          (element) => element.replaceAll(".", "").toLowerCase().contains(
                text.toString().replaceAll(".", "").toLowerCase(),
              ),
        )
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 0.8,
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
                  "Nationality",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: 20,
                ),
                CSearch(
                  textEditingController: search,
                  errorMessage: "",
                  hintText: "Search Nationality",
                  radius: 6,
                  onChanged: (v) {
                    searchData(v);
                  },
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
