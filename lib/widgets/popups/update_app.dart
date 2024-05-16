import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/base/base_controller.dart';
import '../../utils/extensions.dart';
import '../components/text/ctext.dart';

class UpdateApp extends StatelessWidget {
  final Function oncallbackCancel;
  UpdateApp({
    Key? key,
    required this.oncallbackCancel,
  }) : super(key: key);

  final BaseController _base = Get.find(tag: "BaseController");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Dialog(
        backgroundColor: Colors.white,
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CText(
                  "New Version is Available",
                  color: Colors.black,
                  align: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: 24,
                ),
                Image.asset(
                  "assets/images/img_update.png",
                ),
                SizedBox(
                  height: 24,
                ),
                CText(
                  "Update the app for a better experience.",
                  color: Colors.black,
                  align: TextAlign.center,
                  fontSize: 14,
                  lineHeight: 1.3,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    // if (_base.dataVersion.value.forceUpdate == 0)
                    //   Expanded(
                    //     child: CustomButtonBorderBlack(
                    //       "Later",
                    //       width: OtherExt().getWidth(context),
                    //       onPressed: () {
                    //         oncallbackCancel();
                    //       },
                    //     ),
                    //   ),
                    // if (_base.dataVersion.value.forceUpdate == 0)
                    //   SizedBox(
                    //     width: 8,
                    //   ),
                    Expanded(
                      child: CustomButtonBlue(
                        "Update Now",
                        width: OtherExt().getWidth(context),
                        onPressed: () async {
                          // String url =
                          //     _base.dataVersion.value.link_download ?? "";
                          String url =
                              "https://partner.sunmi.com/developManage/app/31662/detail";
                          // : "https://play.google.com/store/apps/details?id=com.rebelworks.maxi_app_prod";

                          await launchUrl(Uri.parse(url));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
