import 'package:beatboat/models/product/category_model.dart';
import 'package:beatboat/services/databases/product/category_table.dart';
import 'package:beatboat/services/databases/product/product_table.dart';
import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/product/product_model.dart';
import '../base/base_repo.dart';

class ProductRepo extends BaseRepo {
  Future<CategoryResponse> getCategory() async {
    BaseResult response = await get(Endpoint.category);
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = CategoryResponse.fromJson(response.data);
        await CategoryTable().addCategoryBatch(_resp);
        print("Table product updated");
        return _resp;
      default:
        return CategoryResponse(message: response.errorMessage);
    }
  }

  Future<ProductResponse> getProduct() async {
    BaseResult response = await get(Endpoint.product);
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = ProductResponse.fromJson(response.data);
        await ProductTable().addProductBatch(_resp);
        print("Table all product updated");
        return _resp;
      default:
        return ProductResponse(message: response.errorMessage);
    }
  }

  Future<ProductResponse> getProductByCategory(String category_id) async {
    BaseResult response =
        await get(Endpoint.productByCategory.replaceAll("{id}", category_id));
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = ProductResponse.fromJson(response.data);
        await ProductTable().addProductBatch(_resp);
        print("Table all product updated");
        return _resp;
      default:
        return ProductResponse(message: response.errorMessage);
    }
  }
}
