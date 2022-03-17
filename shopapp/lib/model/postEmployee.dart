// ignore_for_file: file_names

class PostEmployee {
  final String phone;
  final String name;
  final String nic;

  const PostEmployee({
    required this.phone,
    required this.name,
    required this.nic,
  });

  PostEmployee.fromJson(Map<String, Object?> json)
      : this(
          phone: json['phone'] as String,
          name: json['name'] as String,
          nic: json['nic'] as String,
        );

  Map<String, Object?> toJson() => {
        'phone': phone,
        'name': name,
        'nic': nic,
      };
}
