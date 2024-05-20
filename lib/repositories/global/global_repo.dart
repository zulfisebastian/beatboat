import 'package:beatboat/models/base/base_response.dart';
import 'package:beatboat/models/global/nationality_model.dart';
import 'package:beatboat/models/global/print_model.dart';
import 'package:beatboat/models/global/reason_model.dart';
import 'package:beatboat/models/global/trigger_model.dart';
import '../../../models/base/base_result.dart';
import '../../constants/endpoints.dart';
import '../../models/base/version_model.dart';
import '../base/base_repo.dart';

class GlobalRepo extends BaseRepo {
  Future<BaseResponse> registerDevice(body) async {
    BaseResult response = await post(
      Endpoint.device,
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

  Future<NationalityResponse> getNationality() async {
    BaseResult response = await get(
      Endpoint.nationality,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = NationalityResponse.fromJson(response.data);
        return _resp;
      default:
        return NationalityResponse(message: response.errorMessage);
    }
  }

  Future<ReasonResponse> getReasons() async {
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

  Future<TriggerResponse> triggerPrinter(body) async {
    BaseResult response = await post(
      Endpoint.trigger,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        var _resp = TriggerResponse.fromJson(response.data);
        return _resp;
      default:
        return TriggerResponse(message: response.errorMessage);
    }
  }

  Future<VersionResponse> getVersionData(dynamic body) async {
    BaseResult response = await post(
      Endpoint.version,
      body: body,
    );
    switch (response.status) {
      case ResponseStatus.Success:
        return VersionResponse.fromJson(response.data);
      default:
        return VersionResponse(status: false, message: response.errorMessage);
    }
  }

  Future<PrinterResponse> getPrinterSetting() async {
    BaseResult response = await get("/device-printer");
    switch (response.status) {
      case ResponseStatus.Success:
        return PrinterResponse.fromJson(response.data);
      default:
        return PrinterResponse(message: response.errorMessage);
    }
  }
}
