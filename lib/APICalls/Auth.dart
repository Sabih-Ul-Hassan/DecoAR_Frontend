import 'dart:convert';

import 'package:decoar/NotificationsServices/NotificationsServices.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> logout(String id) async {
  final String apiUrl = url + 'user/logout';

  final Map<String, dynamic> requestBody = {
    'id': id,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final bool success = jsonDecode(response.body);
      return success;
    } else {
      throw Exception('Failed to logout: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to logout: $error');
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  String fcmTokken = await NotificationsServices.getDeviceToken();
  final String Url = url + 'user/login?fcmTokken=' + fcmTokken;
  try {
    final response = await http.post(Uri.parse(Url), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      return {'success': true, 'data': response.body};
    } else if (response.statusCode == 404) {
      return {'success': false, 'error': 'User not found'};
    } else if (response.statusCode == 401) {
      return {'success': false, 'error': 'Incorrect password'};
    } else {
      return {'success': false, 'error': 'An error occurred'};
    }
  } catch (error) {
    print('Error logging in: $error');
    return {'success': false, 'error': 'An error occurred'};
  }
}

Future<Map<String, dynamic>> signup(String name, String email, String password,
    String address, String accountNo) async {
  String fcmTokken = await NotificationsServices.getDeviceToken();

  final String Url = url + 'user/signup?fcmTokken=' + fcmTokken;

  try {
    final response = await http.post(Uri.parse(Url), body: {
      'name': name,
      'email': email,
      'password': password,
      "accountNo": accountNo,
      "address": address
    });

    if (response.statusCode == 201) {
      return {'success': true, 'data': response.body};
    } else if (response.statusCode == 400) {
      return {'success': false, 'error': 'User already exists'};
    } else {
      return {'success': false, 'error': 'An error occurred'};
    }
  } catch (error) {
    print('Error signing up: $error');
    return {'success': false, 'error': 'An error occurred'};
  }
}
