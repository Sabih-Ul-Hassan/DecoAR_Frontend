import 'package:http/http.dart' as http;
import "../varsiables.dart";
import 'dart:convert';

Future<Map<String, dynamic>> fetchReviews(
    String productId, String userId) async {
  final String apiUrl = '${url}reviews/$productId/$userId';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    // Handle error
    throw Exception('Failed to fetch reviews');
  }
}

Future<bool> uploadReview(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('${url}reviews/upload'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateReview(String reviewId, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse('${url}reviews/update/$reviewId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, dynamic>> fetchUserReviews(
    String ReviewedUsersId, String userId) async {
  final String apiUrl = '${url}reviews/user/$ReviewedUsersId/$userId';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    // Handle error
    throw Exception('Failed to fetch reviews');
  }
}

Future<bool> uploadUsersReview(Map<String, dynamic> data) async {
  print(Uri.parse('${url}reviews/user/upload'));
  final response = await http.post(
    Uri.parse('${url}reviews/user/upload'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateUserReview(
    String reviewId, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse('${url}reviews/user/update/$reviewId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
