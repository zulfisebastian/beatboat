import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/controllers/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../components/customButton.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetResourceUpdate extends StatefulWidget {
  SheetResourceUpdate({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetResourceUpdate> createState() => _SheetResourceUpdateState();
}

class _SheetResourceUpdateState extends State<SheetResourceUpdate> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final HomeController _home = Get.find(tag: 'HomeController');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 0.87,
      builder: (context, scrollController) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: _theme.backgroundApp.value,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      DraggableBottomSheet(),
                      CText(
                        "Update Resource",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _theme.textTitle.value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: OtherExt().getWidth(context),
                        decoration: BoxDecoration(
                          color: _theme.accent.value,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: CText(
                                "Current Resource",
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CText(
                              _home.balance.value.table_name! +
                                  " - " +
                                  _home.balance.value.resource_tag!,
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CText(
                              _home.balance.value.position,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _theme.backgroundCard.value,
                            borderRadius: BorderRadius.circular(
                              50,
                            ),
                          ),
                          padding: EdgeInsets.all(
                            CDimension.space12,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/ic_menu_upgrade.svg",
                            width: CDimension.space32,
                            color: _theme.accent.value,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                        itemCount: _home.listResource.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          var _data = _home.listResource[index];
                          return GestureDetector(
                            onTap: () {
                              _home.choosedResource.value = _data;
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: (_data.resource_tag ==
                                            _home.choosedResource.value
                                                .resource_tag)
                                        ? _theme.accent.value
                                        : _theme.line.value,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CText(
                                          _data.table_name! +
                                              " - " +
                                              _data.resource_tag!,
                                          color: (_data.resource_tag ==
                                                  _home.choosedResource.value
                                                      .resource_tag)
                                              ? _theme.accent.value
                                              : _theme.textTitle.value,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        CText(
                                          _data.position!,
                                          color: _theme.textSubtitle.value,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    if (_data.resource_tag ==
                                        _home
                                            .choosedResource.value.resource_tag)
                                      Icon(
                                        Icons.check_circle_outlined,
                                        color: _theme.accent.value,
                                      )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: CDimension.space150,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space16,
                  vertical: CDimension.space12,
                ),
                color: Colors.white,
                child: CustomButtonBlue(
                  "Update Card Resource",
                  width: OtherExt().getWidth(context) - 32,
                  onPressed: () {
                    _home.updateDataResource();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
