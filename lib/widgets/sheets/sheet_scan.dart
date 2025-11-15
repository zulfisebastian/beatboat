import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/checkin/checkin_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/customButton.dart';
import '../components/customInputForm.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetScan extends StatefulWidget {
  SheetScan({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetScan> createState() => _SheetScanState();
}

class _SheetScanState extends State<SheetScan> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final CheckinController _controller =
      Get.isRegistered(tag: 'CheckinController')
          ? Get.find(tag: 'CheckinController')
          : Get.put(CheckinController(), tag: 'CheckinController');

  @override
  void dispose() {
    _controller.qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: _theme.backgroundApp.value,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              DraggableBottomSheet(),
              SizedBox(
                height: CDimension.space16,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: _theme.line.value,
                  ),
                  borderRadius: BorderRadius.circular(
                    CDimension.space16,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _controller.changeTypeSearch("SCAN");
                          _controller.qrController.start();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: _controller.typeSearch.value == "SCAN"
                                  ? _theme.accent.value
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(
                                CDimension.space16,
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CText(
                                "SCAN",
                                color: _controller.typeSearch.value == "SCAN"
                                    ? Colors.white
                                    : _theme.textTitle.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: CDimension.space12,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _controller.changeTypeSearch("MANUAL");
                          _controller.qrController.stop();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: _controller.typeSearch.value == "MANUAL"
                                  ? _theme.accent.value
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(
                                CDimension.space16,
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CText(
                                "MANUAL",
                                color: _controller.typeSearch.value == "MANUAL"
                                    ? Colors.white
                                    : _theme.textTitle.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Obx(
                () => _controller.typeSearch.value == "SCAN"
                    ? Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              CDimension.space24,
                            ),
                            child: Container(
                              width: OtherExt().getWidth(context),
                              height: 400,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: MobileScanner(
                                      controller: _controller.qrController,
                                      onDetect: (capture) {
                                        final List<Barcode> barcodes =
                                            capture.barcodes;
                                        for (final barcode in barcodes) {
                                          debugPrint(
                                              'Barcode found! ${barcode.rawValue}');

                                          _controller.qrController.stop();
                                          _controller.checkInEvent(
                                            context,
                                            barcode.rawValue,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: Container(
                                      width: OtherExt().getWidth(context),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: CDimension.space16,
                                        vertical: CDimension.space16,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Obx(
                                            () => GestureDetector(
                                              onTap: () async {
                                                _controller.toggleTorch();
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: SvgPicture.asset(
                                                  _controller.torchEnabled.value
                                                      ? "assets/icons/ic_flashlight.svg"
                                                      : "",
                                                  width: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: CDimension.space24,
                          ),
                          CText(
                            "Scan your barcode that you received in your email",
                            fontSize: 14,
                            lineHeight: 1.5,
                            align: TextAlign.center,
                            overflow: TextOverflow.visible,
                            color: _theme.textTitle.value,
                          ),
                          SizedBox(
                            height: CDimension.space16,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          CustomInputForm(
                            textEditingController: _controller.barcode.value,
                            hintText: "Input The Barcode",
                            errorMessage: "Please Input The Barcode",
                            onChanged: (v) {},
                          ),
                          SizedBox(
                            height: CDimension.space24,
                          ),
                          CustomButtonBlue(
                            "Check Barcode",
                            width: OtherExt().getWidth(context),
                            onPressed: () {
                              _controller.checkInEvent(
                                context,
                                _controller.barcode.value.text,
                              );
                            },
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
              ),
              SizedBox(
                height: CDimension.space32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildQrView(BuildContext context) {
  //   return QRView(
  //     key: _controller.qrKey,
  //     onQRViewCreated: _onQRViewCreated,
  //     overlay: QrScannerOverlayShape(
  //       borderColor: _theme.line.value,
  //       borderRadius: 5,
  //       borderLength: 30,
  //       borderWidth: 5,
  //       overlayColor: Colors.black45,
  //       cutOutWidth: OtherExt().getWidth(context) - CDimension.space48,
  //       cutOutHeight: 140,
  //       cutOutBottomOffset: 30,
  //     ),
  //     onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
  //   );
  // }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this._controller.qrController = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) async {
  //     _controller.qrController!.stopCamera();
  //     _controller.checkInEvent(context, scanData.code);
  //   });
  // }

  // void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
  //   if (!p) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('no Permission')),
  //     );
  //   }
  // }
}
