import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/base/base_response.dart';
import '../../models/resource/resource_model.dart';
import '../base/base_repo.dart';

class ResourceRepo extends BaseRepo {
  Future<ResourceResponse> getResource() async {
    BaseResult response = await get(
      Endpoint.resource,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = ResourceResponse.fromJson(response.data);
        return _resp;
      default:
        return ResourceResponse(message: response.errorMessage);
    }
  }

  Future<BaseResponse> updateResource(body) async {
    BaseResult response = await post(
      Endpoint.resourceUpgrade,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = BaseResponse.fromJson(response.data);
        return _resp;
      default:
        return BaseResponse(message: response.errorMessage);
    }
  }
}
