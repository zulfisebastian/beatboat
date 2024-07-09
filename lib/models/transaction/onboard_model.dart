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
  int? min_spending;
  int? max_onboard;
  String? booking_type;
  bool isFromResp = false;

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
    this.min_spending,
    this.max_onboard,
    this.booking_type,
    this.isFromResp = false,
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
    min_spending = json['min_spending'];
    max_onboard = json['max_onboard'];
    booking_type = json['booking_type'];
    isFromResp = json['isFromResp'];
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
    data['min_spending'] = this.min_spending;
    data['max_onboard'] = this.max_onboard;
    data['booking_type'] = this.booking_type;
    data['isFromResp'] = this.isFromResp;
    return data;
  }
}
