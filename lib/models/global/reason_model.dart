class ReasonResponse {
  ReasonData? data;
  String? message;
  String? code;

  ReasonResponse({
    this.data,
    this.message,
    this.code,
  });

  ReasonResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ReasonData.fromJson(json['data']) : null;
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

class ReasonData {
  List<String>? reasons;
  String? message;
  String? code;

  ReasonData({
    this.reasons,
    this.message,
    this.code,
  });

  ReasonData.fromJson(Map<String, dynamic> json) {
    if (json['reasons'] != null) {
      reasons = <String>[];
      json['reasons'].forEach((v) {
        reasons?.add(v);
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reasons != null) {
      data['reasons'] = this.reasons?.map((v) => v).toList();
    }
    data['messages'] = this.message;
    data['code'] = this.code;
    return data;
  }
}
