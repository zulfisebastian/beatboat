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
  List<DetailCheckinData>? details;

  CheckinData({
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
  });

  CheckinData.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}
