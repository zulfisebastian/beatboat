class ProductResponse {
  List<ProductData>? data;
  String? message;
  String? code;

  ProductResponse({
    this.data,
    this.message,
    this.code,
  });

  ProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data?.add(new ProductData.fromJson(v));
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

class ProductData {
  String? id;
  String? category_id;
  String? sku;
  String? name;
  String? description;
  int? buy_price;
  int? sell_price;
  int? stock;
  int? show;
  String? status;
  String? order_serve;
  String? unit;
  String? image_url;

  ProductData({
    this.id,
    this.category_id,
    this.sku,
    this.name,
    this.description,
    this.buy_price,
    this.sell_price,
    this.stock,
    this.status,
    this.order_serve,
    this.show,
    this.unit,
    this.image_url,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category_id = json['category_id'];
    sku = json['sku'];
    description = json['description'];
    name = json['name'];
    buy_price = json['buy_price'];
    sell_price = json['sell_price'];
    stock = json['stock'];
    status = json['status'];
    order_serve = json['order_serve'];
    unit = json['unit'];
    show = json['show'];
    image_url = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.category_id;
    data['sku'] = this.sku;
    data['description'] = this.description;
    data['name'] = this.name;
    data['buy_price'] = this.buy_price;
    data['sell_price'] = this.sell_price;
    data['stock'] = this.stock;
    data['status'] = this.status;
    data['order_serve'] = this.order_serve;
    data['unit'] = this.unit;
    data['show'] = this.show;
    data['image_url'] = this.image_url;
    return data;
  }
}
