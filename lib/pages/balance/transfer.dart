import 'package:beatboat/constants/enums.dart';
import 'package:beatboat/constants/size.dart';
import 'package:beatboat/controllers/balance/transfer_controller.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customInputNumber.dart';
import 'package:beatboat/widgets/sheets/sheet_failed.dart';
import 'package:beatboat/widgets/sheets/sheet_nfc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../../utils/helpers.dart';
import '../../widgets/card/no_balance_card.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customButton.dart';
import '../../widgets/components/text/ctext.dart';

class TransferPage extends StatefulWidget {
  TransferPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final TransferController _transferController = Get.find(
    tag: 'TransferController',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _transferController.amount.value.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Transfer",
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
          child: Obx(
            () => CustomButtonBlue(
              "TRANSFER NOW",
              disabled: _transferController.amount.value.text == "" ||
                  int.parse(_transferController.amount.value.text
                          .replaceAll(".", "")) <
                      100000,
              onPressed: () {
                _transferController.transferBalance();
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          CDimension.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _theme.backgroundCard.value,
                borderRadius: BorderRadius.circular(
                  CDimension.space20,
                ),
              ),
              padding: EdgeInsets.all(
                CDimension.space24,
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Obx(
                        () => Container(
                          width: OtherExt().getWidth(context),
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: getLinearGradient(
                              _transferController.sourceCard.value.type!,
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
                              Row(
                                children: [
                                  Obx(
                                    () => CText(
                                      _transferController
                                              .sourceCard.value.customer_name ??
                                          "",
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: CDimension.space8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      Get.bottomSheet(
                                        SheetNFC(
                                          type: NFCModeType.TransferFrom,
                                        ),
                                      );
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: CDimension.space8,
                                        horizontal: CDimension.space12,
                                      ),
                                      child: CText(
                                        "Change",
                                        fontSize: 10,
                                        color: _theme.textTitle.value,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: CDimension.space8,
                              ),
                              Obx(
                                () => CText(
                                  StringExt.hideMiddleCode(
                                    _transferController
                                            .sourceCard.value.wristband_code ??
                                        "",
                                  ),
                                  spacing: 4,
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Obx(
                                () => CText(
                                  StringExt.formatRupiah(
                                    _transferController
                                            .sourceCard.value.last_balance ??
                                        "",
                                  ),
                                  spacing: 4,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: CDimension.space16,
                      ),
                      Obx(
                        () => _transferController
                                    .destinationCard.value.nfc_uid !=
                                null
                            ? Container(
                                width: OtherExt().getWidth(context),
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: getLinearGradient(
                                    _transferController
                                        .destinationCard.value.type!,
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
                                    Row(
                                      children: [
                                        Obx(
                                          () => CText(
                                            _transferController.destinationCard
                                                    .value.customer_name ??
                                                "",
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: CDimension.space8,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.bottomSheet(
                                              SheetNFC(
                                                  type: NFCModeType.TransferTo),
                                            );
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: CDimension.space8,
                                              horizontal: CDimension.space12,
                                            ),
                                            child: CText(
                                              "Change",
                                              fontSize: 10,
                                              color: _theme.textTitle.value,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: CDimension.space8,
                                    ),
                                    Obx(
                                      () => CText(
                                        StringExt.hideMiddleCode(
                                          _transferController.destinationCard
                                                  .value.wristband_code ??
                                              "",
                                        ),
                                        spacing: 4,
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Obx(
                                      () => CText(
                                        StringExt.formatRupiah(
                                          _transferController.destinationCard
                                                  .value.last_balance ??
                                              "",
                                        ),
                                        spacing: 4,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : NoBalanceCard(
                                label: "Add your transfer destination",
                                onClick: () {
                                  Get.bottomSheet(
                                    SheetNFC(
                                      type: NFCModeType.TransferTo,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 120,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        if (_transferController.destinationCard.value.nfc_uid !=
                            null)
                          _transferController.switchCard();
                        else
                          Get.bottomSheet(
                            SheetFailed(
                              errorMessage:
                                  "Please scan your transfer destination first",
                            ),
                          );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(
                          CDimension.space16,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/ic_menu_transfer.svg",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: CDimension.space24,
            ),
            CDivider(
              height: 1,
            ),
            SizedBox(
              height: CDimension.space24,
            ),
            CText(
              "Amount you want to transfer",
              fontSize: 16,
              color: _theme.textTitle.value,
            ),
            SizedBox(
              height: CDimension.space24,
            ),
            CustomInputNumber(
              textEditingController: _transferController.amount.value,
              hintText: "Your Amount",
              errorMessage: "-",
              onChanged: (v) {},
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
              height: CDimension.space150,
            ),
          ],
        ),
      ),
    );
  }
}
