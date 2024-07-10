import 'package:beatboat/models/package/package_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../card/package_card.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetPackage extends StatefulWidget {
  final List<PackageData> data;

  SheetPackage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SheetPackage> createState() => _SheetPackageState();
}

class _SheetPackageState extends State<SheetPackage> {
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
                  "Packages",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  itemCount: widget.data.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var _data = widget.data[index];
                    return PackageCard(
                      data: _data,
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
