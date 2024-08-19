import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../constants/dimension.dart';
import '../../controllers/checkin/checkin_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetSign extends StatefulWidget {
  SheetSign({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetSign> createState() => _SheetSignState();
}

class _SheetSignState extends State<SheetSign> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final CheckinController _controller = Get.find(tag: 'CheckinController');

  @override
  void initState() {
    super.initState();
    _controller.signatureController.addListener(() {
      _controller.isSignatureFilled.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.75,
      minChildSize: 0.75,
      maxChildSize: 0.76,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: _theme.backgroundApp.value,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DraggableBottomSheet(),
                SizedBox(
                  height: CDimension.space16,
                ),
                CText(
                  "Insert your signature",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  lineHeight: 1.5,
                  overflow: TextOverflow.visible,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                Container(
                  width: OtherExt().getWidth(context),
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: _theme.line.value,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Signature(
                      controller: _controller.signatureController,
                      width: OtherExt().getWidth(context),
                      height: 300,
                      backgroundColor: _theme.backgroundApp.value,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  color: _theme.backgroundApp.value,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonBorderBlack(
                          "Ambil Ulang",
                          onPressed: () {
                            _controller.signatureController.clear();
                            _controller.isSignatureFilled.value = false;
                            _controller.isSignatureFilled.refresh();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Obx(
                          () => CustomButtonBlue(
                            "Simpan",
                            disabled: !_controller.isSignatureFilled.value,
                            onPressed: () {
                              _controller.submitSign();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
