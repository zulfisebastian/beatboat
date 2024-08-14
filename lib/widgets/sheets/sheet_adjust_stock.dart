import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/controllers/product/product_controller.dart';
import 'package:beatboat/widgets/components/ccached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../models/product/product_model.dart';
import '../../utils/extensions.dart';
import '../components/customButton.dart';
import '../components/customInputForm.dart';
import '../components/draggable_bottom_sheet.dart';
import '../components/text/ctext.dart';

class SheetAdjustStock extends StatefulWidget {
  SheetAdjustStock({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetAdjustStock> createState() => _SheetAdjustStockState();
}

class _SheetAdjustStockState extends State<SheetAdjustStock> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ProductController _product = Get.find(tag: 'ProductController');

  @override
  void dispose() {
    if (_product.fromStockNull.value) {
      _product.fromStockNull.value = false;
      _product.fromStockNull.refresh();
      _product.choosedProduct.value = ProductData();
      _product.choosedProduct.refresh();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.4,
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
                CText(
                  "Adjust Stock",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _theme.textTitle.value,
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _theme.backgroundCard.value,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: _theme.line.value,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CCachedImage(
                          width: 50,
                          height: 50,
                          url: _product.choosedProduct.value.image_url!,
                        ),
                      ),
                      SizedBox(
                        width: CDimension.space12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CText(
                            _product.choosedProduct.value.name,
                            color: _theme.textTitle.value,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: CDimension.space4,
                          ),
                          CText(
                            "Stock left : ${_product.choosedProduct.value.stock}",
                            color: _theme.textTitle.value,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                CustomInputForm(
                  textEditingController: _product.stock.value,
                  hintText: "Input Stock",
                  errorMessage: "",
                  keyboardType: TextInputType.number,
                  onChanged: (v) {},
                ),
                SizedBox(
                  height: CDimension.space16,
                ),
                CustomButtonBlue(
                  "Adjust Stock",
                  width: OtherExt().getWidth(context),
                  onPressed: () {
                    _product.adjustStock();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
