import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/cdivider.dart';
import 'package:beatboat/widgets/components/csearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../constants/dimension.dart';
import '../../constants/endpoints.dart';
import '../../controllers/product/product_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../widgets/card/category_circle_card.dart';
import '../../widgets/components/text/ctext.dart';
import '../../widgets/sheets/sheet_adjust_stock.dart';
import '../../widgets/sheets/sheet_another.dart';
import '../../widgets/sheets/sheet_cart.dart';

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
  final ProductController _product =
      Get.put(ProductController(), tag: 'ProductController');

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _product.initAllData();
      if (widget.categoryId != null) {
        _product.choosedCategory(widget.categoryId!);
      }
      _product.getDataProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _theme.backgroundApp.value,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                height: OtherExt().getHeight(context) - 90,
                margin: EdgeInsets.only(top: 56),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _product.initAllData();
                  },
                  child: SingleChildScrollView(
                    controller: _product.scrollController,
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
                                  active:
                                      "All" == _product.choosedCategory.value,
                                  onClick: () {
                                    _product.onChooseCategory("All");
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
                                    itemCount: _product.listCategory.length,
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
                                      var _data = _product.listCategory[index];
                                      return Obx(
                                        () => CategoryCircleCard(
                                          size: 54,
                                          border: 8,
                                          title: _data.name ?? "",
                                          active: _data.id ==
                                              _product.choosedCategory.value,
                                          image_url: _data.image_url ??
                                              Endpoint.defaultFood,
                                          onClick: () {
                                            _product
                                                .onChooseCategory(_data.id!);
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: CDimension.space16,
                          ),
                          child: CSearch(
                            textEditingController: _product.search.value,
                            hintText: "Search Product By Name",
                            errorMessage: "Not Found",
                            onChanged: (v) {
                              _product.onSearchChanged(v);
                            },
                          ),
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
                              spacing: CDimension.space6,
                              runSpacing: CDimension.space16,
                              children: _product.listProduct.map((_data) {
                                return Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_data.stock! > 0) {
                                            if (_product.listCart
                                                    .where((e) =>
                                                        e.product_id ==
                                                        _data.id)
                                                    .length >
                                                0) {
                                              _product.choosedProduct.value =
                                                  _data;
                                              _product.choosedProduct.refresh();

                                              Get.bottomSheet(
                                                SheetAnother(),
                                                isScrollControlled: true,
                                              );
                                            } else {
                                              _product.choosedProduct.value =
                                                  _data;
                                              _product.choosedProduct.refresh();
                                              _product.addProductToCart(_data);
                                            }
                                          } else {
                                            _product.choosedProduct.value =
                                                _data;
                                            _product.choosedProduct.refresh();
                                            _product.fromStockNull.value = true;
                                            Get.bottomSheet(
                                              SheetAdjustStock(),
                                              isScrollControlled: true,
                                            );
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              _data.stock! > 0
                                                  ? Colors.transparent
                                                  : Colors.grey,
                                              BlendMode.saturation,
                                            ),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: _theme.line.value,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Image.network(
                                                      _data.image_url ??
                                                          Endpoint.defaultFood,
                                                      width: (OtherExt()
                                                                  .getWidth(
                                                                      context) -
                                                              50) /
                                                          3,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 8,
                                                  right: 8,
                                                  child: _data.stock! > 0
                                                      ? Obx(
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
                                                              child: _product
                                                                          .listCart
                                                                          .where((e) =>
                                                                              e.product_id ==
                                                                              _data.id)
                                                                          .length >
                                                                      0
                                                                  ? CText(
                                                                      _product.getCartQtyLength(
                                                                          _data),
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
                                                        )
                                                      : SizedBox(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: CDimension.space8,
                                      ),
                                      SizedBox(
                                        width: (OtherExt().getWidth(context) -
                                                50) /
                                            3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CText(
                                              _data.name!.capitalizeFirst,
                                              color: _theme.textTitle.value,
                                              fontSize: 12,
                                              decoration: _data.stock! > 0
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough,
                                              overflow: TextOverflow.visible,
                                              lineHeight: 1.4,
                                            ),
                                            SizedBox(
                                              height: CDimension.space12,
                                            ),
                                            CText(
                                              StringExt.formatRupiah(
                                                  _data.sell_price),
                                              color: _theme.textTitle.value,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              decoration: _data.stock! > 0
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough,
                                            ),
                                          ],
                                        ),
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
                      "MENU",
                      color: _theme.textTitle.value,
                      fontSize: CDimension.space20,
                      fontWeight: FontWeight.w800,
                      spacing: 1.4,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Obx(
                () => _product.listCart.length > 0
                    ? GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            SheetCart(),
                            isScrollControlled: true,
                          );
                          // Get.to(OrderPage());
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
                                "${_product.listCart.length} item",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              CText(
                                StringExt.formatRupiah(
                                  _product.getTotalCart(),
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
            Obx(
              () => _product.isLoadMoreData.value
                  ? Positioned(
                      bottom: CDimension.space80,
                      child: Material(
                        elevation: CDimension.space20,
                        borderRadius: BorderRadius.circular(
                          CDimension.space24,
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(
                              CDimension.space4,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircularProgressIndicator(
                              color: _theme.accent.value,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Positioned(bottom: CDimension.space16, child: SizedBox()),
            ),
          ],
        ),
      ),
    );
  }
}
