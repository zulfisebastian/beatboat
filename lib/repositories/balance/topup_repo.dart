import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/balance/topup_model.dart';
import '../../models/voucher/voucher_model.dart';
import '../base/base_repo.dart';

class TopUpRepo extends BaseRepo {
  Future<TopupResponse> topupBalance(body) async {
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

  Future<VoucherResponse> checkVoucher(body) async {
    BaseResult response = await post(
      Endpoint.voucher,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = VoucherResponse.fromJson(response.data);
        return _resp;
      default:
        return VoucherResponse(message: response.errorMessage);
    }
  }
}
