import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../varsiables.dart';

Future<List<Map<String, dynamic>>> loadFilterAnalyticsData(userId) async {
  String? category;
  int? minPrice;
  int? maxPrice;
  String? selectedDate;
  String? sortBy;
  if (!Hive.isBoxOpen('sheet_filter_criteria'))
    await Hive.openBox('sheet_filter_criteria');
  if (!Hive.isBoxOpen('_timeFilterBox')) await Hive.openBox('_timeFilterBox');
  var timeFilterBox = Hive.box('_timeFilterBox');
  var filterBox = Hive.box('sheet_filter_criteria');

  if (timeFilterBox.isNotEmpty) {
    category = timeFilterBox.get('category');
    minPrice = timeFilterBox.get('minPrice');
    maxPrice = timeFilterBox.get('maxPrice');
    selectedDate = timeFilterBox.get('date');
    sortBy = timeFilterBox.get('sortBy');

    timeFilterBox.clear();
  } else if (filterBox.isNotEmpty) {
    category = filterBox.get('category');
    minPrice = filterBox.get('minPrice');
    maxPrice = filterBox.get('maxPrice');
    selectedDate = filterBox.get('date');
    sortBy = filterBox.get('sortBy');
  }

  String queryString = '';

  if (category != null) {
    queryString += 'category=$category&';
  }

  if (minPrice != null) {
    queryString += 'minPrice=$minPrice&';
  }

  if (maxPrice != null) {
    queryString += 'maxPrice=$maxPrice&';
  }

  if (selectedDate != null) {
    queryString += 'date=$selectedDate&';
  }

  if (sortBy != null) {
    queryString += 'sortBy=$sortBy&';
  }

  if (queryString.isNotEmpty && queryString.endsWith('&')) {
    queryString = queryString.substring(0, queryString.length - 1);
  }

  try {
    var response = await http
        .get(Uri.parse(url + "analytics/filter/$userId?" + queryString));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return List<Map<String, dynamic>>.from(jsonResponse);
    } else {
      throw Exception('Failed to load products');
    }
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchDataRevenueChart(
    String value, String userId) async {
  final response = await http
      .get(Uri.parse(url + 'analytics/graph/earnings/$userId/$value'));
  if (response.statusCode == 200) {
    print(List<Map<String, dynamic>>.from(jsonDecode(response.body)));
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Map<String, dynamic>>> fetchDataCancelledChart(
    String value, String userId) async {
  final response = await http
      .get(Uri.parse(url + 'analytics/graph/cancelled/$userId/$value'));
  if (response.statusCode == 200) {
    print(List<Map<String, dynamic>>.from(jsonDecode(response.body)));
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Map<String, dynamic>>> fetchDataOrdersChart(
    String value, String userId) async {
  final response =
      await http.get(Uri.parse(url + 'analytics/graph/count/$userId/$value'));
  if (response.statusCode == 200) {
    print(List<Map<String, dynamic>>.from(jsonDecode(response.body)));
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<List<Map<String, dynamic>>>> getCharts(
    String value, String userId) async {
  List<List<Map<String, dynamic>>> l1 = [
    await fetchDataRevenueChart(value, userId),
    await fetchDataOrdersChart(value, userId),
    await fetchDataCancelledChart(value, userId)
  ];
  return l1;
}
