import 'package:beatboat/constants/size.dart';
import 'package:beatboat/models/checkin/checkin_model.dart';
import 'package:beatboat/models/transaction/onboard_model.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/card/package_card.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:beatboat/widgets/sheets/sheet_agreement.dart';
import 'package:beatboat/widgets/sheets/sheet_checkin_detail.dart';
import 'package:beatboat/widgets/sheets/sheet_package.dart';
import 'package:beatboat/widgets/sheets/sheet_sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/enums.dart';
import '../../controllers/checkin/checkin_controller.dart';
import '../../controllers/package/package_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/customAppBar.dart';
import '../../widgets/components/customInputForm.dart';
import '../../widgets/components/text/ctext.dart';
import '../../widgets/popups/confirmation.dart';
import '../../widgets/sheets/sheet_gender.dart';
import '../../widgets/sheets/sheet_nationality.dart';
import '../../widgets/sheets/sheet_nfc.dart';

class CheckinDetailPage extends StatelessWidget {
  final String title;
  final CheckinData data;
  final String action;
  final VoidCallback onFinish;

  CheckinDetailPage({
    Key? key,
    required this.title,
    required this.data,
    required this.action,
    required this.onFinish,
  }) : super(key: key);

  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final CheckinController _checkinController =
      Get.find(tag: 'CheckinController');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.dialog(
          Confirmation(
            title: "Warning!",
            subtitle: "Are you sure want to close this page?",
            onOk: () {
              Get.back();
              Get.back();
            },
          ),
        );
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            context: context,
            title: "Check-In Detail",
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _checkinController.onRefresh();
            },
            child: SingleChildScrollView(
              child: Container(
                width: OtherExt().getWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: CDimension.space20,
                        vertical: CDimension.space16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => CText(
                              "Booked by - ${_checkinController.checkinData.value.booker_name}",
                              color: _theme.textTitle.value,
                              fontSize: 16,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                SheetCheckinDetail(data: data),
                                isScrollControlled: true,
                              );
                            },
                            child: CText(
                              "See Details",
                              color: _theme.accent.value,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CDivider(height: 10),
                    //Packages
                    Obx(
                      () => _checkinController
                                  .checkinData.value.packages!.length >
                              0
                          ? Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: CDimension.space16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: CDimension.space16,
                                    ),
                                    child: CText(
                                      "Packages",
                                      color: _theme.textTitle.value,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: CDimension.space12,
                                  ),
                                  ListView.separated(
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: CDimension.space12,
                                        ),
                                        child: CDivider(height: 1),
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var _data = _checkinController
                                          .checkinData.value.packages![index];
                                      final PackageController _ = Get.put(
                                        PackageController(),
                                        tag: "PackageController",
                                      );
                                      return PackageCard(
                                        data: _data,
                                        index: index,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: CDimension.space12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: CDimension.space16,
                                    ),
                                    child: CustomButtonBlue(
                                        "See All Packages (${_checkinController.checkinData.value.packages!.length})",
                                        width: OtherExt().getWidth(context),
                                        onPressed: () {
                                      Get.bottomSheet(
                                        SheetPackage(
                                          data: _checkinController
                                              .checkinData.value.packages!,
                                        ),
                                        isScrollControlled: true,
                                      );
                                    }),
                                  ),
                                  CDivider(height: 10),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ),
                    //Category
                    ListView.separated(
                      itemCount: _checkinController.getListCategory().length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return CDivider(height: 10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        var _data = _checkinController.getListCategory()[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: CDimension.space16,
                            vertical: CDimension.space16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CText(
                                "${_data.name} / ${_data.resource_tag}",
                                fontSize: 14,
                                color: _theme.accent.value,
                                fontWeight: FontWeight.bold,
                              ),
                              Container(
                                width: OtherExt().getWidth(context),
                                margin: EdgeInsets.only(
                                  top: CDimension.space16,
                                ),
                                decoration: BoxDecoration(
                                  color: _theme.line.value.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: CDimension.space16,
                                  vertical: CDimension.space12,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CText(
                                          "Minimum Spending",
                                          fontSize: 14,
                                          color: _theme.textTitle.value,
                                        ),
                                        CText(
                                          "${StringExt.formatRupiah(_data.min_spending)}",
                                          fontSize: 14,
                                          color: _theme.textTitle.value,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: CDimension.space12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CText(
                                          "Max Onboard",
                                          fontSize: 14,
                                          color: _theme.textTitle.value,
                                        ),
                                        CText(
                                          "${StringExt.thousandFormatter(_data.max_onboard)}",
                                          fontSize: 14,
                                          color: _theme.textTitle.value,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: _theme.line.value,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: CDimension.space12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      itemCount: _checkinController
                                          .getListFormByCategory(
                                              "${_data.resource_tag}")
                                          .length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return CDivider(
                                          height: 1,
                                          color: _theme.accent.value,
                                        );
                                      },
                                      itemBuilder: (BuildContext context,
                                          int _indexData) {
                                        var _bookData = _checkinController
                                            .getListFormByCategory(_data
                                                .resource_tag!)[_indexData];
                                        var _bookIndex = _checkinController
                                            .getIndexByResource(
                                                _bookData.booking_code!);

                                        return _dataForm(
                                          context,
                                          _bookIndex,
                                          _indexData,
                                          _bookData,
                                          _checkinController
                                              .listNameCtrl[_bookIndex],
                                          _checkinController
                                              .listNationalityCtrl[_bookIndex],
                                          _checkinController
                                              .listGenderCtrl[_bookIndex],
                                          _checkinController
                                              .listDateCtrl[_bookIndex],
                                          _checkinController
                                              .listDate[_bookIndex],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataForm(
    context,
    int index,
    int indexNo,
    OnboardRequest _data,
    TextEditingController _name,
    TextEditingController _nationality,
    TextEditingController _gender,
    TextEditingController _dateOfBirth,
    DateTime _dateTime,
  ) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        tilePadding: EdgeInsets.zero,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CText(
                  _data.booking_type != "others"
                      ? _data.resource_tag == "GA"
                          ? "${_data.name} ${indexNo + 1}"
                          : _data.name
                      : "Data Onboard ${indexNo}",
                  color: _theme.accent.value,
                ),
                SizedBox(
                  child: Obx(
                    () => _checkinController.listPairedUID[index].nfc_uid == ""
                        ? SizedBox()
                        : Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.check_circle_outline,
                                color: _theme.success.value,
                              ),
                            ],
                          ),
                  ),
                )
              ],
            ),
            if (_data.note != "")
              Container(
                margin: EdgeInsets.only(top: 8),
                width: OtherExt().getWidth(context),
                // decoration: BoxDecoration(
                //   color: _theme.line.value,
                //   borderRadius: BorderRadius.circular(6),
                // ),
                // padding: EdgeInsets.all(8),
                child: CText(
                  _data.note,
                  color: _theme.textSubtitle.value,
                  fontSize: 12,
                ),
              )
          ],
        ),
        childrenPadding: EdgeInsets.only(
          bottom: 10,
        ),
        children: [
          Column(
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
                textEditingController: _name,
                hintText: "Input Your Name",
                errorMessage: "",
                onChanged: (v) {
                  _checkinController.changeName(index, v);
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
                      data: _checkinController.listNationality,
                      choosed: _nationality.text,
                      onChoose: (v) {
                        Get.back();
                        _nationality.text = v;
                        ;
                        _checkinController.changeNationality(
                          index,
                          v,
                        );
                      },
                    ),
                    isScrollControlled: true,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomInputForm(
                    textEditingController: _nationality,
                    hintText: "Choose Nationality",
                    errorMessage: "",
                    keyboardType: TextInputType.name,
                    onChanged: (v) {
                      _checkinController.changeNationality(
                        index,
                        v,
                      );
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
                      choosed: _gender.text,
                      onChoose: (v) {
                        Get.back();
                        _gender.text = v;
                        ;
                        _checkinController.changeGender(index, v);
                      },
                    ),
                    isScrollControlled: true,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomInputForm(
                    textEditingController: _gender,
                    hintText: "Choose Gender",
                    errorMessage: "",
                    keyboardType: TextInputType.name,
                    onChanged: (v) {
                      _checkinController.changeGender(index, v);
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
                    initialDateTime: _dateTime,
                    dateFormat: "yyyy-MMM-dd",
                    locale: DateTimePickerLocale.id,
                    onClose: () => print("----- onClose -----"),
                    onCancel: () => print('onCancel'),
                    onChange: (dateTime, List<int> _) {},
                    onConfirm: (dateTime, List<int> _) {
                      _dateTime = dateTime;
                      _dateOfBirth.text = DateExt.reformat(
                        _dateTime.toString(),
                        "yyyy-MM-dd hh:mm:ss",
                        "EEEE, dd MMM yyyy",
                      );
                      _checkinController.changeDOB(
                        index,
                        DateExt.reformat(
                          dateTime.toString(),
                          "yyyy-MM-dd hh:mm:ss",
                          "yyyy-MM-dd",
                        ),
                      );
                    },
                  );
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomInputForm(
                    textEditingController: _dateOfBirth,
                    hintText: "Masukkan tanggal lahir Anda",
                    errorMessage: "",
                    keyboardType: TextInputType.name,
                    onChanged: (v) {
                      _checkinController.changeDOB(index, v);
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
                () => _checkinController.listPairedUID[index].nfc_uid == ""
                    ? CustomButtonBorderBlack(
                        "Pair NFC",
                        width: OtherExt().getWidth(context),
                        disabled: _checkinController.checkPairDisable(index),
                        onPressed: () {
                          // print(_data.dob);
                          Get.bottomSheet(
                            SheetAgreement(
                              onAgree: () {
                                Get.back();
                                _checkinController.activeIndex.value = index;
                                _checkinController.activeIndex.refresh();
                                _checkinController.bookingCode.value =
                                    _data.booking_code!;
                                if (_checkinController
                                    .checkinData.value.collect_signature!) {
                                  Get.bottomSheet(
                                    SheetSign(),
                                    isScrollControlled: true,
                                  );
                                } else {
                                  Get.bottomSheet(
                                    SheetNFC(
                                      type: NFCModeType.CheckIn,
                                    ),
                                  );
                                }
                              },
                            ),
                            isScrollControlled: true,
                          );
                        },
                      )
                    : Container(
                        width: OtherExt().getWidth(context),
                        padding: EdgeInsets.symmetric(
                          vertical: CDimension.space12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _theme.disabled.value,
                        ),
                        child: Center(
                          child: CText(
                            "Paired Successfully",
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
