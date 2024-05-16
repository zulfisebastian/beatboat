import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/activity/activity_model.dart';
import '../../services/databases/activity/activity_table.dart';
import '../base/base_repo.dart';

class ActivityRepo extends BaseRepo {
  Future<ActivityResponse> getActivity(body) async {
    BaseResult response = await get(
      Endpoint.activity,
      queryParameters: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = ActivityResponse.fromJson(response.data);
        await ActivityTable().addActivityBatch(_resp);
        print("Table activity updated");
        return _resp;
      default:
        return ActivityResponse(message: response.errorMessage);
    }
  }
}
