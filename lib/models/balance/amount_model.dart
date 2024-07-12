class AmountResponse {
  List<int>? data;
  String? message;
  String? code;

  AmountResponse({
    this.data,
    this.message,
    this.code,
  });

  AmountResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <int>[];
      json['data'].forEach((v) {
        data?.add(v);
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v).toList();
    }
    data['messages'] = this.message;
    data['code'] = this.code;
    return data;
  }
}
