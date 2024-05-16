import '../../../models/base/base_result.dart';
import '../../models/global/link_model.dart';
import '../base/base_init_repo.dart';

class LinkRepo extends BaseInitRepo {
  Future<LinkResponse> getLink() async {
    BaseResult response = await get("/endpoint");
    switch (response.status) {
      case ResponseStatus.Success:
        return LinkResponse.fromJson(response.data);
      default:
        return LinkResponse(message: response.errorMessage);
    }
  }
}
