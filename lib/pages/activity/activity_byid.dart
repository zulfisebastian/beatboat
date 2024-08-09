import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/activity/activity_byid_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/card/card_activity.dart';
import '../../widgets/card/nfc_card.dart';
import '../../widgets/components/cdivider.dart';
import '../../widgets/components/customAppBar.dart';

class ActivityByIdPage extends StatefulWidget {
  const ActivityByIdPage({Key? key}) : super(key: key);

  @override
  State<ActivityByIdPage> createState() => _ActivityByIdPageState();
}

class _ActivityByIdPageState extends State<ActivityByIdPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ActivityByIdController _activity = Get.find(
    tag: "ActivityByIdController",
  );

  @override
  void dispose() {
    Get.delete<ActivityByIdController>(
      tag: "ActivityByIdController",
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Activity",
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: OtherExt().getHeight(context),
            child: SingleChildScrollView(
              controller: _activity.scrollController,
              child: Column(
                children: [
                  Obx(
                    () => NFCCard(
                      balance: _activity.balance.value,
                      showBalance: true,
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Obx(
                    () => _activity.listActivity.length > 0
                        ? ListView.separated(
                            itemCount: _activity.listActivity.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: CDimension.space16,
                            ),
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
                              var _data = _activity.listActivity[index];
                              return CardActivity(
                                data: _data,
                              );
                            },
                          )
                        : Container(
                            child: Column(
                              children: [
                                //
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => _activity.isLoadMoreData.value
                ? Positioned(
                    bottom: CDimension.space16,
                    child: Material(
                      elevation: CDimension.space20,
                      borderRadius: BorderRadius.circular(
                        CDimension.space150,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(
                          CDimension.space12,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircularProgressIndicator(
                          color: _theme.accent.value,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
