import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/activity/activity_byid_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/helpers.dart';
import '../../widgets/card/card_activity.dart';
import '../../widgets/components/cdivider.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/text/ctext.dart';

class ActivityByIdPage extends StatefulWidget {
  const ActivityByIdPage({Key? key}) : super(key: key);

  @override
  State<ActivityByIdPage> createState() => _ActivityByIdPageState();
}

class _ActivityByIdPageState extends State<ActivityByIdPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ActivityByIdController _activityController = Get.find(
    tag: "ActivityByIdController",
  );

  @override
  void dispose() {
    print("KE TRIGGER GA");
    Get.delete<ActivityByIdController>();
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
              controller: _activityController.scrollController,
              child: Column(
                children: [
                  Container(
                    color: _theme.backgroundAppOther.value,
                    padding: EdgeInsets.symmetric(
                      horizontal: CDimension.space16,
                      vertical: CDimension.space16,
                    ),
                    child: Obx(
                      () => Container(
                        width: OtherExt().getWidth(context),
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: getLinearGradient(
                            _activityController.balance.value.type ?? "",
                          ),
                          borderRadius: BorderRadius.circular(
                            CDimension.space16,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: CDimension.space24,
                          vertical: CDimension.space16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CText(
                              "Balance",
                              fontSize: 11,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: CDimension.space8,
                            ),
                            Obx(
                              () => CText(
                                StringExt.formatRupiah(
                                  _activityController
                                          .balance.value.last_balance ??
                                      0,
                                ),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Obx(
                              () => CText(
                                StringExt.hideMiddleCode(
                                  _activityController
                                          .balance.value.wristband_code ??
                                      "",
                                ),
                                spacing: 4,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: CDimension.space8,
                            ),
                            Obx(
                              () => CText(
                                "${_activityController.balance.value.customer_name ?? ""} / ${_activityController.balance.value.table_name ?? ""}",
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Obx(
                    () => _activityController.listActivity.length > 0
                        ? ListView.separated(
                            itemCount: _activityController.listActivity.length,
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
