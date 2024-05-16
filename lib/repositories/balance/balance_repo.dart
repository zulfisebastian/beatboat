import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/balance/balance_model.dart';
import '../../models/balance/topup_model.dart';
import '../../models/balance/transfer_model.dart';
import '../../models/base/base_response.dart';
import '../base/base_repo.dart';

class BalanceRepo extends BaseRepo {
  Future<BalanceResponse> checkBalance(body) async {
    BaseResult response = await post(
      Endpoint.balance,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = BalanceResponse.fromJson(response.data);
        return _resp;
      default:
        return BalanceResponse(message: response.errorMessage);
    }
  }

  Future<TopupResponse> topupWristband(body) async {
    BaseResult response = await post(
      Endpoint.topup,
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

  Future<TransferResponse> transferBalance(body) async {
    BaseResult response = await post(
      Endpoint.transfer,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = TransferResponse.fromJson(response.data);
        return _resp;
      default:
        return TransferResponse(message: response.errorMessage);
    }
  }

  Future<BaseResponse> onboard(body) async {
    BaseResult response = await post(
      Endpoint.onboard,
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
