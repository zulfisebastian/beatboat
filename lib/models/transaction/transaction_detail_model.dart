import 'transaction_model.dart';

class TransactionDetailResponse {
  TransactionData? data;
  String? message;
  String? code;

  TransactionDetailResponse({
    this.data,
    this.message,
    this.code,
  });

  TransactionDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new TransactionData.fromJson(json['data'])
        : null;
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['messages'] = this.message;
    data['code'] = this.code;
    return data;
  }
}
