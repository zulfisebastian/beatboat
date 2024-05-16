class AddTransactionResponse {
  AddTransactionData? data;
  String? message;
  String? code;

  AddTransactionResponse({
    this.data,
    this.message,
    this.code,
  });

  AddTransactionResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new AddTransactionData.fromJson(json['data'])
        : null;
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

class AddTransactionData {
  String? trx_number;
  int? subtotal;
  String? table_name;

  AddTransactionData({
    this.trx_number,
    this.subtotal,
    this.table_name,
  });

  AddTransactionData.fromJson(Map<String, dynamic> json) {
    trx_number = json['trx_number'];
    subtotal = json['subtotal'];
    table_name = json['table_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trx_number'] = this.trx_number;
    data['subtotal'] = this.subtotal;
    data['table_name'] = this.table_name;
    return data;
  }
}
