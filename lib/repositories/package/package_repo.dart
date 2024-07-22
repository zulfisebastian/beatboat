import 'package:beatboat/models/base/base_response.dart';
import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/package/package_model.dart';
import '../base/base_repo.dart';

class PackageRepo extends BaseRepo {
  Future<PackageResponse> getPackage(nfcUID) async {
    BaseResult response = await get(
      Endpoint.package.replaceAll("{nfc}", nfcUID),
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = PackageResponse.fromJson(response.data);
        return _resp;
      default:
        return PackageResponse(message: response.errorMessage);
    }
  }

  Future<BaseResponse> addPackage(body, nfcUID) async {
    BaseResult response = await post(
      Endpoint.package.replaceAll("{nfc}", nfcUID),
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
