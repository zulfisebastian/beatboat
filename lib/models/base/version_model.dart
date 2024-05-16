class VersionResponse {
  VersionData? data;
  String? message;
  bool? status;

  VersionResponse({
    this.data,
    this.message,
    this.status,
  });

  VersionResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new VersionData.fromJson(json['data']) : null;
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

class VersionData {
  String? new_version;
  int? is_need_update;
  String? link_download;

  VersionData({
    this.new_version,
    this.is_need_update,
    this.link_download,
  });

  VersionData.fromJson(Map<String, dynamic> json) {
    new_version = json['new_version'];
    is_need_update = json['is_need_update'];
    link_download = json['link_download'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['new_version'] = this.new_version;
    data['is_need_update'] = this.is_need_update;
    data['link_download'] = this.link_download;
    return data;
  }
}
