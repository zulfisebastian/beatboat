class MenuData {
  String? menu_slug;
  String? menu_name;

  MenuData({
    this.menu_slug,
    this.menu_name,
  });

  MenuData.fromJson(Map<String, dynamic> json) {
    menu_slug = json['menu_slug'];
    menu_name = json['menu_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_slug'] = this.menu_slug;
    data['menu_name'] = this.menu_name;
    return data;
  }
}
