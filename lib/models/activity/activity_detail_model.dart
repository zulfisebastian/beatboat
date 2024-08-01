class ActivityDetailResponse {
  ActivityDetailData? data;
  String? message;
  String? code;

  ActivityDetailResponse({
    this.data,
    this.message,
    this.code,
  });

  ActivityDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new ActivityDetailData.fromJson(json['data'])
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

class ActivityDetailData {
  String? activity;
  String? number;
  String? bill_type;
  String? customer_name;
  String? nfc_uid;
  int? amount;
  String? last_update;
  String? pic;
  String? method;
  String? image_url;

  ActivityDetailData({
    this.activity,
    this.number,
    this.bill_type,
    this.customer_name,
    this.nfc_uid,
    this.amount,
    this.last_update,
    this.pic,
    this.method,
    this.image_url,
  });

  ActivityDetailData.fromJson(Map<String, dynamic> json) {
    activity = json['activity'];
    number = json['number'];
    bill_type = json['bill_type'];
    customer_name = json['customer_name'];
    nfc_uid = json['nfc_uid'];
    amount = json['amount'];
    last_update = json['last_update'];
    pic = json['pic'];
    method = json['method'];
    image_url = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity'] = this.activity;
    data['number'] = this.number;
    data['bill_type'] = this.bill_type;
    data['customer_name'] = this.customer_name;
    data['nfc_uid'] = this.nfc_uid;
    data['amount'] = this.amount;
    data['last_update'] = this.last_update;
    data['pic'] = this.pic;
    data['method'] = this.method;
    data['image_url'] = this.image_url;
    return data;
  }
}
