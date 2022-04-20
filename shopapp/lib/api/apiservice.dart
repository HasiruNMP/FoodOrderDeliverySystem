import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/deliverypersoninfo.dart';
import '../model/orderitemsmodel.dart';
import '../model/postEmployee.dart';
import '../model/productmodel.dart';

class APIService {
  static Future getUserDetailsbyUserId(int userid) async {
    http.Response response = await http.get(Uri.parse(
        'https://localhost:7072/users/getuserdetailsbyuserid?userId=1'));

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
        'https://localhost:7072/orders/getOrderItems?orderId=$orderId'));
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
        'https://localhost:7072/orders/getproductdetails?productId=$productId'));
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
        'https://localhost:7072/employee/getDeliveryEmployeesDetails'));
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
          'https://localhost:7072/orders/putprocessed?orderId=$orderId&empId=$empId'),
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
        'https://localhost:7072/employee/getemployeedetails?empId=$empId'));

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
}
