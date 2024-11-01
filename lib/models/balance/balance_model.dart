class BalanceResponse {
  BalanceData? data;
  String? message;
  String? code;

  BalanceResponse({
    this.data,
    this.message,
    this.code,
  });

  BalanceResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new BalanceData.fromJson(json['data']) : null;
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

class BalanceData {
  String? wristband_code;
  String? nfc_uid;
  String? customer_name;
  String? type;
  String? description;
  String? position;
  String? resource_tag;
  String? table_name;
  String? voucher_code;
  int? total_credit;
  int? refundable_top_up;
  int? last_balance;
  int? total_last_balance;

  BalanceData({
    this.wristband_code,
    this.nfc_uid,
    this.customer_name,
    this.type,
    this.description,
    this.position,
    this.resource_tag,
    this.table_name,
    this.voucher_code,
    this.total_credit,
    this.refundable_top_up,
    this.last_balance,
    this.total_last_balance,
  });

  BalanceData.fromJson(Map<String, dynamic> json) {
    wristband_code = json['wristband_code'];
    nfc_uid = json['nfc_uid'];
    customer_name = json['customer_name'];
    type = json['type'];
    description = json['description'];
    position = json['position'];
    resource_tag = json['resource_tag'];
    table_name = json['table_name'];
    voucher_code = json['voucher_code'];
    last_balance = json['last_balance'];
    total_last_balance = json['total_last_balance'];
    total_credit = json['total_credit'];
    refundable_top_up = json['refundable_top_up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wristband_code'] = this.wristband_code;
    data['nfc_uid'] = this.nfc_uid;
    data['customer_name'] = this.customer_name;
    data['type'] = this.type;
    data['description'] = this.description;
    data['last_balance'] = this.last_balance;
    data['position'] = this.position;
    data['table_name'] = this.table_name;
    data['resource_tag'] = this.resource_tag;
    data['voucher_code'] = this.voucher_code;
    data['total_credit'] = this.total_credit;
    data['refundable_top_up'] = this.refundable_top_up;
    data['total_last_balance'] = this.total_last_balance;
    return data;
  }
}
