class PrinterResponse {
  List<PrinterData>? data;
  String? message;
  String? code;

  PrinterResponse({
    this.data,
    this.message,
    this.code,
  });

  PrinterResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PrinterData>[];
      json['data'].forEach((v) {
        data?.add(new PrinterData.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toList();
    }
    data['messages'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class PrinterData {
  String? ip;
  String? value;
  String? name;

  PrinterData({
    this.ip,
    this.value,
    this.name,
  });

  PrinterData.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip'] = this.ip;
    data['value'] = this.value;
    data['name'] = this.name;
    return data;
  }
}
