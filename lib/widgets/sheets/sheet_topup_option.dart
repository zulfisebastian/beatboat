import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:get/get.dart';
import 'package:beatboat/constants/dimension.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../controllers/base/base_controller.dart';
import '../components/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../components/text/ctext.dart';

class SheetTopupOption extends StatefulWidget {
  final Function(String) onOther;
  final VoidCallback onEDC;

  SheetTopupOption({
    Key? key,
    required this.onOther,
    required this.onEDC,
  }) : super(key: key);

  @override
  State<SheetTopupOption> createState() => _SheetTopupOptionState();
}

class _SheetTopupOptionState extends State<SheetTopupOption> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController _base = Get.find(tag: 'BaseController');

  @override
  void initState() {
    super.initState();
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
              Obx(
                () => CText(
                  "Choose Payment Option",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var type = _base.dataProfile.value.top_up_method![index];
                  return CustomButtonBorderBlack(
                    _base.dataProfile.value.top_up_method![index],
                    width: OtherExt().getWidth(context),
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        type == "EDC"
                            ? Icons.credit_card
                            : type == "CASH"
                                ? Icons.money
                                : Icons.widgets_outlined,
                        size: 16,
                        color: _theme.textTitle.value,
                      ),
                    ),
                    onPressed: () async {
                      if (type == "EDC") {
                        widget.onEDC();
                      } else {
                        widget.onOther(
                            _base.dataProfile.value.top_up_method![index]);
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: CDimension.space16,
                  );
                },
                itemCount: _base.dataProfile.value.top_up_method!.length,
              ),
              SizedBox(
                height: CDimension.space24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
