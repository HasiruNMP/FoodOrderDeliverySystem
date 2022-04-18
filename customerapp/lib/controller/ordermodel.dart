class orderModel {
  late int orderId;
  late String time;
  late double totalPrice;

  orderModel(
      {required this.orderId, required this.time, required this.totalPrice});
  factory orderModel.fromJson(Map<String, dynamic> json) {
    return orderModel(
      orderId: json['OrderId'],
      time: json['Time'],
      totalPrice: json['TotalPrice'],
    );
  }
}
