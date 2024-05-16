import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/ccached_image.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/sheets/sheet_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/endpoints.dart';
import '../../controllers/product/product_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/card/category_circle_card.dart';
import '../../widgets/components/text/ctext.dart';

class ProductPage extends StatefulWidget {
  final String? categoryId;
  ProductPage({
    Key? key,
    this.categoryId,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final ProductController _productController =
      Get.put(ProductController(), tag: 'ProductController');

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.categoryId != null) {
        _productController.getProductByCategory(widget.categoryId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _theme.backgroundApp.value,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                height: OtherExt().getHeight(context) - 90,
                margin: EdgeInsets.only(top: 56),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _productController.initAllData();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              Obx(
                                () => CategoryCircleCard(
                                  size: 54,
                                  border: 8,
                                  title: "All",
                                  image_url: Endpoint.defaultFood,
                                  active: "All" ==
                                      _productController.choosedCategory.value,
                                  onClick: () {
                                    _productController.onChooseCategory("All");
                                  },
                                ),
                              ),
                              SizedBox(
                                width: CDimension.space16,
                              ),
                              SizedBox(
                                height: 54,
                                child: Obx(
                                  () => ListView.separated(
                                    itemCount:
                                        _productController.listCategory.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        width: CDimension.space16,
                                      );
                                    },
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var _data = _productController
                                          .listCategory[index];
                                      return Obx(
                                        () => CategoryCircleCard(
                                          size: 54,
                                          border: 8,
                                          title: _data.name ?? "",
                                          active: _data.id ==
                                              _productController
                                                  .choosedCategory.value,
                                          image_url: _data.image_url ??
                                              Endpoint.defaultFood,
                                          onClick: () {
                                            _productController
                                                .getProductByCategory(
                                                    _data.id!);
                                          },
                                        ),
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
                        CDivider(
                          height: CDimension.space8,
                        ),
                        SizedBox(
                          height: CDimension.space16,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: CDimension.space16,
                          ),
                          child: Obx(
                            () => Wrap(
                              spacing: CDimension.space16,
                              runSpacing: CDimension.space16,
                              children: (_productController
                                              .choosedCategory.value ==
                                          "All"
                                      ? _productController.listProduct
                                      : _productController.listProductCategory)
                                  .map((_data) {
                                return Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            _data.stock! > 0
                                                ? Colors.transparent
                                                : Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Stack(
                                            children: [
                                              CCachedImage(
                                                width: (OtherExt()
                                                            .getWidth(context) -
                                                        CDimension.space48) /
                                                    2,
                                                height: 180,
                                                url: _data.image_url ??
                                                    Endpoint.defaultFood,
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                right: 8,
                                                child: _data.stock! > 0
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          if (_productController
                                                                  .listCart
                                                                  .where((e) =>
                                                                      e.id ==
                                                                      _data.id)
                                                                  .length >
                                                              0) {
                                                            Get.bottomSheet(
                                                              SheetProduct(),
                                                              isScrollControlled:
                                                                  true,
                                                            );
                                                          } else {
                                                            _productController
                                                                .addProductToCart(
                                                                    _data);
                                                          }
                                                        },
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        child: Obx(
                                                          () => Container(
                                                            width: CDimension
                                                                .space32,
                                                            height: CDimension
                                                                .space32,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: _theme
                                                                  .accent.value,
                                                            ),
                                                            child: Center(
                                                              child: _productController
                                                                          .listCart
                                                                          .where((e) =>
                                                                              e.id ==
                                                                              _data.id)
                                                                          .length >
                                                                      0
                                                                  ? CText(
                                                                      _productController
                                                                          .listCart
                                                                          .firstWhere((e) =>
                                                                              e.id ==
                                                                              _data.id)
                                                                          .qty,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: CDimension
                                                                          .space20,
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: CDimension.space8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CText(
                                            _data.name!.capitalizeFirst,
                                            color: _theme.textTitle.value,
                                            fontSize: 16,
                                            decoration: _data.stock! > 0
                                                ? TextDecoration.none
                                                : TextDecoration.lineThrough,
                                          ),
                                          SizedBox(
                                            height: CDimension.space12,
                                          ),
                                          CText(
                                            StringExt.formatRupiah(
                                                _data.sell_price),
                                            color: _theme.textTitle.value,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            decoration: _data.stock! > 0
                                                ? TextDecoration.none
                                                : TextDecoration.lineThrough,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: CDimension.space128,
                        ),
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
            Positioned(
              bottom: 0,
              child: Obx(
                () => _productController.listCart.length > 0
                    ? GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            SheetProduct(),
                            isScrollControlled: true,
                          );
                        },
                        child: Container(
                          width:
                              OtherExt().getWidth(context) - CDimension.space32,
                          height: 56,
                          margin: EdgeInsets.only(
                            left: CDimension.space16,
                            right: CDimension.space16,
                            bottom: CDimension.space16,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: CDimension.space24,
                            vertical: CDimension.space12,
                          ),
                          decoration: BoxDecoration(
                            color: _theme.accent.value,
                            borderRadius: BorderRadius.circular(
                              CDimension.space48,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CText(
                                "${_productController.listCart.length} item",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              CText(
                                StringExt.formatRupiah(
                                  _productController.getTotalCart(),
                                ),
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
