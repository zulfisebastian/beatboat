import 'package:beatboat/models/base/page_model.dart';

class ActivityResponse {
  List<ActivityData>? data;
  PageData? paging;
  String? message;
  String? code;

  ActivityResponse({
    this.data,
    this.paging,
    this.message,
    this.code,
  });

  ActivityResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ActivityData>[];
      json['data'].forEach((v) {
        data?.add(new ActivityData.fromJson(v));
      });
    }
    paging =
        json['paging'] != null ? new PageData.fromJson(json['paging']) : null;
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    if (this.paging != null) {
      data['paging'] = this.paging?.toJson();
    }
    data['messages'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class ActivityData {
  String? activity;
  String? number;
  String? bill_type;
  String? customer_name;
  String? nfc_uid;
  int? amount;
  String? last_update;
  String? pic;

  ActivityData({
    this.activity,
    this.number,
    this.bill_type,
    this.customer_name,
    this.nfc_uid,
    this.amount,
    this.last_update,
    this.pic,
  });

  ActivityData.fromJson(Map<String, dynamic> json) {
    activity = json['activity'];
    number = json['number'];
    bill_type = json['bill_type'];
    customer_name = json['customer_name'];
    nfc_uid = json['nfc_uid'];
    amount = json['amount'];
    last_update = json['last_update'];
    pic = json['pic'];
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
    return data;
  }
}
