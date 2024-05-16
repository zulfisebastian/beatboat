class CategoryResponse {
  List<CategoryData>? data;
  String? message;
  String? code;

  CategoryResponse({
    this.data,
    this.message,
    this.code,
  });

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data?.add(new CategoryData.fromJson(v));
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

class CategoryData {
  String? id;
  String? name;
  String? code;
  String? image_url;

  CategoryData({
    this.id,
    this.name,
    this.code,
    this.image_url,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    image_url = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['image_url'] = this.image_url;
    return data;
  }
}
