import 'package:beatboat/models/activity/activity_detail_model.dart';

import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/activity/activity_model.dart';
import '../../models/balance/topup_model.dart';
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

  Future<ActivityDetailResponse> getDetailActivity(id) async {
    BaseResult response = await get(
      Endpoint.activityDetail.replaceAll("{id}", id),
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = ActivityDetailResponse.fromJson(response.data);
        return _resp;
      default:
        return ActivityDetailResponse(message: response.errorMessage);
    }
  }

  Future<TopupResponse> topupBalance(body) async {
    BaseResult response = await post(
      Endpoint.activity,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = TopupResponse.fromJson(response.data);
        return _resp;
      default:
        return TopupResponse(message: response.errorMessage);
    }
  }
}
