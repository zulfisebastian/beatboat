import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/controllers/product/product_controller.dart';
import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/endpoints.dart';
import '../../controllers/theme/theme_controller.dart';
import '../card/category_circle_card.dart';
import '../components/csearch.dart';
import '../components/text/ctext.dart';

class SheetFilter extends StatefulWidget {
  SheetFilter({
    Key? key,
  }) : super(key: key);

  @override
  State<SheetFilter> createState() => _SheetFilterState();
}

class _SheetFilterState extends State<SheetFilter> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');

  final ProductController _product = Get.find(tag: 'ProductController');

  String _choosedProduct = "All";

  @override
  void initState() {
    super.initState();

    setState(() {
      _choosedProduct = _product.choosedCategory.value;
    });
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: CDimension.space16,
              ),
              Container(
                width: OtherExt().getWidth(context),
                alignment: Alignment.center,
                child: CText(
                  "FILTER PRODUCT",
                  color: _theme.textTitle.value,
                  fontSize: CDimension.space20,
                  fontWeight: FontWeight.w800,
                  spacing: 1.4,
                ),
              ),
              SizedBox(
                height: CDimension.space12,
              ),
              Divider(),
              SizedBox(
                height: CDimension.space12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: CText(
                  "Choose Category",
                  color: _theme.textTitle.value,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Container(
                width: OtherExt().getWidth(context),
                height: 88,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: CDimension.space16,
                  ),
                  children: [
                    CategoryCircleCard(
                      size: 54,
                      border: 8,
                      title: "All",
                      image_url: Endpoint.defaultFood,
                      active: "All" == _choosedProduct,
                      onClick: () {
                        setState(() {
                          _choosedProduct = "All";
                        });
                      },
                    ),
                    SizedBox(
                      width: CDimension.space16,
                    ),
                    SizedBox(
                      height: 54,
                      child: Obx(
                        () => ListView.separated(
                          itemCount: _product.listCategory.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: CDimension.space16,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var _data = _product.listCategory[index];
                            return CategoryCircleCard(
                              size: 54,
                              border: 8,
                              title: _data.name ?? "",
                              active: _data.id == _choosedProduct,
                              image_url:
                                  _data.image_url ?? Endpoint.defaultFood,
                              onClick: () {
                                setState(() {
                                  _choosedProduct = _data.id!;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: CText(
                  "Search",
                  color: _theme.textTitle.value,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: CDimension.space16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CDimension.space24,
                ),
                child: CSearch(
                  textEditingController: _product.search.value,
                  hintText: "Input name of product",
                  errorMessage: "Not Found",
                  onChanged: (v) {},
                ),
              ),
              SizedBox(
                height: CDimension.space24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: CustomButtonBlue(
                  "SEARCH",
                  width: OtherExt().getWidth(context),
                  onPressed: () {
                    _product.onSubmitFilter(
                      _choosedProduct,
                    );
                  },
                ),
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
