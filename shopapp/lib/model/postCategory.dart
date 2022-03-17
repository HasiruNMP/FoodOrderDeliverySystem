// ignore_for_file: file_names

class PostCategory {
  final int id;
  final String imgUrl;
  final String name;

  const PostCategory({
    required this.id,
    required this.imgUrl,
    required this.name,
  });

  PostCategory.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as int,
          imgUrl: json['imgUrl'] as String,
          name: json['name'] as String,
        );

  Map<String, Object?> toJson() => {
        'id': id,
        'imgUrl': imgUrl,
        'name': name,
      };
}
