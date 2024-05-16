import 'package:beatboat/models/base/base_response.dart';
import 'package:beatboat/services/databases/profile/menu_table.dart';
import 'package:beatboat/services/databases/profile/profile_table.dart';

import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/auth/profile_model.dart';
import '../base/base_repo.dart';

class ProfileRepo extends BaseRepo {
  Future<ProfileResponse> getProfile() async {
    BaseResult response = await get(
      Endpoint.profile,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = ProfileResponse.fromJson(response.data);
        await ProfileTable().addProfile(_resp.data!);
        print("Table profile updated");
        await MenuTable().addMenuBatch(_resp.data!.menus);
        print("Table menu updated");
        return _resp;
      default:
        return ProfileResponse(message: response.errorMessage);
    }
  }

  Future<BaseResponse> editProfile(body) async {
    BaseResult response = await put(
      Endpoint.editProfile,
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
