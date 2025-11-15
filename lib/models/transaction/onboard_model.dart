class OnboardRequest {
  String? device_serial_number;
  String? booking_code;
  String? name;
  String? resource_tag;
  String? nfc_uid;
  String? customer_name;
  String? nationality;
  String? dob;
  String? gender;
  String? target;
  int? min_spending;
  int? max_onboard;
  String? booking_type;
  String? note;
  bool isFromResp = false;
  List<OnboardOtherRequest>? others;

  OnboardRequest({
    this.device_serial_number,
    this.booking_code,
    this.name,
    this.resource_tag,
    this.nfc_uid,
    this.customer_name,
    this.nationality,
    this.dob,
    this.gender,
    this.target,
    this.min_spending,
    this.max_onboard,
    this.booking_type,
    this.note,
    this.isFromResp = false,
    this.others,
  });

  OnboardRequest.fromJson(Map<String, dynamic> json) {
    device_serial_number = json['device_serial_number'];
    booking_code = json['booking_code'];
    name = json['name'];
    resource_tag = json['resource_tag'];
    nfc_uid = json['nfc_uid'];
    customer_name = json['customer_name'];
    nationality = json['nationality'];
    dob = json['dob'];
    gender = json['gender'];
    target = json['target'];
    min_spending = json['min_spending'];
    max_onboard = json['max_onboard'];
    booking_type = json['booking_type'];
    note = json['note'];
    isFromResp = json['isFromResp'];

    if (json['others'] != null) {
      others = <OnboardOtherRequest>[];
      json['others'].forEach((v) {
        others?.add(new OnboardOtherRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_serial_numbers'] = this.device_serial_number;
    data['booking_code'] = this.booking_code;
    data['name'] = this.name;
    data['nfc_uid'] = this.nfc_uid;
    data['customer_name'] = this.customer_name;
    data['nationality'] = this.nationality;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['target'] = this.target;
    data['min_spending'] = this.min_spending;
    data['max_onboard'] = this.max_onboard;
    data['booking_type'] = this.booking_type;
    data['note'] = this.note;
    data['isFromResp'] = this.isFromResp;

    if (this.others != null) {
      data['others'] = this.others?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OnboardOtherRequest {
  String? type;
  String? booking_code;
  String? nfc_uid;
  String? customer_name;
  String? nationality;
  String? dob;
  String? gender;

  OnboardOtherRequest({
    this.type,
    this.booking_code,
    this.nfc_uid,
    this.customer_name,
    this.nationality,
    this.gender,
    this.dob,
  });

  OnboardOtherRequest.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    booking_code = json['booking_code'];
    nfc_uid = json['nfc_uid'];
    customer_name = json['customer_name'];
    nationality = json['nationality'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['types'] = this.type;
    data['booking_code'] = this.booking_code;
    data['nfc_uid'] = this.nfc_uid;
    data['customer_name'] = this.customer_name;
    data['nationality'] = this.nationality;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    return data;
  }
}
