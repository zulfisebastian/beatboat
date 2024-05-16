import 'dart:async';
import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../constants/enums.dart';
import '../../controllers/scanner/nfc_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../components/draggable_bottom_sheet.dart';

class SheetNFC extends StatefulWidget {
  final NFCModeType type;
  final String? writeValue;

  SheetNFC({
    Key? key,
    required this.type,
    this.writeValue,
  }) : super(key: key);

  @override
  State<SheetNFC> createState() => _SheetNFCState();
}

class _SheetNFCState extends State<SheetNFC> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final NFCController _nfcController = Get.isRegistered(tag: 'NFCController')
      ? Get.find(tag: "NFCController")
      : Get.put(NFCController(), tag: "NFCController");
  int timer = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        timer -= 1;
        if (timer < 1) Get.back();
      });
    });
    if (widget.type == NFCModeType.Pay ||
        widget.type == NFCModeType.TopUp ||
        widget.type == NFCModeType.TransferFrom ||
        widget.type == NFCModeType.TransferTo ||
        widget.type == NFCModeType.Participant ||
        widget.type == NFCModeType.Refund) {
      _nfcController.readNFC(widget.type);
    } else if (widget.type == NFCModeType.CheckIn) {
      _nfcController.onboardNFC();
    } else if (widget.type == NFCModeType.UpdateAfterPay ||
        widget.type == NFCModeType.UpdateAfterTopUp ||
        widget.type == NFCModeType.UpdateAfterTransfer) {
      _nfcController.writeNFC(widget.type, widget.writeValue!);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
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
                height: CDimension.space16,
              ),
              Lottie.asset(
                'assets/json/scanning.json',
                width: 300,
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "Please dont move your wristband until scanning process finished. Time to scan ",
                  style: TextStyle(
                    fontFamily: "Segoeui",
                    height: 1.5,
                    fontSize: CFontSize.font16,
                    color: _theme.textTitle.value,
                    overflow: TextOverflow.visible,
                  ),
                  children: [
                    TextSpan(
                      text: "${timer} seconds.",
                      style: TextStyle(
                        fontFamily: "Segoeui",
                        fontSize: CFontSize.font16,
                        color: _theme.accent.value,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
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
}
