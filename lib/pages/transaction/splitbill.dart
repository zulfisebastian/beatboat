import 'package:beatboat/controllers/base/base_controller.dart';
import 'package:beatboat/pages/balance/topup.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/ctoast.dart';
import 'package:beatboat/widgets/components/customInputForm.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:beatboat/widgets/popups/confirmation.dart';
import 'package:beatboat/widgets/sheets/sheet_split_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/enums.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/transaction/transaction_controller.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customButton.dart';
import '../../widgets/sheets/sheet_nfc.dart';

class SplitBillPage extends StatefulWidget {
  const SplitBillPage({Key? key}) : super(key: key);

  @override
  State<SplitBillPage> createState() => _SplitBillPageState();
}

class _SplitBillPageState extends State<SplitBillPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');
  final TransactionController _transactionController =
      Get.find(tag: 'TransactionController');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Split Bill Transaction",
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
          child: CustomButtonBlue(
            "SPLIT BILL NOW",
            onPressed: () {
              Get.dialog(
                Confirmation(
                  title: "Warning!",
                  subtitle: "Are you sure want to split bill now?",
                  onOk: () {
                    _transactionController.payStandSplitBill();
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: OtherExt().getWidth(context),
              color: _theme.accent.value,
              padding: EdgeInsets.symmetric(
                horizontal: CDimension.space16,
                vertical: CDimension.space12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    "Total Amount",
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        SheetSplitDetail(),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: CText(
                      StringExt.formatRupiah(
                        _transactionController.getTotalAfterPPNCart(),
                      ),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText(
                    "SPLIT BILL WITH",
                    color: _theme.textSubtitle.value,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  Obx(
                    () => ListView.separated(
                      itemCount:
                          _transactionController.listParticipant.length > 4
                              ? 4
                              : _transactionController.listParticipant.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: CDimension.space12,
                          ),
                          child: CDivider(height: 0.5),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        var _item =
                            _transactionController.listParticipant[index];
                        return Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_base.checkMenu("topup")) {
                                    Get.to(
                                      TopUpPage(nfcUid: _item.nfc_uid!),
                                    );
                                  } else {
                                    CToast.showWithoutCOntext(
                                      "You dont have permission to topup",
                                      _theme.error.value,
                                      Colors.white,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(CDimension.space12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _theme.accent.value,
                                  ),
                                  child: CText(
                                    StringExt.getInitialTwoName(
                                        _item.customer_name ?? ""),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: CDimension.space12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CText(
                                      _item.customer_name ?? "-",
                                      fontSize: 14,
                                      color: _theme.textTitle.value,
                                    ),
                                    SizedBox(
                                      height: CDimension.space8,
                                    ),
                                    CText(
                                      StringExt.formatRupiah(
                                          _item.last_balance),
                                      fontSize: 12,
                                      color: _theme.textSubtitle.value,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: !_transactionController
                                            .listIsManual[index]
                                        ? Colors.transparent
                                        : Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: CustomInputForm(
                                  textEditingController: _transactionController
                                      .listParticipantAmountController[index],
                                  hintText: "",
                                  errorMessage: "",
                                  keyboardType: TextInputType.number,
                                  isCurrency: true,
                                  onChanged: (v) {
                                    _transactionController
                                        .updateByManualChanges(v, index);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: CDimension.space8,
                              ),
                              Obx(
                                () => _transactionController
                                            .listParticipant.length >
                                        1
                                    ? GestureDetector(
                                        onTap: () {
                                          _transactionController
                                              .deleteParticipant(index);
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          width: CDimension.space40,
                                          padding: EdgeInsets.all(8),
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_trash.svg",
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  CustomButtonBorderBlack(
                    "Add More Participant",
                    width: OtherExt().getWidth(context),
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        right: CDimension.space12,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/ic_add_participant.svg",
                        width: 20,
                      ),
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        SheetNFC(
                          type: NFCModeType.Participant,
                        ),
                        isScrollControlled: true,
                      );
                    },
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
