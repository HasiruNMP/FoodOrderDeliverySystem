// ignore_for_file: file_names

class PostItems {
  final String prodId;
  final String categoryId;
  final String description;
  final String imgUrl;
  final String name;
  final String price;

  const PostItems({
    required this.prodId,
    required this.categoryId,
    required this.description,
    required this.imgUrl,
    required this.name,
    required this.price,
  });

  PostItems.fromJson(Map<String, Object?> json)
      : this(
          prodId: json['prodId'] as String,
          categoryId: json['categoryId'] as String,
          description: json['description'] as String,
          imgUrl: json['imgUrl'] as String,
          name: json['name'] as String,
          price: json['price'] as String,
        );

  Map<String, Object?> toJson() => {
        'prodId': prodId,
        'categoryId': categoryId,
        'description': description,
        'imgUrl': imgUrl,
        'name': name,
        'price': price,
      };
}
