import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/size.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/popups/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/endpoints.dart';
import '../../controllers/bartender/bartender_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/ccached_image.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customButton.dart';
import '../../widgets/components/text/ctext.dart';

class BartenderPage extends StatefulWidget {
  const BartenderPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BartenderPage> createState() => _BartenderPageState();
}

class _BartenderPageState extends State<BartenderPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BartenderController _bartenderController =
      Get.put(BartenderController(), tag: 'BartenderController');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Order",
      ),
      body: Column(
        children: [
          Material(
            elevation: 4,
            shadowColor: Colors.black26,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _bartenderController.changeTab(0);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Obx(
                      () => Container(
                        color: _bartenderController.choosedTab.value == 0
                            ? _theme.accent.value
                            : Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: CDimension.space20,
                          vertical: CDimension.space16,
                        ),
                        height: CDimension.space48,
                        child: Center(
                          child: CText(
                            "In Progress",
                            color: _bartenderController.choosedTab.value == 0
                                ? Colors.white
                                : _theme.accent.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _bartenderController.changeTab(1);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Obx(
                      () => Container(
                        color: _bartenderController.choosedTab.value == 1
                            ? _theme.accent.value
                            : Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: CDimension.space16,
                          vertical: CDimension.space12,
                        ),
                        height: CDimension.space48,
                        child: Center(
                          child: CText(
                            "Done",
                            color: _bartenderController.choosedTab.value == 1
                                ? Colors.white
                                : _theme.accent.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: OtherExt().getHeight(context) - 128,
            child: RefreshIndicator(
              onRefresh: () async {
                _bartenderController.getAllData();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space16,
                  vertical: CDimension.space20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListView.separated(
                        itemCount: _bartenderController.choosedTab.value == 0
                            ? _bartenderController.listBartender.length
                            : _bartenderController.listBartenderDone.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: CDimension.space20,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          var _data = _bartenderController.choosedTab.value == 0
                              ? _bartenderController.listBartender[index]
                              : _bartenderController.listBartenderDone[index];
                          return Material(
                            elevation: 4,
                            shadowColor: Colors.black26,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  CDimension.space12,
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: OtherExt().getWidth(context),
                                    decoration: BoxDecoration(
                                      color: _theme.accent.value.withAlpha(200),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: CDimension.space16,
                                      horizontal: CDimension.space12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CText(
                                          _data.number,
                                          fontSize: CFontSize.font16,
                                          color: Colors.white,
                                        ),
                                        CText(
                                          DateExt.reformatToLocal(
                                            _data.date!,
                                            "yyyy-MM-dd",
                                            "dd MMM yyyy",
                                          ),
                                          fontSize: CFontSize.font16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.separated(
                                    itemCount: _data.details!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: CDimension.space4,
                                        ),
                                        child: CDivider(height: 1),
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var _detail = _data.details![index];
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: CDimension.space16,
                                          vertical: CDimension.space12,
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                CDimension.space12,
                                              ),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  _detail.status! == "open"
                                                      ? Colors.transparent
                                                      : Colors.grey,
                                                  BlendMode.saturation,
                                                ),
                                                child: CCachedImage(
                                                  width: CDimension.space64,
                                                  height: CDimension.space64,
                                                  url: _detail
                                                          .product!.image_url ??
                                                      Endpoint.defaultFood,
                                                ),
                                              ),
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
                                                    _detail.product!.name!
                                                        .capitalizeFirst,
                                                    color:
                                                        _theme.textTitle.value,
                                                  ),
                                                  SizedBox(
                                                    height: CDimension.space8,
                                                  ),
                                                  CText(
                                                    StringExt.formatRupiah(
                                                      _detail
                                                          .product!.sell_price,
                                                    ),
                                                    color: _detail.status! ==
                                                            "open"
                                                        ? _theme.accent.value
                                                        : Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: CDimension.space12,
                                            ),
                                            _detail.status!.toLowerCase() ==
                                                    "open"
                                                ? CustomButtonBlue(
                                                    "Done",
                                                    onPressed: () {
                                                      Get.dialog(
                                                        Confirmation(
                                                          title: "Warning!",
                                                          subtitle:
                                                              "Are you sure want to mark done this product?",
                                                          onOk: () {
                                                            Get.back();
                                                            _bartenderController
                                                                .updateProductDone(
                                                              _detail.id!,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : CText(
                                                    "Finished",
                                                    color: _theme
                                                        .textSubtitle.value,
                                                  ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: CDimension.space40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
