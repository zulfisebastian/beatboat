import 'package:beatboat/constants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/checkin/checkin_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final CheckinController _controller =
      Get.put(CheckinController(), tag: 'CheckinController');

  @override
  void dispose() {
    _controller.qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _theme.backgroundApp.value,
        body: Container(
          width: OtherExt().getWidth(context),
          height: OtherExt().getHeight(context),
          child: Stack(
            children: <Widget>[
              // Positioned.fill(
              //   child: _buildQrView(context),
              // ),
              Positioned.fill(
                child: MobileScanner(
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      debugPrint('Barcode found! ${barcode.rawValue}');

                      _controller.qrController.stop();
                      // _controller.checkInEvent(context, scanData.code);
                    }
                  },
                ),
              ),
              Positioned(
                top: 20,
                child: Container(
                  width: OtherExt().getWidth(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: CDimension.space16,
                    vertical: CDimension.space16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }

  // Widget _buildQrView(BuildContext context) {
  //   return QRView(
  //     key: _controller.qrKey,
  //     onQRViewCreated: _onQRViewCreated,
  //     formatsAllowed: [BarcodeFormat.code128],
  //     overlay: QrScannerOverlayShape(
  //       borderColor: _theme.line.value,
  //       borderRadius: 5,
  //       borderLength: 30,
  //       borderWidth: 5,
  //       cutOutWidth: OtherExt().getWidth(context) - CDimension.space32,
  //       cutOutHeight: 180,
  //       overlayColor: Colors.black45,
  //       cutOutBottomOffset: 60,
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
  //   _controller.qrController!.resumeCamera();
  // }
}
