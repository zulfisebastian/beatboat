import 'menu_model.dart';

class ProfileResponse {
  ProfileData? data;
  String? message;
  String? code;

  ProfileResponse({
    this.data,
    this.message,
    this.code,
  });

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
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

class ProfileData {
  String? id;
  String? full_name;
  String? username;
  String? email;
  String? role;
  String? status;
  int? is_listen_printer;
  List<MenuData>? menus;

  ProfileData({
    this.id,
    this.full_name,
    this.username,
    this.email,
    this.role,
    this.status,
    this.is_listen_printer,
    this.menus,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    full_name = json['full_name'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    status = json['status'];
    is_listen_printer = json['is_listen_printer'];
    if (json['menus'] != null) {
      menus = <MenuData>[];
      json['menus'].forEach((v) {
        menus?.add(new MenuData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.full_name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['role'] = this.role;
    data['status'] = this.status;
    data['is_listen_printer'] = this.is_listen_printer;
    return data;
  }
}
