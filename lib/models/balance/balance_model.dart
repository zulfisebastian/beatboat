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
  int? last_balance;

  BalanceData({
    this.wristband_code,
    this.nfc_uid,
    this.customer_name,
    this.type,
    this.description,
    this.last_balance,
  });

  BalanceData.fromJson(Map<String, dynamic> json) {
    wristband_code = json['wristband_code'];
    nfc_uid = json['nfc_uid'];
    customer_name = json['customer_name'];
    type = json['type'];
    description = json['description'];
    last_balance = json['last_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wristband_code'] = this.wristband_code;
    data['nfc_uid'] = this.nfc_uid;
    data['customer_name'] = this.customer_name;
    data['type'] = this.type;
    data['description'] = this.description;
    data['last_balance'] = this.last_balance;
    return data;
  }
}
