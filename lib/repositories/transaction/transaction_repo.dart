import 'package:beatboat/models/base/base_response.dart';
import 'package:beatboat/models/checkin/checkin_model.dart';
import 'package:beatboat/models/global/reason_model.dart';
import 'package:beatboat/models/transaction/add_transaction_model.dart';
import 'package:beatboat/models/transaction/transaction_model.dart';
import 'package:beatboat/models/voucher/voucher_model.dart';
import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../base/base_repo.dart';

class TransactionRepo extends BaseRepo {
  Future<AddTransactionResponse> payTransaction(body) async {
    BaseResult response = await post(
      Endpoint.transaction,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = AddTransactionResponse.fromJson(response.data);
        return _resp;
      default:
        return AddTransactionResponse(message: response.errorMessage);
    }
  }

  Future<CheckinResponse> checkIn(body) async {
    BaseResult response = await post(
      Endpoint.checkin,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = CheckinResponse.fromJson(response.data);
        return _resp;
      default:
        return CheckinResponse(message: response.errorMessage);
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

  Future<TransactionResponse> getAllTransaction() async {
    BaseResult response = await get(
      Endpoint.transaction,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = TransactionResponse.fromJson(response.data);
        return _resp;
      default:
        return TransactionResponse(message: response.errorMessage);
    }
  }

  Future<BaseResponse> refundTransaction(body) async {
    BaseResult response = await post(Endpoint.refund, body: body);
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = BaseResponse.fromJson(response.data);
        return _resp;
      default:
        return BaseResponse(message: response.errorMessage);
    }
  }

  Future<ReasonResponse> getListReason() async {
    BaseResult response = await get(
      Endpoint.reason,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = ReasonResponse.fromJson(response.data);
        return _resp;
      default:
        return ReasonResponse(message: response.errorMessage);
    }
  }
}
