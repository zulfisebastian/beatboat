class CartPackageData {
  String? id;
  String? product_id;
  String? category_id;
  String? sku;
  String? name;
  String? description;
  int? buy_price;
  int? sell_price;
  int? stock;
  String? status;
  String? order_serve;
  int? serve_qty;
  String? unit;
  String? image_url;
  String? note;
  String? addon_uid;
  int? qty;
  String? addon_title;
  int? min_selection;

  CartPackageData(
      {this.id,
      this.product_id,
      this.category_id,
      this.sku,
      this.name,
      this.description,
      this.buy_price,
      this.sell_price,
      this.stock,
      this.status,
      this.order_serve,
      this.unit,
      this.image_url,
      this.note,
      this.addon_uid,
      this.qty,
      this.addon_title,
      this.min_selection});

  CartPackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product_id = json['product_id'];
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
    image_url = json['image_url'];
    note = json['note'];
    addon_uid = json['addon_uid'];
    qty = json['qty'];
    addon_title = json['addon_title'];
    min_selection = json['min_selection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.product_id;
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
    data['image_url'] = this.image_url;
    data['note'] = this.note;
    data['addon_uid'] = this.addon_uid;
    data['qty'] = this.qty;
    data['addon_title'] = this.addon_title;
    data['min_selection'] = this.min_selection;
    return data;
  }
}
