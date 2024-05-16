class VoucherResponse {
  VoucherData? data;
  String? message;
  String? code;

  VoucherResponse({
    this.data,
    this.message,
    this.code,
  });

  VoucherResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new VoucherData.fromJson(json['data']) : null;
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

class VoucherData {
  String? voucher_code;
  String? type;
  int? nominal;
  int? max_discount;
  int? quota;
  int? used_quota;
  String? expired_at;

  VoucherData({
    this.voucher_code,
    this.type,
    this.nominal,
    this.max_discount,
    this.quota,
    this.used_quota,
    this.expired_at,
  });

  VoucherData.fromJson(Map<String, dynamic> json) {
    voucher_code = json['voucher_code'];
    type = json['type'];
    nominal = json['nominal'];
    max_discount = json['max_discount'];
    quota = json['quota'];
    used_quota = json['used_quota'];
    expired_at = json['expired_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['voucher_code'] = this.voucher_code;
    data['type'] = this.type;
    data['nominal'] = this.nominal;
    data['max_discount'] = this.max_discount;
    data['quota'] = this.quota;
    data['used_quota'] = this.used_quota;
    data['expired_at'] = this.expired_at;
    return data;
  }
}
