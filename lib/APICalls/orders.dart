import 'dart:convert';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchOrders(
    String userId, String orderType) async {
  final response = await http.get(Uri.parse(url + 'orders/$userId/$orderType'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    return responseData.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load orders');
  }
}

Future<List<Map<String, dynamic>>> fetchSellersOrders(
    String userId, String orderType) async {
  final response =
      await http.get(Uri.parse(url + 'orders/seller/$userId/$orderType'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    return responseData.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load orders');
  }
}

Future<Map<String, dynamic>> fetchOrder(String orderId) async {
  final response = await http.get(Uri.parse(url + 'orders/$orderId'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('Failed to load orders');
  }
}

Future<bool> updateOrder(String orderId, int newQuantity) async {
  final String apiUrl = '${url}orders/$orderId';

  Map<String, dynamic> requestBody = {
    'newQuantity': newQuantity,
  };

  String requestBodyJson = json.encode(requestBody);

  try {
    final http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: requestBodyJson,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool> cancelOrder(String orderId) async {
  final String apiUrl = url + 'orders/$orderId';

  try {
    final http.Response response = await http.delete(
      Uri.parse(apiUrl),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<void> updateOrderStatus(String orderId, String status) async {
  final url1 = url + 'orders/updateStatus';
  final headers = <String, String>{'Content-Type': 'application/json'};
  final body = jsonEncode({'orderId': orderId, 'status': status});

  try {
    final response =
        await http.put(Uri.parse(url1), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Order status updated successfully');
    } else {
      print('Failed to update order status: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating order status: $error');
  }
}
