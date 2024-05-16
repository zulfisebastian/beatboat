class LinkResponse {
  LinkData? data;
  String? message;
  String? code;

  LinkResponse({
    this.data,
    this.message,
    this.code,
  });

  LinkResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LinkData.fromJson(json['data']) : null;
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

class LinkData {
  String? api_url;

  LinkData({
    this.api_url,
  });

  LinkData.fromJson(Map<String, dynamic> json) {
    api_url = json['api_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_url'] = this.api_url;
    return data;
  }
}
