class orderItemModel {
  late int productId;
  late int quantity;

  orderItemModel({required this.productId, required this.quantity});

  factory orderItemModel.fromJson(Map<String, dynamic> json) {
    return orderItemModel(
      productId: json['ProductId'],
      quantity: json['Quantity'],
    );
  }
}
