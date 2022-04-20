class productModel {
  late int productId;
  late int categoryId;
  late String name;
  late String description;
  late double price;
  late String imgUrl;

  productModel(
      {required this.productId,
      required this.categoryId,
      required this.name,
      required this.description,
      required this.price,
      required this.imgUrl});
  factory productModel.fromJson(Map<String, dynamic> json) {
    return productModel(
      productId: json['ProductId'],
      categoryId: json['CategoryId'],
      name: json['Name'],
      description: json['Description'],
      price: json['Price'],
      imgUrl: json['ImgUrl'],
    );
  }
}
