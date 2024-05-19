import 'dart:io';
import 'package:http/http.dart' as http;
import "../varsiables.dart";
import 'dart:convert';

Future<bool> updateProduct(
    String productId, Map<String, dynamic> newData) async {
  final String apiUrl = '${url}products/$productId';
  print("ara");
  final response = await http.put(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(newData),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> uploadProduct(Map product, List<File> images, File? model) async {
  final String apiUrl = "${url}products/add";
  print("here1");
  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

  request.fields['title'] = product["title"];
  request.fields['price'] = product["price"].toString();
  request.fields['availability'] = product["availability"].toString();
  request.fields['category'] = product["category"];
  request.fields['description'] = product["description"];
  request.fields['shippingInfo'] = product["shippingInfo"];
  request.fields['shippingPrice'] = product["shippingPrice"].toString();
  request.fields['tags'] = product["tags"].join(',');
  request.fields['userId'] = product["userId"].toString();
  request.fields['alternativeModelText'] = product["alternativeModelText"];
  request.fields['placement'] = product["placement"].toString().split(".").last;
  request.fields['backgroundModelColor'] =
      product["backgroundModelColor"]?.value.toRadixString(16) ?? '0';
  print("here2");
  // Add images to the request
  for (int i = 0; i < images.length; i++) {
    var stream = http.ByteStream(images[i].openRead());
    var length = await images[i].length();
    var multipartFile = http.MultipartFile('images', stream, length,
        filename: images[i].path.split('/').last);
    request.files.add(multipartFile);
  }
  print("here3");
  // Add 3D model to the request if available
  if (model != null) {
    var modelStream = http.ByteStream(model.openRead());
    var modelLength = await model.length();
    var modelFile = http.MultipartFile('model', modelStream, modelLength,
        filename: model.path.split('/').last);
    request.files.add(modelFile);
  }
  print("here4");
  // Send the request
  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool> deleteProductById(String productId) async {
  final apiUrl = url + 'products/' + productId;

  try {
    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<Map<String, dynamic>> fetchProductById(String id) async {
  final response = await http.get(Uri.parse(url + 'products/$id'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load product');
  }
}

Future<List<Map<String, dynamic>>> fetchProductsByUserId(String userId) async {
  final response =
      await http.get(Uri.parse(url + 'products/inventory/$userId'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> products = [];

    for (var item in data) {
      products.add({
        'image': item['image'],
        'id': item['id'],
        'title': item['title'],
        'price': item['price'],
        'category': item['category'],
        'availability': item['availability'],
      });
    }

    return products;
  } else {
    throw Exception('Failed to fetch data');
  }
}
