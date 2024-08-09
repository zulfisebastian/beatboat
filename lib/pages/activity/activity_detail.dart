import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/ccached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/size.dart';
import '../../controllers/activity/activity_detail_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/cdivider.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/card/nfc_card.dart';
import '../../widgets/components/customButton.dart';
import '../../widgets/components/customInputNumber.dart';
import '../../widgets/components/text/ctext.dart';
import '../../widgets/popups/confirmation.dart';
import '../../widgets/sheets/sheet_topup_option.dart';
import '../home/home.dart';
import '../result/success.dart';

class ActivityDetailPage extends StatefulWidget {
  final String id;
  const ActivityDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ActivityDetailController _activity = Get.put(
    ActivityDetailController(),
    tag: "ActivityDetailController",
  );

  @override
  void dispose() {
    Get.delete<ActivityDetailController>(
      tag: "ActivityDetailController",
    );
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _activity.getDataActivity(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "ACTIVITY DETAIL",
      ),
      bottomSheet: Material(
        elevation: 20,
        child: Container(
          width: OtherExt().getWidth(context),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CDimension.space16,
            vertical: CDimension.space12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    "You will get",
                    fontSize: CFontSize.font14,
                    color: _theme.textTitle.value,
                  ),
                  Obx(
                    () => CText(
                      StringExt.formatRupiah(
                        _activity.calculateTotalTopup(),
                      ),
                      fontSize: CFontSize.font16,
                      fontWeight: FontWeight.bold,
                      color: _theme.accent.value,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CDimension.space12,
              ),
              Obx(
                () => CustomButtonBlue(
                  "TOP UP NOW",
                  disabled: _activity.amount.value.text == "" ||
                      int.parse(
                              _activity.amount.value.text.replaceAll(".", "")) <
                          100000,
                  width: OtherExt().getWidth(context),
                  onPressed: () {
                    Get.dialog(
                      Confirmation(
                        title: "Warning!",
                        subtitle: "Are you sure want to top up this card?",
                        onOk: () {
                          Get.bottomSheet(
                            SheetTopupOption(
                              onCash: () {
                                _activity.topUpBalance(
                                  _activity.balance.value,
                                  "CASH",
                                  () {
                                    Get.to(SuccessPage(
                                      title: "Top Up Success",
                                      subtitle:
                                          "Congratulations, Your balance has been added successfully",
                                      action: "Done Top Up!",
                                      onFinish: () {
                                        final HomeController _homeController =
                                            Get.find(tag: 'HomeController');
                                        _homeController.initAllData();
                                        Get.offAll(HomePage());
                                      },
                                    ));
                                  },
                                );
                              },
                              onEDC: () {
                                _activity.getCamera(context, () {
                                  _activity.topUpBalance(
                                    _activity.balance.value,
                                    "EDC",
                                    () {
                                      Get.to(SuccessPage(
                                        title: "Top Up Success",
                                        subtitle:
                                            "Congratulations, Your balance has been added successfully",
                                        action: "Done Top Up!",
                                        onFinish: () {
                                          final HomeController _homeController =
                                              Get.find(tag: 'HomeController');
                                          _homeController.initAllData();
                                          Get.offAll(HomePage());
                                        },
                                      ));
                                    },
                                  );
                                });
                              },
                            ),
                            isScrollControlled: true,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: OtherExt().getWidth(context),
        height: OtherExt().getHeight(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => NFCCard(
                  balance: _activity.balance.value,
                  showBalance: false,
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space16,
                  vertical: CDimension.space16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText(
                      "Choose Amount",
                      color: _theme.textTitle.value,
                    ),
                    SizedBox(
                      height: CDimension.space24,
                    ),
                    CustomInputNumber(
                      textEditingController: _activity.amount.value,
                      hintText: "Your Amount",
                      errorMessage: "-",
                      onChanged: (v) {
                        _activity.changeAmount(v);
                      },
                    ),
                    SizedBox(
                      height: CDimension.space8,
                    ),
                    CText(
                      "Minimum amount 100.000",
                      fontSize: CFontSize.font14,
                      color: _theme.textSubtitle.value,
                    ),
                    SizedBox(
                      height: CDimension.space20,
                    ),
                    Obx(
                      () => Wrap(
                        spacing: CDimension.space12,
                        runSpacing: CDimension.space12,
                        children: _activity.amountList
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  _activity.changeAmount(e);
                                },
                                child: Obx(
                                  () => Container(
                                    width: (OtherExt().getWidth(context) -
                                            (CDimension.space24 * 2)) /
                                        2,
                                    padding: EdgeInsets.symmetric(
                                      vertical: CDimension.space20,
                                      horizontal: CDimension.space16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _activity.amount.value == e
                                          ? _theme.accent.value
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: _activity.amount.value == e
                                            ? _theme.accent.value
                                            : _theme.line.value,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CText(
                                          "IDR",
                                          fontSize: 12,
                                          spacing: 2,
                                          color: _activity.amount.value == e
                                              ? Colors.white
                                              : _theme.textTitle.value,
                                        ),
                                        SizedBox(
                                          height: CDimension.space8,
                                        ),
                                        CText(
                                          "${StringExt.thousandFormatter(e)}",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: _activity.amount.value == e
                                              ? Colors.white
                                              : _theme.textTitle.value,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: CDimension.space24,
                    ),
                    CDivider(height: 0.5),
                    SizedBox(
                      height: CDimension.space24,
                    ),
                    Obx(
                      () => _activity.dataActivity.value.method == "EDC"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CText(
                                  "Transfer Proof",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _theme.textTitle.value,
                                ),
                                SizedBox(
                                  height: CDimension.space24,
                                ),
                                CCachedImage(
                                  width: 80,
                                  height: 120,
                                  url: _activity.dataActivity.value.image_url!,
                                ),
                              ],
                            )
                          : SizedBox(),
                    ),
                    SizedBox(
                      height: CDimension.space128,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
