class PageData {
  int? current_page;
  int? per_page;
  int? last_page;
  int? total;

  PageData({
    this.current_page,
    this.per_page,
    this.last_page,
    this.total,
  });

  PageData.fromJson(Map<String, dynamic> json) {
    current_page = json['current_page'];
    per_page = json['per_page'];
    last_page = json['last_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.current_page;
    data['per_page'] = this.per_page;
    data['last_page'] = this.last_page;
    data['total'] = this.total;
    return data;
  }
}
