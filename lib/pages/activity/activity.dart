import 'package:beatboat/controllers/activity/activity_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/card/card_activity.dart';
import '../../widgets/components/cdivider.dart';
import '../../widgets/components/customAppBar.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ActivityController _activityController = Get.put(
    ActivityController(),
    tag: "ActivityController",
  );

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
              controller: _activityController.scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: CDimension.space16,
              ),
              child: Column(
                children: [
                  Obx(
                    () => _activityController.listActivity.length > 0
                        ? ListView.separated(
                            itemCount: _activityController.listActivity.length,
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
                              var _data =
                                  _activityController.listActivity[index];
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
            () => _activityController.isLoadMoreData.value
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
