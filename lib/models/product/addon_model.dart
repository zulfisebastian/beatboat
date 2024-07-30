class AddonData {
  String? id;
  String? addon_id;
  String? product_id;
  String? cart_id;
  String? name;
  int? price;
  int? qty;
  int? counter;

  AddonData({
    this.id,
    this.addon_id,
    this.product_id,
    this.cart_id,
    this.name,
    this.price,
    this.qty,
    this.counter,
  });

  AddonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addon_id = json['addon_id'];
    product_id = json['product_id'];
    cart_id = json['cart_id'];
    name = json['name'];
    price = json['price'];
    qty = json['qty'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addon_id'] = this.addon_id;
    data['product_id'] = this.product_id;
    data['cart_id'] = this.cart_id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['counter'] = this.counter;
    return data;
  }
}
