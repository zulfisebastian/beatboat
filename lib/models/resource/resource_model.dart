class ResourceResponse {
  List<ResourceData>? data;
  String? message;
  String? code;

  ResourceResponse({
    this.data,
    this.message,
    this.code,
  });

  ResourceResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ResourceData>[];
      json['data'].forEach((v) {
        data?.add(new ResourceData.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['messages'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class ResourceData {
  String? table_name;
  String? resource_tag;
  String? position;

  ResourceData({
    this.table_name,
    this.resource_tag,
    this.position,
  });

  ResourceData.fromJson(Map<String, dynamic> json) {
    table_name = json['table_name'];
    resource_tag = json['resource_tag'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_name'] = this.table_name;
    data['resource_tag'] = this.resource_tag;
    data['position'] = this.position;
    return data;
  }
}
