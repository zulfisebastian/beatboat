class NationalityResponse {
  List<String>? data;
  String? message;
  String? code;

  NationalityResponse({
    this.data,
    this.message,
    this.code,
  });

  NationalityResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <String>[];
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
