class orderModel {
  late int orderId;
  late String dateTime;
  late double totalPrice;
  late double lat;
  late double lng;

  orderModel({
    required this.orderId,
    required this.dateTime,
    required this.totalPrice,
  });
  factory orderModel.fromJson(Map<String, dynamic> json) {
    return orderModel(
      orderId: json['OrderId'],
      dateTime: json['datetime'],
      totalPrice: json['TotalPrice'],
    );
  }
}

class NewOrderModel {
  late int userId;
  late String dateTime;
  late double totalPrice;
  late double lat;
  late double lng;

  NewOrderModel({
    required this.userId,
    required this.dateTime,
    required this.totalPrice,
    required this.lat,
    required this.lng,
  });
}

class OrderItemModel {
  late int orderId;
  late int prodId;
  late int qty;

  OrderItemModel({
    required this.orderId,
    required this.prodId,
    required this.qty,
  });
}