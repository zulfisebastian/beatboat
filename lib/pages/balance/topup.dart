import 'package:beatboat/controllers/balance/balance_controller.dart';
import 'package:beatboat/controllers/balance/top_up_controller.dart';
import 'package:beatboat/pages/home/home.dart';
import 'package:beatboat/pages/result/success.dart';
import 'package:beatboat/widgets/popups/confirmation.dart';
import 'package:beatboat/widgets/sheets/sheet_topup_option.dart';
import 'package:beatboat/widgets/sheets/sheet_voucher_topup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/size.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../../utils/helpers.dart';
import '../../widgets/components/cdivider.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customButton.dart';
import '../../widgets/components/customInputNumber.dart';
import '../../widgets/components/text/ctext.dart';

class TopUpPage extends StatefulWidget {
  final String nfcUid;

  const TopUpPage({
    Key? key,
    required this.nfcUid,
  }) : super(key: key);

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final TopUpController _topUpController =
      Get.put(TopUpController(), tag: 'TopUpController');
  final BalanceController _balanceController = Get.put(
    BalanceController(),
    tag: 'BalanceController',
  );

  @override
  void initState() {
    super.initState();
    _balanceController.checkBalance(widget.nfcUid);
  }

  @override
  void dispose() {
    _topUpController.amount.value.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Top Up",
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
                        _topUpController.calculateTotalTopup(),
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
                  disabled: _topUpController.amount.value.text == "" ||
                      int.parse(_topUpController.amount.value.text
                              .replaceAll(".", "")) <
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
                                _topUpController.topUpBalance(
                                  _balanceController.balance.value,
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
                                _topUpController.getCamera(context, () {
                                  _topUpController.topUpBalance(
                                    _balanceController.balance.value,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      _balanceController.balance.value.type ?? "",
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
                            _balanceController.balance.value.last_balance ?? 0,
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
                            _balanceController.balance.value.wristband_code ??
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
                          _balanceController.balance.value.customer_name ?? "",
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
                    textEditingController: _topUpController.amount.value,
                    hintText: "Your Amount",
                    errorMessage: "-",
                    onChanged: (v) {
                      _topUpController.changeAmount(v);
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
                      children: _topUpController.amountList
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                _topUpController.changeAmount(e);
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
                                    color: _topUpController.amount.value == e
                                        ? _theme.accent.value
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: _topUpController.amount.value == e
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
                                        color:
                                            _topUpController.amount.value == e
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
                                        color:
                                            _topUpController.amount.value == e
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
                  CText(
                    "Vouchers",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _theme.textTitle.value,
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Obx(
                    () =>
                        _topUpController.voucherData.value.voucher_code != null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: _theme.line.value,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    CDimension.space8,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: CDimension.space16,
                                  vertical: CDimension.space12,
                                ),
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_voucher.svg",
                                      ),
                                    ),
                                    SizedBox(
                                      width: CDimension.space12,
                                    ),
                                    Expanded(
                                      child: CText(
                                        "Voucher Applied",
                                        color: _theme.accent.value,
                                        fontSize: CFontSize.font14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: CDimension.space12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.dialog(Confirmation(
                                          title: "Warning!",
                                          subtitle:
                                              "Are you sure want to unclaim this voucher?",
                                          onOk: () {
                                            Get.back();
                                            _topUpController.removeVoucher();
                                          },
                                        ));
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(SheetVoucherTopup());
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: _theme.line.value,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      CDimension.space8,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: CDimension.space16,
                                    vertical: CDimension.space8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CText(
                                        "Add Voucher",
                                        color: _theme.textTitle.value,
                                      ),
                                      Icon(
                                        Icons.add,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                  ),
                  SizedBox(
                    height: CDimension.space16,
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
    );
  }
}
