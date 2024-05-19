import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import "../varsiables.dart";
import 'dart:convert';

Future<List<String>> fetchProductSuggestions(String input) async {
  final apiUrl = '${url}search/products/suggestions/$input';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load titles');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to connect to the server');
  }
}

// Future<List<dynamic>> searchProducts(String query) async {
//   final response = await http.get(Uri.parse('${url}search/products/$query'));

//   if (response.statusCode == 200) {
//     final List<dynamic> products = json.decode(response.body);
//     return products;
//   } else {
//     throw Exception('Failed to load products');
//   }
// }

// Future<List<dynamic>> searchProductsFilter(String query) async {
Future<List<dynamic>> searchProducts(String query) async {
  try {
    List<dynamic> products;
    String finalQuery;
    Box tempFilterBox;
    if (Hive.isBoxOpen("temp_filter"))
      tempFilterBox = Hive.box("temp_filter");
    else
      tempFilterBox = await Hive.openBox("temp_filter");
    if (tempFilterBox.isNotEmpty) {
      String? title = tempFilterBox.get('title');
      int? minPrice = tempFilterBox.get('minPrice');
      int? maxPrice = tempFilterBox.get('maxPrice');
      String? category = tempFilterBox.get('category');
      String? sortBy = tempFilterBox.get('sortBy');

      finalQuery = '';
      if (title != null) finalQuery += 'title=$title&';
      if (minPrice != null) finalQuery += 'minPrice=$minPrice&';
      if (maxPrice != null) finalQuery += 'maxPrice=$maxPrice&';
      if (category != null) finalQuery += 'category=$category&';
      if (sortBy != null) finalQuery += 'sortBy=$sortBy&';

      tempFilterBox.clear();
    } else {
      Box filterCriteriaBox;
      if (Hive.isBoxOpen("filter_criteria"))
        filterCriteriaBox = Hive.box("filter_criteria");
      else
        filterCriteriaBox = await Hive.openBox("filter_criteria");
      if (filterCriteriaBox.isNotEmpty) {
        String? title = query;
        int? minPrice = filterCriteriaBox.get('minPrice');
        int? maxPrice = filterCriteriaBox.get('maxPrice');
        String? category = filterCriteriaBox.get('category');
        String? sortBy = filterCriteriaBox.get('sortBy');

        finalQuery = '';
        finalQuery += 'title=$title&';
        if (minPrice != null) finalQuery += 'minPrice=$minPrice&';
        if (maxPrice != null) finalQuery += 'maxPrice=$maxPrice&';
        if (category != null) finalQuery += 'category=$category&';
        if (sortBy != null) finalQuery += 'sortBy=$sortBy&';
      } else {
        finalQuery = 'title=$query';
      }
    }

    final response =
        await http.get(Uri.parse('${url}search/products?$finalQuery'));

    if (response.statusCode == 200) {
      products = json.decode(response.body);
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  } catch (error) {
    throw Exception('Error loading products: $error');
  }
}
