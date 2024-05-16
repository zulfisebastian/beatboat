class Endpoint {
  static const String baseUrl = "https://beatboat.ninefoxlab.com/api";
  static const String defaultFood =
      "https://img.freepik.com/free-photo/top-view-banquet-with-lots-food_52683-101175.jpg?size=626&ext=jpg&ga=GA1.1.735520172.1710806400&semt=ais";

  static const String login = "/login";
  static const String profile = "/me";
  static const String editProfile = "/profile";
  static const String device = "/device";
  static const String nationality = "/list-nationality";
  static const String reason = "/refund-reason";
  static const String trigger = "/trigger-printer";
  static const String version = "/version/check";

  //activity
  static const String activity = "/activities";

  //product
  static const String category = "/categories";
  static const String product = "/products/all";
  static const String productByCategory = "/products/{id}";

  //balance
  static const String balance = "/wristband/check-balance";
  static const String topup = "/wristband/top-up";
  static const String transfer = "/wristband/transfer";
  static const String onboard = "/wristband/onboard";

  //Bartender
  static const String bartender = "/transactions";
  static const String markDone = "/transactions-detail/{id}";

  //transaction
  static const String transaction = "/transactions";
  static const String checkin = "/check-in/validate";
  static const String voucher = "/voucher/check";
  static const String refund = "/refund";
}
