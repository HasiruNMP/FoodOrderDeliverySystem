import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/orderitemsmodel.dart';
import '../model/postEmployee.dart';
import '../model/productmodel.dart';
import 'package:shopapp/globals.dart';

class APIService {
  static Future getUserDetailsbyUserId(int userid) async {
    http.Response response = await http.get(Uri.parse(
        '${Urls.apiUrl}/users/getuserdetailsbyuserid?userId=1'));

    if (response.statusCode == 200) {
      print(response.statusCode);
      String data = response.body;
      print(data);
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }
  }

  static Future<List<orderItemModel>> getOrderItems(int orderId) async {
    final response = await http.get(Uri.parse(
        '${Urls.apiUrl}/orders/getOrderItems?orderId=$orderId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => new orderItemModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<List<productModel>> getProductDetails(int productId) async {
    final response = await http.get(Uri.parse(
        '${Urls.apiUrl}/orders/getproductdetails?productId=$productId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => new productModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<List<PostEmployee>> getDeliveryEmployees() async {
    final response = await http.get(Uri.parse(
        '${Urls.apiUrl}/employee/getDeliveryEmployeesDetails'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => new PostEmployee.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future updateOrderStatusNdelivery(int orderId, int empId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'PUT',
      Uri.parse(
          '${Urls.apiUrl}/orders/putprocessed?orderId=$orderId&empId=$empId'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      return 0;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return -1;
    }
  }

  static Future getDeliveryInfo(int empId) async {
    http.Response response = await http.get(Uri.parse(
        '${Urls.apiUrl}/employee/getemployeedetails?empId=$empId'));

    if (response.statusCode == 200) {
      print(response.statusCode);
      String data = response.body;
      print(data);
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }
  }

  static Future updateProductDetails(int prodId, String name,
      String description, double price, String imgUrl) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'PUT',
      Uri.parse(
          '${Urls.apiUrl}/products/putproductdetails?ProductId=$prodId&Name=$name&Description=$description&Price=$price&ImgUrl=$imgUrl'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      return 0;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return -1;
    }
  }

  static Future deleteAccount(int prodId) async {
    var request = http.Request('DELETE',
        Uri.parse('${Urls.apiUrl}/products?ProductId=$prodId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('deleted');
      return 0;
    } else {
      print(response.reasonPhrase);
      return -1;
    }
  }

  static Future addDeliveryPerson(PostEmployee user) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('${Urls.apiUrl}/employee/adddeliveryperson'));
    request.body = json.encode({
      "department": "Delivery",
      "nic": user.nic,
      "name": user.name,
      "license": user.license,
      "phone": user.phone,
      "username": user.username,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      return 0;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return -1;
    }
  }

  static Future updateDeliveryPerson(int empId, String nic, String name,
      String license, String phone, String userName) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'PUT',
      Uri.parse(
          '${Urls.apiUrl}/employee/updateemployeedetails?empId=$empId&nic=$nic&name=$name&license=$license&phone=$phone&username=$userName'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      return 0;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return -1;
    }
  }

  static Future deleteEmployee(int empId) async {
    var request = http.Request(
        'DELETE', Uri.parse('${Urls.apiUrl}/employee?empId=$empId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('deleted');
      return 0;
    } else {
      print(response.reasonPhrase);
      return -1;
    }
  }
}
