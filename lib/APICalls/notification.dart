import 'dart:convert';
import 'package:decoar/varsiables.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchNotifications(userId, userType) async {
  final response =
      await http.get(Uri.parse('${url}notifications/$userId/$userType'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load notifications');
  }
}
