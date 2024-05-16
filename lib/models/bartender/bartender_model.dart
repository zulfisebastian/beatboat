import 'package:beatboat/models/product/product_model.dart';

class BartenderResponse {
  List<BartenderData>? data;
  String? message;
  String? code;

  BartenderResponse({
    this.data,
    this.message,
    this.code,
  });

  BartenderResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BartenderData>[];
      json['data'].forEach((v) {
        data?.add(new BartenderData.fromJson(v));
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

class BartenderData {
  String? id;
  String? number;
  String? customer_name;
  String? payment_method;
  int? total_amount;
  int? tax;
  int? service_tax;
  int? discount_amount;
  int? subtotal;
  int? input_payment;
  int? changes;
  String? date;
  String? voucher_code;
  String? note;
  String? type;
  String? status;
  int? refund_amount;
  List<DetailBartenderData>? details;

  BartenderData({
    this.id,
    this.number,
    this.payment_method,
    this.customer_name,
    this.tax,
    this.total_amount,
    this.service_tax,
    this.discount_amount,
    this.subtotal,
    this.input_payment,
    this.changes,
    this.date,
    this.voucher_code,
    this.note,
    this.type,
    this.status,
    this.refund_amount,
    this.details,
  });

  BartenderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    payment_method = json['payment_method'];
    customer_name = json['customer_name'];
    tax = json['tax'];
    total_amount = json['total_amount'];
    service_tax = json['service_tax'];
    discount_amount = json['discount_amount'];
    subtotal = json['subtotal'];
    input_payment = json['input_payment'];
    changes = json['changes'];
    date = json['date'];
    voucher_code = json['voucher_code'];
    note = json['note'];
    type = json['type'];
    status = json['status'];
    refund_amount = json['refund_amount'];

    if (json['details'] != null) {
      details = <DetailBartenderData>[];
      json['details'].forEach((v) {
        details?.add(new DetailBartenderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['payment_method'] = this.payment_method;
    data['customer_name'] = this.customer_name;
    data['tax'] = this.tax;
    data['total_amount'] = this.total_amount;
    data['service_tax'] = this.service_tax;
    data['discount_amount'] = this.discount_amount;
    data['subtotal'] = this.subtotal;
    data['input_payment'] = this.input_payment;
    data['changes'] = this.changes;
    data['date'] = this.date;
    data['voucher_code'] = this.voucher_code;
    data['note'] = this.note;
    data['type'] = this.type;
    data['status'] = this.status;
    data['refund_amount'] = this.refund_amount;

    if (this.details != null) {
      data['details'] = this.details?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailBartenderData {
  String? id;
  String? transaction_id;
  String? product_id;
  int? qty;
  int? unit_price;
  int? total_price;
  String? note;
  String? status;
  int? refund_qty;
  ProductData? product;

  DetailBartenderData({
    this.id,
    this.transaction_id,
    this.product_id,
    this.unit_price,
    this.total_price,
    this.qty,
    this.note,
    this.status,
    this.refund_qty,
    this.product,
  });

  DetailBartenderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transaction_id = json['transaction_id'];
    product_id = json['product_id'];
    unit_price = json['unit_price'];
    total_price = json['total_price'];
    qty = json['qty'];
    note = json['note'];
    status = json['status'];
    refund_qty = json['refund_qty'];
    product = json['product'] != null
        ? new ProductData.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transaction_id;
    data['product_id'] = this.product_id;
    data['unit_price'] = this.unit_price;
    data['total_price'] = this.total_price;
    data['qty'] = this.qty;
    data['note'] = this.note;
    data['status'] = this.status;
    data['refund_qty'] = this.refund_qty;
    if (this.product != null) {
      data['product'] = this.product?.toJson();
    }
    return data;
  }
}
