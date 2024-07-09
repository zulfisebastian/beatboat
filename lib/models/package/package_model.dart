class PackageResponse {
  List<PackageData>? data;
  String? message;
  String? code;

  PackageResponse({
    this.data,
    this.message,
    this.code,
  });

  PackageResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PackageData>[];
      json['data'].forEach((v) {
        data?.add(new PackageData.fromJson(v));
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

class PackageData {
  String? id;
  String? category_id;
  String? sku;
  String? name;
  String? description;
  String? currency;
  int? buy_price;
  int? sell_price;
  int? stock;
  int? min_stock;
  int? show;
  int? daily_stock;
  String? order_serve;
  String? image_url;
  String? status;
  String? addon_uid;
  int? serve_qty;

  PackageData({
    this.id,
    this.category_id,
    this.name,
    this.sku,
    this.sell_price,
    this.buy_price,
    this.stock,
    this.min_stock,
    this.show,
    this.daily_stock,
    this.description,
    this.currency,
    this.order_serve,
    this.image_url,
    this.status,
    this.serve_qty,
    this.addon_uid,
  });

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category_id = json['category_id'];
    name = json['name'];
    sku = json['sku'];
    sell_price = json['sell_price'];
    buy_price = json['buy_price'];
    stock = json['stock'];
    min_stock = json['min_stock'];
    show = json['show'];
    daily_stock = json['daily_stock'];
    description = json['description'];
    currency = json['currency'];
    order_serve = json['order_serve'];
    image_url = json['image_url'];
    status = json['status'];
    serve_qty = json['serve_qty'];
    addon_uid = json['addon_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.category_id;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['sell_price'] = this.sell_price;
    data['buy_price'] = this.buy_price;
    data['stock'] = this.stock;
    data['min_stock'] = this.min_stock;
    data['show'] = this.show;
    data['daily_stock'] = this.daily_stock;
    data['description'] = this.description;
    data['currency'] = this.currency;
    data['order_serve'] = this.order_serve;
    data['image_url'] = this.image_url;
    data['status'] = this.status;
    data['serve_qty'] = this.serve_qty;
    data['addon_uid'] = this.addon_uid;
    return data;
  }
}
