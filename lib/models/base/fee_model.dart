class FeeResponse {
  FeeData? data;
  String? message;
  bool? status;

  FeeResponse({
    this.data,
    this.message,
    this.status,
  });

  FeeResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new FeeData.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['messages'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class FeeData {
  String? type;
  int? service_tax;
  int? tax;

  FeeData({
    this.type,
    this.service_tax,
    this.tax,
  });

  FeeData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    service_tax = json['service_tax'] ?? 0;
    tax = json['tax'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['service_tax'] = this.service_tax;
    data['tax'] = this.tax;
    return data;
  }
}
