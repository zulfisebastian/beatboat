class CartData {
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
  String? unit;
  String? image_url;
  String? note;
  int? qty;
  int? min_selection;

  CartData(
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
      this.qty,
      this.min_selection});

  CartData.fromJson(Map<String, dynamic> json) {
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
    qty = json['qty'];
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
    data['qty'] = this.qty;
    data['min_selection'] = this.min_selection;
    return data;
  }
}
