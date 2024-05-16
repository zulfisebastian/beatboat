class TopupResponse {
  TopupData? data;
  String? message;
  String? code;

  TopupResponse({
    this.data,
    this.message,
    this.code,
  });

  TopupResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new TopupData.fromJson(json['data']) : null;
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

class TopupData {
  String? wristband_code;
  String? nfc_uid;
  int? last_balance;

  TopupData({
    this.wristband_code,
    this.nfc_uid,
    this.last_balance,
  });

  TopupData.fromJson(Map<String, dynamic> json) {
    wristband_code = json['wristband_code'];
    nfc_uid = json['nfc_uid'];
    last_balance = json['last_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wristband_code'] = this.wristband_code;
    data['nfc_uid'] = this.nfc_uid;
    data['last_balance'] = this.last_balance;
    return data;
  }
}
