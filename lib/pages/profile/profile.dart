import 'package:beatboat/controllers/profile/profile_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:beatboat/widgets/sheets/sheet_device.dart';
import 'package:beatboat/widgets/sheets/sheet_logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/dimension.dart';
import '../../controllers/base/base_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/cdivider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');
  final ProfileController _profileController =
      Get.put(ProfileController(), tag: 'ProfileController');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      body: RefreshIndicator(
        onRefresh: () async {
          _profileController.getProfileData();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: CDimension.space24,
          ),
          child: Column(
            children: [
              Container(
                width: OtherExt().getWidth(context),
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          color: _theme.backgroundAppOther.value,
                          width: OtherExt().getWidth(context),
                          height: 140,
                        ),
                        Container(
                          color: Colors.white,
                          width: OtherExt().getWidth(context),
                          height: 140,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 70,
                      child: Column(
                        children: [
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(120),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  width: 5,
                                  color: Colors.white,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                  "assets/images/icon_trans.png",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: CDimension.space16,
                          ),
                          Obx(
                            () => CText(
                              _profileController.dataProfile.value.full_name ??
                                  "-",
                              color: _theme.textTitle.value,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: CDimension.space12,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: _theme.accent.value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: CDimension.space12,
                              vertical: CDimension.space8,
                            ),
                            child: Obx(
                              () => CText(
                                _profileController.dataProfile.value.role,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 32,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                          "Email",
                          fontSize: 16,
                          color: _theme.textTitle.value,
                        ),
                        Obx(
                          () => CText(
                            _profileController.dataProfile.value.email,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _theme.textTitle.value,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    CDivider(
                      height: 1,
                    ),
                    SizedBox(
                      height: CDimension.space16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                          "Kitchen Printer",
                          fontSize: 16,
                          color: _theme.textTitle.value,
                        ),
                        SizedBox(
                          width: CDimension.space24,
                          height: CDimension.space24,
                          child: Obx(
                            () => Checkbox(
                              onChanged: (value) {
                                _profileController.changeKitchenPrinter();
                              },
                              value: _profileController.kitchenPrinter.value,
                              checkColor: Colors.white,
                              activeColor: _theme.accent.value,
                              side: BorderSide(
                                color: _theme.textTitle.value,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: CDimension.space16,
                    // ),
                    // CDivider(
                    //   height: 1,
                    // ),
                    // SizedBox(
                    //   height: CDimension.space16,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     CText(
                    //       "Printer Thermal",
                    //       fontSize: 16,
                    //       color: _theme.textTitle.value,
                    //     ),
                    //     CustomButtonBlue(
                    //       "Setting",
                    //       onPressed: () {
                    //         Get.bottomSheet(
                    //           SheetPrinterThermal(),
                    //           isScrollControlled: true,
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              CDivider(
                height: CDimension.space8,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(SheetDevice());
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: CDimension.space16,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          "assets/icons/ic_setting.svg",
                          width: CDimension.space20,
                        ),
                      ),
                      SizedBox(
                        width: CDimension.space4,
                      ),
                      Expanded(
                        child: CText(
                          "Settings",
                          fontSize: 16,
                          color: _theme.textTitle.value,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CDivider(
                height: 1,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(SheetLogout(onTap: () {
                    _base.logout();
                  }));
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: CDimension.space16,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          "assets/icons/ic_logout.svg",
                          width: CDimension.space20,
                        ),
                      ),
                      SizedBox(
                        width: CDimension.space4,
                      ),
                      Expanded(
                        child: CText(
                          "Logout",
                          fontSize: 16,
                          color: _theme.textTitle.value,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              CDivider(
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
