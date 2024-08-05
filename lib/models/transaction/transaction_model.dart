import 'package:beatboat/models/product/product_model.dart';

class TransactionResponse {
  List<TransactionData>? data;
  String? message;
  String? code;

  TransactionResponse({
    this.data,
    this.message,
    this.code,
  });

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data?.add(new TransactionData.fromJson(v));
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

class TransactionData {
  String? id;
  String? number;
  String? payment_method;
  String? customer_name;
  String? nfc_uid;
  int? total_amount;
  int? tax;
  int? service_tax;
  int? discount_amount;
  int? subtotal;
  int? input_payment;
  int? changes;
  String? date;
  String? created_at;
  String? voucher_code;
  String? note;
  String? type;
  String? status;
  String? table_name;
  int? order_no;
  List<DetailTransactionData>? details;
  List<RefundTransactionData>? refunds;

  TransactionData({
    this.id,
    this.number,
    this.payment_method,
    this.customer_name,
    this.nfc_uid,
    this.tax,
    this.total_amount,
    this.service_tax,
    this.discount_amount,
    this.subtotal,
    this.input_payment,
    this.changes,
    this.date,
    this.created_at,
    this.voucher_code,
    this.note,
    this.type,
    this.status,
    this.table_name,
    this.order_no,
    this.details,
    this.refunds,
  });

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    payment_method = json['payment_method'];
    customer_name = json['customer_name'];
    nfc_uid = json['nfc_uid'];
    tax = json['tax'];
    total_amount = json['total_amount'];
    service_tax = json['service_tax'];
    discount_amount = json['discount_amount'];
    subtotal = json['subtotal'];
    input_payment = json['input_payment'];
    changes = json['changes'];
    date = json['date'];
    created_at = json['created_at'];
    voucher_code = json['voucher_code'];
    note = json['note'];
    type = json['type'];
    status = json['status'];
    table_name = json['table_name'];
    order_no = json['order_no'];
    if (json['details'] != null) {
      details = <DetailTransactionData>[];
      json['details'].forEach((v) {
        details?.add(new DetailTransactionData.fromJson(v));
      });
    }
    if (json['refunds'] != null) {
      refunds = <RefundTransactionData>[];
      json['refunds'].forEach((v) {
        refunds?.add(new RefundTransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['payment_method'] = this.payment_method;
    data['customer_name'] = this.customer_name;
    data['nfc_uid'] = this.nfc_uid;
    data['tax'] = this.tax;
    data['total_amount'] = this.total_amount;
    data['service_tax'] = this.service_tax;
    data['discount_amount'] = this.discount_amount;
    data['subtotal'] = this.subtotal;
    data['input_payment'] = this.input_payment;
    data['changes'] = this.changes;
    data['date'] = this.date;
    data['created_at'] = this.created_at;
    data['voucher_code'] = this.voucher_code;
    data['note'] = this.note;
    data['type'] = this.type;
    data['status'] = this.status;
    data['table_name'] = this.table_name;
    data['order_no'] = this.order_no;
    if (this.details != null) {
      data['details'] = this.details?.map((v) => v.toJson()).toList();
    }
    if (this.refunds != null) {
      data['refunds'] = this.refunds?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailTransactionData {
  String? id;
  String? transaction_id;
  String? product_id;
  int? qty;
  int? unit_price;
  int? discounted_unit_price;
  int? total_price;
  String? note;
  String? status;
  ProductData? product;
  List<AddonsTransactionData>? addons;

  DetailTransactionData({
    this.id,
    this.transaction_id,
    this.product_id,
    this.unit_price,
    this.discounted_unit_price,
    this.total_price,
    this.qty,
    this.note,
    this.status,
    this.product,
    this.addons,
  });

  DetailTransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transaction_id = json['transaction_id'];
    product_id = json['product_id'];
    unit_price = json['unit_price'];
    discounted_unit_price = json['discounted_unit_price'];
    total_price = json['total_price'];
    qty = json['qty'];
    note = json['note'];
    status = json['status'];
    product = json['product'] != null
        ? new ProductData.fromJson(json['product'])
        : null;
    if (json['addons'] != null) {
      addons = <AddonsTransactionData>[];
      json['addons'].forEach((v) {
        addons?.add(new AddonsTransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transaction_id;
    data['product_id'] = this.product_id;
    data['unit_price'] = this.unit_price;
    data['discounted_unit_price'] = this.discounted_unit_price;
    data['total_price'] = this.total_price;
    data['qty'] = this.qty;
    data['note'] = this.note;
    data['status'] = this.status;
    if (this.product != null) {
      data['product'] = this.product?.toJson();
    }
    if (this.addons != null) {
      data['addons'] = this.addons?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RefundTransactionData {
  String? id;
  String? code;

  RefundTransactionData({
    this.id,
    this.code,
  });

  RefundTransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    return data;
  }
}

class AddonsTransactionData {
  int? qty;
  String? addons;

  AddonsTransactionData({
    this.qty,
    this.addons,
  });

  AddonsTransactionData.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    addons = json['addons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    data['addons'] = this.addons;
    return data;
  }
}
