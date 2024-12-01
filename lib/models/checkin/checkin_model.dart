import 'package:beatboat/models/package/package_model.dart';

class CheckinResponse {
  CheckinData? data;
  String? message;
  String? code;

  CheckinResponse({
    this.data,
    this.message,
    this.code,
  });

  CheckinResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CheckinData.fromJson(json['data']) : null;
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class CheckinData {
  bool? collect_signature;
  String? master_booking_code;
  String? booker_name;
  String? booker_phone;
  String? booking_date;
  String? dob;
  String? gender;
  String? nationality;
  String? payment_status;
  String? booking_status;
  String? region;
  bool? valid;
  List<PackageData>? packages;
  List<DetailCheckinData>? details;

  CheckinData({
    this.collect_signature,
    this.master_booking_code,
    this.booker_name,
    this.booker_phone,
    this.booking_date,
    this.dob,
    this.gender,
    this.nationality,
    this.payment_status,
    this.booking_status,
    this.region,
    this.valid,
    this.details,
    this.packages,
  });

  CheckinData.fromJson(Map<String, dynamic> json) {
    collect_signature = json['collect_signature'];
    master_booking_code = json['master_booking_code'];
    booker_name = json['booker_name'];
    booker_phone = json['booker_phone'];
    booking_date = json['booking_date'];
    dob = json['dob'];
    gender = json['gender'];
    nationality = json['nationality'];
    payment_status = json['payment_status'];
    nationality = json['nationality'];
    gender = json['gender'];
    booking_status = json['booking_status'];
    region = json['region'];
    dob = json['dob'];
    valid = json['valid'];
    if (json['details'] != null) {
      details = <DetailCheckinData>[];
      json['details'].forEach((v) {
        details?.add(new DetailCheckinData.fromJson(v));
      });
    }
    if (json['packages'] != null) {
      packages = <PackageData>[];
      json['packages'].forEach((v) {
        packages?.add(new PackageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collect_signature'] = this.collect_signature;
    data['master_booking_code'] = this.master_booking_code;
    data['booker_name'] = this.booker_name;
    data['booker_phone'] = this.booker_phone;
    data['booking_date'] = this.booking_date;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['nationality'] = this.nationality;
    data['payment_status'] = this.payment_status;
    data['nationality'] = this.nationality;
    data['gender'] = this.gender;
    data['booking_status'] = this.booking_status;
    data['region'] = this.region;
    data['dob'] = this.dob;
    data['valid'] = this.valid;
    if (this.details != null) {
      data['details'] = this.details?.map((v) => v.toJson()).toList();
    }
    if (this.packages != null) {
      data['packages'] = this.packages?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailCheckinData {
  String? booking_code;
  String? booker_name;
  String? name;
  String? resource_tag;
  String? reference_id;
  String? wristband_nfc_uid;
  String? customer_name;
  String? nationality;
  String? gender;
  String? dob;
  int? age;
  int? min_spending;
  int? max_onboard;
  String? booking_type;
  String? note;
  List<DetailCheckinDataOther>? others;

  DetailCheckinData({
    this.booking_code,
    this.booker_name,
    this.name,
    this.resource_tag,
    this.reference_id,
    this.wristband_nfc_uid,
    this.customer_name,
    this.nationality,
    this.gender,
    this.dob,
    this.age,
    this.min_spending,
    this.max_onboard,
    this.booking_type,
    this.note,
    this.others,
  });

  DetailCheckinData.fromJson(Map<String, dynamic> json) {
    booking_code = json['booking_code'];
    booker_name = json['booker_name'];
    name = json['name'];
    resource_tag = json['resource_tag'];
    reference_id = json['reference_id'];
    wristband_nfc_uid = json['wristband_nfc_uid'];
    customer_name = json['customer_name'];
    nationality = json['nationality'];
    gender = json['gender'];
    dob = json['dob'];
    age = json['age'];
    min_spending = json['min_spending'];
    max_onboard = json['max_onboard'];
    booking_type = json['booking_type'];
    note = json['note'];
    if (json['others'] != null) {
      others = <DetailCheckinDataOther>[];
      json['others'].forEach((v) {
        others?.add(new DetailCheckinDataOther.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_code'] = this.booking_code;
    data['booker_name'] = this.booker_name;
    data['name'] = this.name;
    data['resource_tag'] = this.resource_tag;
    data['reference_id'] = this.reference_id;
    data['wristband_nfc_uid'] = this.wristband_nfc_uid;
    data['customer_name'] = this.customer_name;
    data['nationality'] = this.nationality;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['min_spending'] = this.min_spending;
    data['max_onboard'] = this.max_onboard;
    data['booking_type'] = this.booking_type;
    data['note'] = this.note;
    if (this.others != null) {
      data['others'] = this.others?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailCheckinDataOther {
  String? type;
  String? booking_code;
  String? wristband_nfc_uid;
  String? customer_name;
  String? nationality;
  String? dob;
  String? gender;

  DetailCheckinDataOther({
    this.type,
    this.booking_code,
    this.wristband_nfc_uid,
    this.customer_name,
    this.nationality,
    this.gender,
    this.dob,
  });

  DetailCheckinDataOther.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    booking_code = json['booking_code'];
    wristband_nfc_uid = json['wristband_nfc_uid'];
    customer_name = json['customer_name'];
    nationality = json['nationality'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['types'] = this.type;
    data['booking_code'] = this.booking_code;
    data['wristband_nfc_uid'] = this.wristband_nfc_uid;
    data['customer_name'] = this.customer_name;
    data['nationality'] = this.nationality;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    return data;
  }
}
