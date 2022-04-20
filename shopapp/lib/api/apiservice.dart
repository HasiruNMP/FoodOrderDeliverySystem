import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/orderitemsmodel.dart';
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
}
