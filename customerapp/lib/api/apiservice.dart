import 'dart:convert';
import 'package:customerapp/controller/cart.dart';
import 'package:customerapp/controller/ordermodel.dart';
import 'package:customerapp/global_urls.dart';
import 'package:http/http.dart' as http;
import 'package:customerapp/controller/usermodel.dart';

import '../controller/orderitemsmodel.dart';
import '../controller/productmodel.dart';
import '../global.dart';

class APIService {

  Future<void> login(String phone, String otp) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${Urls.apiUrl}/auth/login'));
    request.body = json.encode({
      "userID": phone,
      "password": otp,
      "userType": "CS"
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  static Future<String> addNewOrder(NewOrderModel newOrder) async {
    String url = '${Urls.apiUrl}/orders/placeneworder?userId=${newOrder.userId}&price=${newOrder.totalPrice}&lat=${newOrder.lat}&lng=${newOrder.lng}&time=${newOrder.dateTime}';
    final response = await http.post(Uri.parse(url),headers: {
      'Authorization': 'Bearer ${Auth.token}'
    });
    if (response.statusCode == 200) {
      String oid = response.body.toString();
      double orderID = double.parse(oid);
      print("Order ID: $orderID");
      print(Cart.basketItems.length);
      for (int i = 0; i < Cart.basketItems.length; i++){
        print("adding new order item");
        addNewOrderItem(
          OrderItemModel(orderId: orderID.toInt(), prodId: Cart.basketItems[i].id, qty: Cart.basketItems[i].quantity)
        );
      }
      return orderID.toInt().toString();
    }
    else {
      print(response.reasonPhrase);
      return "error";
    }
  }

  static Future addNewOrderItem(OrderItemModel orderItem) async {
    var request = http.Request('POST', Uri.parse('${Urls.apiUrl}/orders/neworder/additem?orderId=${orderItem.orderId}&prodId=${orderItem.prodId}&qt=${orderItem.qty}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  static Future adduser(userModel user) async {
    var headers = {'Content-Type': 'application/json','Authorization': 'Bearer ${Auth.token}'};
    var request = http.Request('POST', Uri.parse('${Urls.apiUrl}/users/adduser'),);
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
        '${Urls.apiUrl}/users/getuserdetails?phone=%2B${phone.substring(1)}'),
        headers: {'Authorization': 'Bearer ${Auth.token}'});

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
            '${Urls.apiUrl}/users/deletuser?phone=%2B${phone.substring(1)}'),);

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
        '${Urls.apiUrl}/orders/getneworderslist?userId=$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new orderModel.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<List<orderModel>> getCompletedOrders(int userId) async {
    final response = await http.get(Uri.parse(
        '${Urls.apiUrl}/orders/getcompletedlist?userId=$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new orderModel.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
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

  static Future updateOrderStatus(int orderId, String orderStatus) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'PUT',
      Uri.parse(
          '${Urls.apiUrl}/orders/updateorderstatus?orderId=$orderId&orderStatus=$orderStatus'),
    );
    request.body = json.encode({
      "OrderId": orderId,
      "OrderStatus": orderStatus,
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
}
