import 'dart:async';

import 'package:beatboat/constants/endpoints.dart';
import 'package:beatboat/models/global/print_model.dart';
import 'package:beatboat/models/transaction/transaction_model.dart';
import 'package:beatboat/pages/auth/login.dart';
import 'package:beatboat/repositories/global/global_repo.dart';
import 'package:beatboat/repositories/global/link_repo.dart';
import 'package:beatboat/widgets/sheets/sheet_device_registered.dart';
import 'package:beatboat/widgets/sheets/sheet_failed.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import '../../models/auth/profile_model.dart';
import '../../models/base/version_model.dart';
import '../../repositories/auth/profile_repo.dart';
import '../../services/databases/database_services.dart';
import '../../utils/extensions.dart';
import '../../utils/shared_pref.dart';
import '../../widgets/pages/loading.dart';

class BaseController extends GetxController {
  final GlobalKey keyScreenshot = new GlobalKey();
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  final ProfileRepo _repoProfile = Get.put(ProfileRepo());
  final LinkRepo _linkRepo = Get.put(LinkRepo());
  final GlobalRepo _globalRepo = Get.put(GlobalRepo());

  Rx<bool> isConnected = false.obs;

  RxInt currentTooltip = 0.obs;

  final RxInt _currentPage = 0.obs;
  RxInt get currentPage => _currentPage;

  final PageController pageController = PageController();

  RxBool deviceIOS = true.obs;
  RxBool isLogout = false.obs;

  RxBool tabEnabled = true.obs;

  RxBool isLogedIn = false.obs;
  changeIsLogedIn() {
    isLogedIn.value = true;
    isLogedIn.refresh();
  }

  @override
  void onReady() {
    setCamera();
    super.onReady();
    initConnectivity();
    onInitiate();
  }

  onInitiate() async {
    await initLink();
    await initPrinterIP();
    initNFC();
    triggerPrinter(500);
    getBaseVersion();
  }

  RxString linkUrl = "".obs;

  Future<String> initLink() async {
    var _resp = await _linkRepo.getLink();

    if (_resp.data != null) {
      var link = _resp.data!.api_url!;
      linkUrl.value = link;
      return link;
    } else {
      return Endpoint.baseUrl;
    }
  }

  RxList<PrinterData> printerThermal = <PrinterData>[].obs;

  initPrinterIP() async {
    var _resp = await _globalRepo.getPrinterSetting();

    if (_resp.data != null) {
      printerThermal.value = _resp.data!;
      printerThermal.refresh();
    }
  }

  initConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    isInternetConnected(result);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isInternetConnected(result);
    });
  }

  bool isInternetConnected(ConnectivityResult? result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      isConnected.value = true;
      return true;
    }
    return false;
  }

  setCamera() async {
    cameras.value = await availableCameras();
  }

  logout() async {
    await SharedPref.clearVariable();
    isLogedIn.value = false;
    isLogout.value = true;
    DatabaseServices().deleteDatabase();
    Get.offAll(LoginPage());
  }

  notificationClicked(
    String type,
    String transactionCode,
    String commentCode,
    String postCode,
    bool canClicked,
    bool fromPushNotif,
    String file,
  ) {
    // NotificationController _control = Get.put(NotificationController());

    // if (type == "mood_tracker") {
    //   if (fromPushNotif) Navigation().toDashboard();
    //   Get.to(
    //     MemoriesAddPage(
    //       data: MemoriesData(
    //         moodCode: "",
    //       ),
    //       title: DateExt.reformat(
    //         DateTime.now().toString(),
    //         "yyyy-MM-dd",
    //         "dd MMM yyyy",
    //       ),
    //       from: "push notification",
    //     ),
    //   );
    // } else if (type == "nps") {
    //   if (fromPushNotif) Navigation().toDashboard();
    //   Navigation().toAssestment(type);
    // } else if (type == "flourishing" ||
    //     type == "gallup_12" ||
    //     type == "dass_21" ||
    //     type == "nps") {
    //   if (fromPushNotif) Navigation().toDashboard();
    //   Navigation().toAssestment(type);
    // } else if (type == "apps") {
    //   if (fromPushNotif) Navigation().toDashboard();
    //   Navigation().toProvideFeedback();
    // } else if (type == "leave_a_comment") {
    //   if (fromPushNotif) Navigation().toDashboard();
    //   MainController _main = Get.find(tag: 'mainController');
    //   _main.setPage(0);
    // } else if (type == "like_comment") {
    //   if (canClicked) {
    //     if (commentCode == "") {
    //       _control.fetchDataComment(
    //         type,
    //         postCode,
    //         transactionCode,
    //       );
    //     } else {
    //       _control.fetchDataComment(
    //         type,
    //         postCode,
    //         commentCode,
    //       );
    //     }
    //   }
    // } else if (type == "reply_comment") {
    //   if (canClicked) {
    //     _control.fetchDataComment(
    //       type,
    //       postCode,
    //       commentCode,
    //     );
    //   }
    // } else if (type == "reservation_confirmed") {
    //   if (fromPushNotif) Navigation().toDashboard();
    //   Get.to(
    //     CounselingDetailPage(
    //       reservationCode: transactionCode,
    //       isPast: false,
    //     ),
    //   );
    // } else if (type == "chat") {
    //   if (checkIsPsycholog()) {
    //     Navigation().toDashboard();
    //     setPage(2);
    //   } else {
    //     Navigation().toDashboard();
    //     Navigation().toChooseCrisis();
    //     //
    //   }
    // } else {
    //   //
    // }
  }

  Rx<ProfileData> dataProfile = ProfileData().obs;
  getProfile() async {
    if (isLogedIn.value) {
      var _resp = await _repoProfile.getProfile();

      if (_resp.data != null) {
        dataProfile.value = _resp.data!;
        dataProfile.refresh();

        isDeviceKitchen.value = dataProfile.value.is_listen_printer ?? 0;
        isDeviceKitchen.refresh();
      }
    }
  }

  bool checkMenu(String menu) {
    var index =
        dataProfile.value.menus!.indexWhere((e) => e.menu_slug!.contains(menu));
    return index > -1;
  }

  Rx<NFCAvailability> nfcIsAvailable = NFCAvailability.not_supported.obs;
  Future<void> initNFC() async {
    try {
      nfcIsAvailable.value = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      nfcIsAvailable.value = NFCAvailability.not_supported;
    }
    nfcIsAvailable.refresh();
  }

  registerDevice(
    String udid,
    String deviceName,
  ) async {
    Get.dialog(
      Loading(),
      barrierDismissible: false,
    );
    var body = {
      "device_serial_number": udid,
      "device_name": deviceName,
    };
    Get.back();

    var _resp = await _globalRepo.registerDevice(body);
    Get.back();

    if (_resp.code == "SCC-DEVICE-001") {
      Get.bottomSheet(
        SheetDeviceRegistered(),
      );
    } else {
      Get.bottomSheet(
        SheetFailed(errorMessage: _resp.message!),
      );
    }
  }

  RxInt isDeviceKitchen = 0.obs;

  triggerPrinter(int _milliseconds) async {
    Future.delayed(
      Duration(milliseconds: _milliseconds),
      () async {
        if (isDeviceKitchen.value == 1) {
          String udid = Get.find(tag: "udid");

          var body = {
            "device_serial_number": udid,
          };

          var _resp = await _globalRepo.triggerPrinter(body);

          if (_resp.data != null) {
            await printBill(_resp.data!);
            print("HIT AFTER 5000 ms");
            triggerPrinter(5000);
          } else {
            print("HIT AFTER 500 ms - true");
            triggerPrinter(2000);
          }
        } else {
          print("HIT AFTER 500 ms - false");
          triggerPrinter(1000);
        }
      },
    );
  }

  printBill(TransactionData _data) async {
    await getProfile();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.bindingPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.bold();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Order No: ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${_data.order_no ?? '-'}",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Customer: ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: _data.customer_name ?? "-",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    //Item
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setFontSize(SunmiFontSize.LG);
    for (var _item in _data.details!) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: _item.product!.name ?? "-",
          width: 15,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "x${_item.qty!.toString()}",
          width: 4,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    }
    await SunmiPrinter.resetBold();
    await SunmiPrinter.resetFontSize();
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'No: ${_data.number}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.printText(
      'Trx Date: ${DateExt.reformat(DateTime.now().toString(), "yyyy-MM-dd HH:mm", "dd MMM yyyy (HH:mm)")}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.printText(
      'Cashier: ${dataProfile.value.full_name}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.printText(
      'Table Name: ${_data.table_name}',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ),
    );
    await SunmiPrinter.lineWrap(4);
    await SunmiPrinter.cut();
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.exitTransactionPrint(true);
  }

  Rx<VersionData> dataVersion = VersionData().obs;
  getBaseVersion() async {
    final String _version = Get.find(tag: 'appVersion');
    var body = {
      "version": _version,
    };

    var _resp = await _globalRepo.getVersionData(body);

    if (_resp.data != null) {
      dataVersion.value = _resp.data!;
      dataVersion.refresh();
    }
  }

  RxString printerLink = "".obs;
  Rx<TextEditingController> printer = TextEditingController().obs;

  changePrinterLink() {
    Get.back();
    printerLink.value = printer.value.text;
    printerLink.refresh();
  }
}
