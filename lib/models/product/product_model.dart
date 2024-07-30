class ProductResponse {
  PageData? data;
  String? message;
  String? code;

  ProductResponse({
    this.data,
    this.message,
    this.code,
  });

  ProductResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PageData.fromJson(json['data']) : null;
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

class PageData {
  int? current_page;
  int? last_page;
  int? total;
  List<ProductData>? data;

  PageData({
    this.current_page,
    this.last_page,
    this.total,
    this.data,
  });

  PageData.fromJson(Map<String, dynamic> json) {
    current_page = json['current_page'];
    last_page = json['last_page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data?.add(new ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.current_page;
    data['last_page'] = this.last_page;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
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
  ProductAddonData? addons;

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
    this.addons,
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
    addons = json['addons'] != null
        ? new ProductAddonData.fromJson(json['addons'])
        : null;
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
    if (this.addons != null) {
      data['addons'] = this.addons?.toJson();
    }
    return data;
  }
}

class ProductAddonData {
  String? text;
  int? min_selection;
  List<ProductAddonDetailData>? items;

  ProductAddonData({
    this.text,
    this.min_selection,
    this.items,
  });

  ProductAddonData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    min_selection = json['min_selection'];
    if (json['items'] != null) {
      items = <ProductAddonDetailData>[];
      json['items'].forEach((v) {
        items?.add(new ProductAddonDetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['min_selection'] = this.min_selection;
    if (this.items != null) {
      data['items'] = this.items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductAddonDetailData {
  String? addon_id;
  String? product_id;
  String? name;
  int? price;
  int? counter;

  ProductAddonDetailData({
    this.addon_id,
    this.product_id,
    this.name,
    this.price,
    this.counter,
  });

  ProductAddonDetailData.fromJson(Map<String, dynamic> json) {
    addon_id = json['addon_id'];
    product_id = json['product_id'];
    name = json['name'];
    price = json['price'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addon_id'] = this.addon_id;
    data['product_id'] = this.product_id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['counter'] = this.counter;
    return data;
  }
}
