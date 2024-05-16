import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/constants/enums.dart';
import 'package:beatboat/controllers/base/base_controller.dart';
import 'package:beatboat/controllers/home/home_controller.dart';
import 'package:beatboat/pages/activity/activity.dart';
import 'package:beatboat/pages/bartender/bartender.dart';
import 'package:beatboat/pages/product/product.dart';
import 'package:beatboat/pages/profile/profile.dart';
import 'package:beatboat/pages/refund/refund.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/ccached_image.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/cmenu_home.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:beatboat/widgets/sheets/sheet_nfc.dart';
import 'package:beatboat/widgets/sheets/sheet_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/card/card_activity.dart';
import '../../widgets/components/calert_connection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');
  final HomeController _homeController =
      Get.put(HomeController(), tag: 'HomeController');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: _theme.backgroundApp.value,
          body: RefreshIndicator(
            onRefresh: () async {
              _homeController.initAllData();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: CDimension.space24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: CDimension.space16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SvgPicture.asset(
                        //   "assets/icons/logo.svg",
                        //   width: CDimension.space128,
                        // ),
                        Container(
                          width: CDimension.space48,
                          height: CDimension.space48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              CDimension.space48,
                            ),
                            child: Image.asset(
                              "assets/images/icon.png",
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // _base.logout();
                                Get.to(
                                  ProfilePage(),
                                );
                              },
                              child: Container(
                                width: CDimension.space40,
                                padding: EdgeInsets.all(CDimension.space8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _theme.backgroundCard.value,
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/ic_profile.svg",
                                  width: CDimension.space16,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Obx(
                                () => Container(
                                  width: CDimension.space8,
                                  height: CDimension.space8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _base.isConnected.value
                                        ? _theme.success.value
                                        : _theme.error.value,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //Offline
                  CAlertConnection(),
                  //End Offline
                  SizedBox(
                    height: CDimension.space8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: CDimension.space16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          "Balance",
                          color: _theme.accent.value,
                          fontSize: CDimension.space20,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: CDimension.space16,
                        ),
                        Obx(
                          () => Wrap(
                            spacing: CDimension.space12,
                            runSpacing: CDimension.space12,
                            children: _homeController.listMenu.reversed
                                .map(
                                  (e) => CMenuHome(
                                    onClick: () {
                                      switch (e.menu_slug) {
                                        case "topup":
                                          Get.bottomSheet(
                                            SheetNFC(
                                              type: NFCModeType.TopUp,
                                            ),
                                          );
                                          return;
                                        case "transfer":
                                          Get.bottomSheet(
                                            SheetNFC(
                                              type: NFCModeType.TransferFrom,
                                            ),
                                          );
                                          return;
                                        case "refund":
                                          Get.to(RefundPage());
                                          return;
                                        case "check_in":
                                          Get.bottomSheet(
                                            SheetScan(),
                                            isScrollControlled: true,
                                          );
                                          return;
                                        case "bartender":
                                          Get.to(BartenderPage());
                                          return;
                                        default:
                                      }
                                    },
                                    icon: e.menu_slug ?? "cc",
                                    title: e.menu_name ?? "Menu",
                                    subtitle: "Menu",
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space32,
                  ),
                  Container(
                    width: OtherExt().getWidth(context),
                    padding: EdgeInsets.symmetric(
                      vertical: CDimension.space24,
                    ),
                    decoration: BoxDecoration(
                      color: _theme.backgroundCard.value,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: CDimension.space16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CText(
                                "Store",
                                color: _theme.textTitle.value,
                                fontSize: CDimension.space20,
                                fontWeight: FontWeight.w500,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ProductPage());
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  children: [
                                    CText(
                                      "View All",
                                      color: _theme.textTitle.value,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      width: CDimension.space4,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: _theme.textSubtitle.value,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: CDimension.space24,
                        ),
                        SizedBox(
                          height: 150,
                          child: Obx(
                            () => ListView.separated(
                              padding: EdgeInsets.symmetric(
                                horizontal: CDimension.space16,
                              ),
                              itemCount: _homeController.listCategory.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: CDimension.space16,
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var _data = _homeController.listCategory[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      ProductPage(
                                        categoryId: _data.id,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    child: Column(
                                      children: [
                                        CCachedImage(
                                          width: 120,
                                          height: 120,
                                          url: _data.image_url ??
                                              Endpoint.defaultFood,
                                        ),
                                        SizedBox(
                                          height: CDimension.space8,
                                        ),
                                        CText(
                                          _data.name!.capitalizeFirst,
                                          color: _theme.textTitle.value,
                                          fontSize: 14,
                                          maxLines: 2,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space32,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: CDimension.space16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CText(
                              "Activity",
                              color: _theme.accent.value,
                              fontSize: CDimension.space20,
                              fontWeight: FontWeight.w500,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  ActivityPage(),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CText(
                                      "View All",
                                      color: _theme.textTitle.value,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      width: CDimension.space4,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: _theme.textSubtitle.value,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: CDimension.space16,
                        ),
                        Obx(
                          () => ListView.separated(
                            itemCount: _homeController.listActivity.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: CDimension.space4,
                                ),
                                child: CDivider(
                                  height: 0.5,
                                ),
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              var _data = _homeController.listActivity[index];
                              return CardActivity(
                                data: _data,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space32,
                  ),
                  SizedBox(
                    height: CDimension.space80,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
