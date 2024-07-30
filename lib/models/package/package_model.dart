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
  String? unit;
  String? order_serve;
  String? image_url;
  String? status;
  String? addon_uid;
  int? serve_qty;
  PackageAddonData? addons;

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
    this.unit,
    this.image_url,
    this.status,
    this.serve_qty,
    this.addon_uid,
    this.addons,
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
    unit = json['unit'];
    description = json['description'];
    currency = json['currency'];
    order_serve = json['order_serve'];
    image_url = json['image_url'];
    status = json['status'];
    serve_qty = json['serve_qty'];
    addon_uid = json['addon_uid'];
    addons = json['addons'] != null
        ? new PackageAddonData.fromJson(json['addons'])
        : null;
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
    data['unit'] = this.unit;
    data['daily_stock'] = this.daily_stock;
    data['description'] = this.description;
    data['currency'] = this.currency;
    data['order_serve'] = this.order_serve;
    data['image_url'] = this.image_url;
    data['status'] = this.status;
    data['serve_qty'] = this.serve_qty;
    data['addon_uid'] = this.addon_uid;
    if (this.addons != null) {
      data['addons'] = this.addons?.toJson();
    }
    return data;
  }
}

class PackageAddonData {
  String? text;
  int? min_selection;
  List<PackageAddonDetailData>? items;

  PackageAddonData({
    this.text,
    this.min_selection,
    this.items,
  });

  PackageAddonData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    min_selection = json['min_selection'];
    if (json['items'] != null) {
      items = <PackageAddonDetailData>[];
      json['items'].forEach((v) {
        items?.add(new PackageAddonDetailData.fromJson(v));
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

class PackageAddonDetailData {
  String? addon_id;
  String? product_id;
  String? name;
  int? price;
  int? counter;

  PackageAddonDetailData({
    this.addon_id,
    this.product_id,
    this.name,
    this.price,
    this.counter,
  });

  PackageAddonDetailData.fromJson(Map<String, dynamic> json) {
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
