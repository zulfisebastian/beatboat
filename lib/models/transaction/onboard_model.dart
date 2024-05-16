class OnboardRequest {
  String? device_serial_number;
  String? booking_code;
  String? name;
  String? nfc_uid;
  String? customer_name;
  String? nationality;
  String? dob;
  String? gender;
  bool isFromResp = false;

  OnboardRequest({
    this.device_serial_number,
    this.booking_code,
    this.name,
    this.nfc_uid,
    this.customer_name,
    this.nationality,
    this.dob,
    this.gender,
    this.isFromResp = false,
  });

  OnboardRequest.fromJson(Map<String, dynamic> json) {
    device_serial_number = json['device_serial_number'];
    booking_code = json['booking_code'];
    name = json['name'];
    nfc_uid = json['nfc_uid'];
    customer_name = json['customer_name'];
    nationality = json['nationality'];
    dob = json['dob'];
    gender = json['gender'];
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
    data['isFromResp'] = this.isFromResp;
    return data;
  }
}
