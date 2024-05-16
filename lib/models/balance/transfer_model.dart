class TransferResponse {
  TransferData? data;
  String? message;
  String? code;

  TransferResponse({
    this.data,
    this.message,
    this.code,
  });

  TransferResponse.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new TransferData.fromJson(json['data']) : null;
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

class TransferData {
  String? uuid;
  String? source_nfc_id;
  int? source_last_balance;
  String? destination_nfc_uid;
  int? destination_last_balance;

  TransferData({
    this.uuid,
    this.source_nfc_id,
    this.source_last_balance,
    this.destination_nfc_uid,
    this.destination_last_balance,
  });

  TransferData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    source_nfc_id = json['source_nfc_id'];
    source_last_balance = json['source_last_balance'];
    destination_nfc_uid = json['destination_nfc_uid'];
    destination_last_balance = json['destination_last_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['source_nfc_id'] = this.source_nfc_id;
    data['source_last_balance'] = this.source_last_balance;
    data['destination_nfc_uid'] = this.destination_nfc_uid;
    data['destination_last_balance'] = this.destination_last_balance;
    return data;
  }
}
