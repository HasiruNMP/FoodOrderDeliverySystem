// ignore_for_file: file_names

class PostEmployee {
  final int employeeId;
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

  factory PostEmployee.fromJson(Map<String, dynamic> json) {
    return PostEmployee(
      employeeId: json['EmployeeId'],
      phone: json['Phone'],
      name: json['Name'],
      nic: json['NIC'],
      department: json['Department'],
      username: json['Username'],
      license: json['License'],
    );
  }

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

// PostEmployee.fromJson(Map<String, Object?> json)
// : this(
// employeeId: json['EmployeeId'] as String,
//     phone: json['Phone'] as String,
//     name: json['Name'] as String,
//     nic: json['NIC'] as String,
//     department: json['Department'] as String,
//     username: json['Username'] as String,
//     license: json['License'] as String,
// );
//

// }
