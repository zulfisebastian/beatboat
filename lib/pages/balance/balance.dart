import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../controllers/balance/balance_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../../widgets/components/text/ctext.dart';

class BalancePage extends StatefulWidget {
  final String nfcUid;

  const BalancePage({
    Key? key,
    required this.nfcUid,
  }) : super(key: key);

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BalanceController _balanceController =
      Get.put(BalanceController(), tag: 'BalanceController');

  @override
  void initState() {
    super.initState();
    _balanceController.checkBalance(widget.nfcUid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                height: OtherExt().getHeight(context) - 90,
                margin: EdgeInsets.only(top: 56),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _balanceController.checkBalance(widget.nfcUid);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: OtherExt().getWidth(context),
                // color: _theme.accent.value,
                padding: EdgeInsets.symmetric(
                  horizontal: CDimension.space16,
                  vertical: CDimension.space16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 32,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: CDimension.space4,
                    ),
                    CText(
                      "Product",
                      color: _theme.textTitle.value,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
