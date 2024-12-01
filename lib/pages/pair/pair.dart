import 'package:beatboat/constants/size.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/enums.dart';
import '../../controllers/pair/pair_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customInputForm.dart';
import '../../widgets/components/text/ctext.dart';
import '../../widgets/sheets/sheet_gender.dart';
import '../../widgets/sheets/sheet_nationality.dart';
import '../../widgets/sheets/sheet_nfc.dart';

class PairPage extends StatelessWidget {
  PairPage({
    Key? key,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final PairController _pairController =
      Get.put(PairController(), tag: 'PairController');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          context: context,
          title: "Pair NFC",
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _pairController.onRefresh();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Container(
              width: OtherExt().getWidth(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText(
                    "Name",
                    fontSize: CFontSize.font14,
                    color: _theme.textSubtitle.value,
                  ),
                  SizedBox(
                    height: CDimension.space8,
                  ),
                  CustomInputForm(
                    textEditingController: _pairController.nameCtrl.value,
                    hintText: "Input Your Name",
                    errorMessage: "",
                    onChanged: (v) {
                      _pairController.nameCtrl.value.text = v;
                      _pairController.nameCtrl.refresh();
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  CText(
                    "Nationality",
                    fontSize: CFontSize.font14,
                    color: _theme.textSubtitle.value,
                  ),
                  SizedBox(
                    height: CDimension.space8,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Get.bottomSheet(
                        SheetNationality(
                          data: _pairController.listNationality,
                          choosed: _pairController.nationalityCtrl.value.text,
                          onChoose: (v) {
                            Get.back();
                            _pairController.nationalityCtrl.value.text = v;
                            _pairController.nationalityCtrl.refresh();
                          },
                        ),
                        isScrollControlled: true,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      absorbing: true,
                      child: CustomInputForm(
                        textEditingController:
                            _pairController.nationalityCtrl.value,
                        hintText: "Choose Nationality",
                        errorMessage: "",
                        keyboardType: TextInputType.name,
                        onChanged: (v) {
                          _pairController.nationalityCtrl.value.text = v;
                          _pairController.nationalityCtrl.refresh();
                        },
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _theme.textTitle.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  CText(
                    "Gender",
                    fontSize: CFontSize.font14,
                    color: _theme.textSubtitle.value,
                  ),
                  SizedBox(
                    height: CDimension.space8,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Get.bottomSheet(
                        SheetGender(
                          data: ["Male", "Female"],
                          choosed: _pairController.genderCtrl.value.text,
                          onChoose: (v) {
                            Get.back();
                            _pairController.genderCtrl.value.text = v;
                            _pairController.genderCtrl.refresh();
                          },
                        ),
                        isScrollControlled: true,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      absorbing: true,
                      child: CustomInputForm(
                        textEditingController: _pairController.genderCtrl.value,
                        hintText: "Choose Gender",
                        errorMessage: "",
                        keyboardType: TextInputType.name,
                        onChanged: (v) {
                          _pairController.genderCtrl.value.text = v;
                          _pairController.genderCtrl.refresh();
                        },
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _theme.textTitle.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space16,
                  ),
                  CText(
                    "Date Of Birth",
                    fontSize: CFontSize.font14,
                    color: _theme.textSubtitle.value,
                  ),
                  SizedBox(
                    height: CDimension.space8,
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        onMonthChangeStartWithFirstDate: true,
                        pickerTheme: DateTimePickerTheme(
                          showTitle: true,
                          confirm: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: CText(
                              "Save",
                              color: _theme.accent.value,
                            ),
                          ),
                        ),
                        minDateTime: DateTime(DateTime.now().year - 75),
                        maxDateTime: DateTime(DateTime.now().year - 17),
                        initialDateTime: _pairController.date.value,
                        dateFormat: "yyyy-MMM-dd",
                        locale: DateTimePickerLocale.id,
                        onClose: () => print("----- onClose -----"),
                        onCancel: () => print('onCancel'),
                        onChange: (dateTime, List<int> _) {},
                        onConfirm: (dateTime, List<int> _) {
                          _pairController.date.value = dateTime;
                          _pairController.date.refresh();
                          _pairController.dateCtrl.value.text =
                              DateExt.reformat(
                            dateTime.toString(),
                            "yyyy-MM-dd hh:mm:ss",
                            "EEEE, dd MMM yyyy",
                          );
                          _pairController.dateCtrl.refresh();
                        },
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: CustomInputForm(
                        textEditingController: _pairController.dateCtrl.value,
                        hintText: "Masukkan tanggal lahir Anda",
                        errorMessage: "",
                        keyboardType: TextInputType.name,
                        onChanged: (v) {
                          _pairController.dateCtrl.value.text =
                              DateExt.reformat(
                            _pairController.date.value.toString(),
                            "yyyy-MM-dd hh:mm:ss",
                            "EEEE, dd MMM yyyy",
                          );
                          _pairController.dateCtrl.refresh();
                        },
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: _theme.textTitle.value,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: CDimension.space20,
                  ),
                  Obx(
                    () => CustomButtonBorderBlack(
                      "Pair NFC",
                      width: OtherExt().getWidth(context),
                      disabled: _pairController.checkPairDisable(),
                      onPressed: () {
                        Get.bottomSheet(
                          SheetNFC(
                            type: NFCModeType.Pair,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
