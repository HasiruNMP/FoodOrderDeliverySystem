// ignore_for_file: file_names

class PostEmployee {
  final String employeeId;
  final String phone;
  final String name;
  final String nic;
  final String department;
  final String username;
  final String license;

  const PostEmployee({
    required this.employeeId,
    required this.phone,
    required this.name,
    required this.nic,
    required this.department,
    required this.username,
    required this.license,
  });

  PostEmployee.fromJson(Map<String, Object?> json)
      : this(
          employeeId: json['employeeId'] as String,
          phone: json['phone'] as String,
          name: json['name'] as String,
          nic: json['nic'] as String,
          department: json['department'] as String,
          username: json['username'] as String,
          license: json['license'] as String,
        );

  Map<String, Object?> toJson() => {
        'employeeId': employeeId,
        'phone': phone,
        'name': name,
        'nic': nic,
        'department': department,
        'username': username,
        'license': license,
      };
}
