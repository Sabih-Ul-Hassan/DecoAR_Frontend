import 'dart:convert';
import 'package:decoar/varsiables.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

List<Map<String, dynamic>> mergeItemsWithCart(
    List<Map<String, dynamic>> items, List<Map<String, dynamic>> cart) {
  List<Map<String, dynamic>> finalArray = [];

  for (var item in items) {
    var cartItem = cart.firstWhere((element) => element['_id'] == item['_id']);

    if (cartItem != null) {
      var mergedItem = {...item, 'quantity': cartItem['quantity']};
      finalArray.add(mergedItem);
    } else {
      finalArray.add(item);
    }
  }

  return finalArray;
}

Future<List<Map<String, dynamic>>> fetchData(String userId) async {
  try {
    if (!Hive.isBoxOpen("carts")) await Hive.openBox("carts");
    List<String> dataList = await fetchListData(userId);
    final response = await http.post(
      Uri.parse('${url}cart/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ids': dataList}),
    );
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);

      if (responseData is List &&
          responseData.isNotEmpty &&
          responseData[0] is Map<String, dynamic>) {
        List<Map<String, dynamic>> fetchedData =
            responseData.cast<Map<String, dynamic>>();
        List<Map<String, dynamic>> cartData =
            List.from(Hive.box("carts").get(userId).map((e) => convertMap(e)));
        var data = mergeItemsWithCart(fetchedData, cartData);
        print(data);
        return data as List<Map<String, dynamic>>;
      } else {
        throw Exception('Invalid data format received from the API');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching data: $error');
    throw error;
  }
}

Map<String, dynamic> convertMap(Map<dynamic, dynamic> originalMap) {
  Map<String, dynamic> newMap = {};
  originalMap.forEach((key, value) {
    newMap[key.toString()] = value;
  });
  return newMap;
}

Future<List<String>> fetchListData(String userId) async {
  try {
    Box box;
    if (Hive.isBoxOpen("carts"))
      box = Hive.box('carts');
    else
      box = await Hive.openBox("carts");
    dynamic data = box.get(userId);
    List<String> list = [];
    data.forEach((element) {
      list.add(element["_id"]);
    });
    print(list);
    return list as List<String>;
  } catch (error) {
    print('Error fetching data from Hive box: $error');
    throw error;
  }
}

Future<bool> createOrders(String userId, String? shippingAddress) async {
  final url_ = '${url}cart/createOrder';

  try {
    Box cartBox;
    if (Hive.isBoxOpen("carts"))
      cartBox = Hive.box('carts');
    else
      cartBox = await Hive.openBox("carts");
    final List cart = cartBox.get(userId);

    if (cart.isEmpty) {
      print('Cart is empty');
      return false;
    }

    final List<Map<String, dynamic>> orders = cart
        .map((item) => {
              'productId': item["_id"],
              'quantity': item["quantity"],
            })
        .toList();

    final response = await http.post(
      Uri.parse(url_),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'cart': orders,
        'shippingAddress': shippingAddress,
      }),
    );

    if (response.statusCode == 201) {
      print('Orders created successfully');
      await cartBox.clear();
      return true;
    } else {
      print('Failed to create orders: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    print('Error creating orders: $error');
    return false;
  }
}

Future<bool> createOrderOnlinePayment(
    String userId, String? shippingAddress) async {
  final url_ = '${url}cart/createOrderOnlinePayment';

  try {
    Box cartBox;
    if (Hive.isBoxOpen("carts"))
      cartBox = Hive.box('carts');
    else
      cartBox = await Hive.openBox("carts");
    final List cart = cartBox.get(userId);

    if (cart.isEmpty) {
      print('Cart is empty');
      return false;
    }

    final List<Map<String, dynamic>> orders = cart
        .map((item) => {
              'productId': item["_id"],
              'quantity': item["quantity"],
            })
        .toList();

    final response = await http.post(
      Uri.parse(url_),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'cart': orders,
        'shippingAddress': shippingAddress,
      }),
    );

    if (response.statusCode == 201) {
      print('Orders created successfully');
      await cartBox.clear();
      return true;
    } else {
      print('Failed to create orders: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    print('Error creating orders: $error');
    return false;
  }
}

Future<int> getCartPrice(String userId) async {
  Box cartBox;
  if (Hive.isBoxOpen("carts"))
    cartBox = Hive.box('carts');
  else
    cartBox = await Hive.openBox("carts");
  final List cart = cartBox.get(userId);
  int totalPrice = 0;
  if (cart.isEmpty) {
    print('Cart is empty');
    return 0;
  }

  final List<Map<String, dynamic>> orders = cart
      .map((item) => {
            'productId': item["_id"],
            'quantity': item["quantity"],
            "price": item['price']
          })
      .toList();
  orders.forEach((element) {
    totalPrice += int.parse((((element["price"] is int)
                ? element["price"]
                : int.parse(element["price"].toString())) *
            ((element["quantity"] is int)
                ? element["quantity"]
                : int.parse(element["quantity"].toString())))
        .toString());
  });

  return totalPrice;
}
