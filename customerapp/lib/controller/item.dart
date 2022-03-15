class Item {
  final String name;
  final double price;
  final String imgUrl;
  int quantity;
  // final String description;

  Item(
      {required this.name,
      required this.price,
      required this.imgUrl,
      required this.quantity});

  String getName() {
    return name;
  }

  double getPrice() {
    return price;
  }

  String getImgurl() {
    return imgUrl;
  }

  int getQuantity() {
    return quantity;
  }
}
