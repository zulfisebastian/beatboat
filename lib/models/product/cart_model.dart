class CartData {
  String? id;
  String? category_id;
  String? sku;
  String? name;
  String? description;
  int? buy_price;
  int? sell_price;
  int? stock;
  String? status;
  String? unit;
  String? image_url;
  int? qty;

  CartData({
    this.id,
    this.category_id,
    this.sku,
    this.name,
    this.description,
    this.buy_price,
    this.sell_price,
    this.stock,
    this.status,
    this.unit,
    this.image_url,
    this.qty,
  });

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category_id = json['category_id'];
    sku = json['sku'];
    description = json['description'];
    name = json['name'];
    buy_price = json['buy_price'];
    sell_price = json['sell_price'];
    stock = json['stock'];
    status = json['status'];
    unit = json['unit'];
    image_url = json['image_url'];
    qty = json['qty'];
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
    data['unit'] = this.unit;
    data['image_url'] = this.image_url;
    data['qty'] = this.qty;
    return data;
  }
}
