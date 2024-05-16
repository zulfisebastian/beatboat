import 'package:beatboat/widgets/card/card_transaction.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/refund/refund_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/components/customAppBar.dart';

class RefundPage extends StatefulWidget {
  const RefundPage({Key? key}) : super(key: key);

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final RefundController _refundController = Get.put(
    RefundController(),
    tag: "RefundController",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundApp.value,
      appBar: CustomAppBar(
        context: context,
        title: "Transaction Refund",
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => _refundController.listTransaction.length > 0
              ? Container(
                  child: ListView.separated(
                    itemCount: _refundController.listTransaction.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: CDimension.space4,
                        ),
                        child: CDivider(height: 1),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var _data = _refundController.listTransaction[index];
                      return CardTransaction(
                        data: _data,
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(
                    CDimension.space16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: CText(
                          "No Data Transaction",
                          color: _theme.textTitle.value,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
