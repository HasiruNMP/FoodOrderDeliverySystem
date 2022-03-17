import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String customerName;
  final String customerPhone;
  final String orderId;
  final String orderStatus;
  final Timestamp orderTime;
  final String totalPrice;
  final GeoPoint customerLocation;
  final bool isDelivered;
  final bool isProcessed;
  final bool isReceived;
  final String deliveryPerson;

  const Post({
    required this.customerName,
    required this.customerPhone,
    required this.orderId,
    required this.orderStatus,
    required this.orderTime,
    required this.totalPrice,
    required this.customerLocation,
    required this.isDelivered,
    required this.isProcessed,
    required this.isReceived,
    required this.deliveryPerson,
  });

  Post.fromJson(Map<String, Object?> json)
      : this(
          customerName: json['customerName'] as String,
          customerPhone: json['customerPhone'] as String,
          orderId: json['orderid'] as String,
          orderStatus: json['orderStatus'] as String,
          orderTime: json['orderTime'] as Timestamp,
          totalPrice: json['totalPrice'] as String,
          customerLocation: json['customerLocation'] as GeoPoint,
          isDelivered: json['isDelivered'] as bool,
          isProcessed: json['isProcessed'] as bool,
          isReceived: json['isReceived'] as bool,
          deliveryPerson: json['deliveryPerson'] as String,
        );

  Map<String, Object?> toJson() => {
        'customerName': customerName,
        'customerPhone': customerPhone,
        'orderid': orderId,
        'orderStatus': orderStatus,
        'orderTime': orderTime,
        'totalPrice': totalPrice,
        'customerLocation': customerLocation,
        'isDelivered': isDelivered,
        'isProcessed': isProcessed,
        'isReceived': isReceived,
        'deliveryPerson': deliveryPerson,
      };
}
