class orderModel {
  late int orderId;
  late String dateTime;
  late double totalPrice;

  orderModel(
      {required this.orderId,
      required this.dateTime,
      required this.totalPrice});
  factory orderModel.fromJson(Map<String, dynamic> json) {
    return orderModel(
      orderId: json['OrderId'],
      dateTime: json['datetime'],
      totalPrice: json['TotalPrice'],
    );
  }
}
