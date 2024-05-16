class LoginResponse {
  LoginData? data;
  String? message;
  String? code;

  LoginResponse({
    this.data,
    this.message,
    this.code,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
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

class LoginData {
  String? token;

  LoginData({
    this.token,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}
