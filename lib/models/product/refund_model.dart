class RefundData {
  String? id;
  String? category_id;
  String? trx_number;
  String? trx_detail_id;
  int? qty;
  int? nominal;
  int? total;

  RefundData({
    this.id,
    this.category_id,
    this.trx_number,
    this.trx_detail_id,
    this.qty,
    this.nominal,
    this.total,
  });

  RefundData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category_id = json['category_id'];
    trx_number = json['trx_number'];
    trx_detail_id = json['trx_detail_id'];
    qty = json['qty'];
    nominal = json['nominal'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.category_id;
    data['trx_number'] = this.trx_number;
    data['trx_detail_id'] = this.trx_detail_id;
    data['qty'] = this.qty;
    data['nominal'] = this.nominal;
    data['total'] = this.total;
    return data;
  }
}
