import 'package:beatboat/models/base/base_response.dart';

import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/bartender/bartender_model.dart';
import '../base/base_repo.dart';

class BartenderRepo extends BaseRepo {
  Future<BartenderResponse> getFoodOrder(body) async {
    BaseResult response = await get(
      Endpoint.bartender,
      queryParameters: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = BartenderResponse.fromJson(response.data);
        return _resp;
      default:
        return BartenderResponse(message: response.errorMessage);
    }
  }

  Future<BaseResponse> putMarkDone(body, id) async {
    BaseResult response = await put(
      Endpoint.markDone.replaceAll("{id}", id),
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
