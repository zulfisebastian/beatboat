import 'package:beatboat/constants/size.dart';
import 'package:beatboat/models/checkin/checkin_model.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/card/package_card.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/enums.dart';
import '../../controllers/checkin/checkin_controller.dart';
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
                  "Done Pairing",
                  width: OtherExt().getWidth(context),
                  disabled: _checkinController.disabledForm.value,
                  onPressed: () {
                    onFinish();
                  },
                ),
              ),
            ),
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
                              //
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
                    Container(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CText(
                                  "Packages",
                                  color: _theme.textTitle.value,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //
                                  },
                                  child: CText(
                                    "See All",
                                    color: _theme.accent.value,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                            itemBuilder: (BuildContext context, int index) {
                              var _data = _checkinController
                                  .checkinData.value.packages![index];
                              return PackageCard(data: _data);
                            },
                          ),
                        ],
                      ),
                    ),
                    CDivider(height: 10),
                    //The Bookers Data
                    ListView.separated(
                      itemCount: _checkinController.getListMaster().length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: CDimension.space12,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        var _book = _checkinController.getListMaster()[index];
                        return Container(
                          padding: EdgeInsets.all(
                            CDimension.space20,
                          ),
                          decoration: BoxDecoration(
                            color: _theme.backgroundApp.value,
                            borderRadius: BorderRadius.circular(
                              CDimension.space16,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CText(
                                "${_book.name} / ${_book.resource_tag}",
                                fontSize: 14,
                                color: _theme.accent.value,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: CDimension.space16,
                              ),
                              Container(
                                width: OtherExt().getWidth(context),
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
                                          "${StringExt.formatRupiah(_book.min_spending)}",
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
                                          "${StringExt.thousandFormatter(_book.max_onboard)}",
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
                                height: CDimension.space16,
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
                                  vertical: CDimension.space16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: _book.isFromResp
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CText(
                                                  "Name",
                                                  fontSize: CFontSize.font14,
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                CText(
                                                  _book.customer_name,
                                                  color: _theme.textTitle.value,
                                                  fontSize: CFontSize.font16,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space16,
                                                ),
                                                CText(
                                                  "Nationality",
                                                  fontSize: CFontSize.font14,
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                CText(
                                                  _book.nationality,
                                                  color: _theme.textTitle.value,
                                                  fontSize: CFontSize.font16,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space16,
                                                ),
                                                CText(
                                                  "Age",
                                                  fontSize: CFontSize.font14,
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                CText(
                                                  _book.dob,
                                                  color: _theme.textTitle.value,
                                                  fontSize: CFontSize.font16,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space16,
                                                ),
                                                CText(
                                                  "Gender",
                                                  fontSize: CFontSize.font14,
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                CText(
                                                  _book.gender,
                                                  color: _theme.textTitle.value,
                                                  fontSize: CFontSize.font16,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space16,
                                                ),
                                                CText(
                                                  "Wristband NFC UID",
                                                  fontSize: CFontSize.font14,
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                CText(
                                                  _book.nfc_uid,
                                                  color: _theme.textTitle.value,
                                                  fontSize: CFontSize.font16,
                                                ),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CText(
                                                  "Name",
                                                  fontSize: CFontSize.font14,
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                CustomInputForm(
                                                  textEditingController:
                                                      _checkinController
                                                          .listNameCtrl[index],
                                                  hintText: "Input Your Name",
                                                  errorMessage: "",
                                                  onChanged: (v) {
                                                    _checkinController
                                                        .changeName(index, v);
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space16,
                                                ),
                                                CText(
                                                  "Nationality",
                                                  fontSize: CFontSize.font14,
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    Get.bottomSheet(
                                                      SheetNationality(
                                                        data: _checkinController
                                                            .listNationality,
                                                        choosed: _checkinController
                                                            .listNationalityCtrl[
                                                                index]
                                                            .text,
                                                        onChoose: (v) {
                                                          Get.back();
                                                          _checkinController
                                                              .listNationalityCtrl[
                                                                  index]
                                                              .text = v;
                                                          ;
                                                          _checkinController
                                                              .changeNationality(
                                                            index,
                                                            v,
                                                          );
                                                        },
                                                      ),
                                                      isScrollControlled: true,
                                                    );
                                                  },
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  child: AbsorbPointer(
                                                    absorbing: true,
                                                    child: CustomInputForm(
                                                      textEditingController:
                                                          _checkinController
                                                                  .listNationalityCtrl[
                                                              index],
                                                      hintText:
                                                          "Choose Nationality",
                                                      errorMessage: "",
                                                      keyboardType:
                                                          TextInputType.name,
                                                      onChanged: (v) {
                                                        _checkinController
                                                            .changeNationality(
                                                          index,
                                                          v,
                                                        );
                                                      },
                                                      suffixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 16),
                                                        child: Icon(
                                                          Icons
                                                              .keyboard_arrow_down_rounded,
                                                          color: _theme
                                                              .textTitle.value,
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
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    Get.bottomSheet(
                                                      SheetGender(
                                                        data: [
                                                          "Male",
                                                          "Female"
                                                        ],
                                                        choosed:
                                                            _checkinController
                                                                .listGenderCtrl[
                                                                    index]
                                                                .text,
                                                        onChoose: (v) {
                                                          Get.back();
                                                          _checkinController
                                                              .listGenderCtrl[
                                                                  index]
                                                              .text = v;
                                                          ;
                                                          _checkinController
                                                              .changeGender(
                                                                  index, v);
                                                        },
                                                      ),
                                                      isScrollControlled: true,
                                                    );
                                                  },
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  child: AbsorbPointer(
                                                    absorbing: true,
                                                    child: CustomInputForm(
                                                      textEditingController:
                                                          _checkinController
                                                                  .listGenderCtrl[
                                                              index],
                                                      hintText: "Choose Gender",
                                                      errorMessage: "",
                                                      keyboardType:
                                                          TextInputType.name,
                                                      onChanged: (v) {
                                                        _checkinController
                                                            .changeGender(
                                                                index, v);
                                                      },
                                                      suffixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 16),
                                                        child: Icon(
                                                          Icons
                                                              .keyboard_arrow_down_rounded,
                                                          color: _theme
                                                              .textTitle.value,
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
                                                  color:
                                                      _theme.textSubtitle.value,
                                                ),
                                                SizedBox(
                                                  height: CDimension.space8,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    DatePicker.showDatePicker(
                                                      context,
                                                      onMonthChangeStartWithFirstDate:
                                                          true,
                                                      pickerTheme:
                                                          DateTimePickerTheme(
                                                        showTitle: true,
                                                        confirm: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16,
                                                          ),
                                                          child: CText(
                                                            "Save",
                                                            color: _theme
                                                                .accent.value,
                                                          ),
                                                        ),
                                                      ),
                                                      minDateTime: DateTime(
                                                          DateTime.now().year -
                                                              75),
                                                      maxDateTime: DateTime(
                                                          DateTime.now().year -
                                                              17),
                                                      initialDateTime:
                                                          _checkinController
                                                              .listDate[index],
                                                      dateFormat: "yyyy-MMM-dd",
                                                      locale:
                                                          DateTimePickerLocale
                                                              .id,
                                                      onClose: () => print(
                                                          "----- onClose -----"),
                                                      onCancel: () =>
                                                          print('onCancel'),
                                                      onChange: (dateTime,
                                                          List<int> _) {},
                                                      onConfirm: (dateTime,
                                                          List<int> _) {
                                                        _checkinController
                                                                .listDate[
                                                            index] = dateTime;
                                                        _checkinController
                                                            .listDate
                                                            .refresh();
                                                        _checkinController
                                                                .listDateCtrl[index]
                                                                .text =
                                                            DateExt.reformat(
                                                          _checkinController
                                                              .listDate[index]
                                                              .toString(),
                                                          "yyyy-MM-dd hh:mm:ss",
                                                          "EEEE, dd MMM yyyy",
                                                        );
                                                        _checkinController
                                                            .changeDOB(
                                                                index,
                                                                DateExt
                                                                    .reformat(
                                                                  dateTime
                                                                      .toString(),
                                                                  "yyyy-MM-dd hh:mm:ss",
                                                                  "yyyy-MM-dd",
                                                                ));
                                                      },
                                                    );
                                                  },
                                                  child: AbsorbPointer(
                                                    absorbing: true,
                                                    child: CustomInputForm(
                                                      textEditingController:
                                                          _checkinController
                                                                  .listDateCtrl[
                                                              index],
                                                      hintText:
                                                          "Masukkan tanggal lahir Anda",
                                                      errorMessage: "",
                                                      keyboardType:
                                                          TextInputType.name,
                                                      onChanged: (v) {
                                                        _checkinController
                                                            .changeDOB(
                                                                index, v);
                                                      },
                                                      suffixIcon: Icon(
                                                        Icons.calendar_today,
                                                        color: _theme
                                                            .textTitle.value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: CDimension.space20,
                                                ),
                                                Obx(
                                                  () => _checkinController
                                                                  .listPairedUID[
                                                                      index]
                                                                  .nfc_uid ==
                                                              "" &&
                                                          _checkinController
                                                                  .listPairedUID
                                                                  .length >
                                                              index
                                                      ? CustomButtonBorderBlack(
                                                          "Pair NFC",
                                                          width: OtherExt()
                                                              .getWidth(
                                                                  context),
                                                          disabled:
                                                              _checkinController
                                                                  .checkPairDisable(
                                                                      index),
                                                          onPressed: () {
                                                            _checkinController
                                                                .activeIndex
                                                                .value = index;
                                                            _checkinController
                                                                    .bookingCode
                                                                    .value =
                                                                _book
                                                                    .booking_code!;
                                                            _checkinController
                                                                .activeIndex
                                                                .refresh();
                                                            Get.bottomSheet(
                                                              SheetNFC(
                                                                type: NFCModeType
                                                                    .CheckIn,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : Container(
                                                          width: OtherExt()
                                                              .getWidth(
                                                                  context),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: CDimension
                                                                .space12,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: _theme
                                                                .disabled.value,
                                                          ),
                                                          child: Center(
                                                            child: CText(
                                                              "Paired Successfully",
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: CDimension.space80,
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
}
