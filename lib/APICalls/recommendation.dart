import 'dart:convert';
import 'package:decoar/varsiables.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchRecommendations(String userId) async {
  final Future<http.Response> future1 =
      http.get(Uri.parse(url + "recommendation/" + userId));
  final Future<http.Response> future2 =
      http.get(Uri.parse(url + "recommendation/latestProducts"));

  List<http.Response> responses = await Future.wait([future1, future2]);

  var data1, data2;
  if (responses[0].statusCode == 200) {
    data1 = json.decode(responses[0].body);
  } else {
    throw Exception('Failed to load data from first URL');
  }

  if (responses[1].statusCode == 200) {
    data2 = json.decode(responses[1].body);
  } else {
    throw Exception('Failed to load data from second URL');
  }

  Map<String, dynamic> combinedData = {
    'recommendations': data1,
    'newProducts': data2
  };

  return combinedData;
}
