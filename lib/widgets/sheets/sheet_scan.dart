import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controllers/checkin/checkin_controller.dart';
import '../../controllers/theme/theme_controller.dart';
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

  late Barcode result;

  @override
  void dispose() {
    _controller.qrController?.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DraggableBottomSheet(),
              SizedBox(
                height: CDimension.space24,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  CDimension.space24,
                ),
                child: Container(
                  width: OtherExt().getWidth(context),
                  height: 540,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: _buildQrView(context),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _controller.qrController?.toggleFlash();
                                  setState(() {});
                                },
                                child: FutureBuilder(
                                  future: _controller.qrController
                                      ?.getFlashStatus(),
                                  builder: (context, snapshot) {
                                    return Container(
                                      width: CDimension.space48,
                                      height: CDimension.space48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_flashlight.svg",
                                        width: 16,
                                      ),
                                    );
                                  },
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
              SizedBox(
                height: CDimension.space32,
              ),
              // CustomButtonBlue(
              //   "Simulate Scanned Card",
              //   width: OtherExt().getWidth(context),
              //   onPressed: () {
              //     widget.onTap();
              //   },
              // ),
              // SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: _controller.qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: _theme.line.value,
        borderRadius: 5,
        borderLength: 30,
        borderWidth: 5,
        overlayColor: Colors.black45,
        cutOutWidth: OtherExt().getWidth(context) - CDimension.space48,
        cutOutHeight: 180,
        cutOutBottomOffset: 30,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this._controller.qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      _controller.qrController!.stopCamera();
      _controller.checkInEvent(context, scanData.code);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
