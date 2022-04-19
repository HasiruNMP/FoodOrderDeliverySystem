import 'dart:convert';
import 'package:customerapp/controller/ordermodel.dart';
import 'package:http/http.dart' as http;
import 'package:customerapp/controller/usermodel.dart';

import '../controller/orderitemsmodel.dart';
import '../controller/productmodel.dart';

class APIService {
  static Future adduser(userModel user) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('https://10.0.2.2:7072/users/adduser'));
    request.body = json.encode({
      "firstName": user.firstName,
      "lastName": user.lastName,
      "phone": user.phone,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future getUserDetails(String phone) async {
    http.Response response = await http.get(Uri.parse(
        'https://10.0.2.2:7072/users/getuserdetails?phone=%2B${phone.substring(1)}'));

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

  static Future deleteAccount(String phone) async {
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://10.0.2.2:7072/users/deletuser?phone=%2B${phone.substring(1)}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('deleted');
      return 1;
    } else {
      print(response.reasonPhrase);
      return -1;
    }
  }

  static Future<List<orderModel>> getNewOrders(int userId) async {
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:7072/orders/getneworderslist?userId=$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new orderModel.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<List<orderModel>> getCompletedOrders(int userId) async {
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:7072/orders/getcompletedlist?userId=$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new orderModel.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<List<orderItemModel>> getOrderItems(int orderId) async {
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:7072/orders/getOrderItems?orderId=$orderId'));
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
        'https://10.0.2.2:7072/orders/getproductdetails?productId=$productId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => new productModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // static Future getProductDetails(int productId) async {
  //   http.Response response = await http.get(Uri.parse(
  //       'https://10.0.2.2:7072/orders/getproductdetails?productId=$productId'));
  //
  //   if (response.statusCode == 200) {
  //     print(response.statusCode);
  //     String data = response.body;
  //     print(data);
  //     return jsonDecode(data);
  //   } else {
  //     print(response.statusCode);
  //     print(response.reasonPhrase);
  //   }
  // }
}
