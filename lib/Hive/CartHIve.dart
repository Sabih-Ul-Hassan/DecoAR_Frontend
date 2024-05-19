import 'package:hive/hive.dart';

Future<bool> checkIfItemExistsInCart(String userId, String productId) async {
  try {
    var box;
    if (Hive.isBoxOpen("carts"))
      box = Hive.box("carts");
    else
      box = Hive.openBox("carts");

    if (box.containsKey(userId)) {
      var userCart = box.get(userId);
      for (var product in userCart) {
        if (product['_id'] == productId) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}

Future<bool> checkAndAddItemToCart(
    String userId, Map<dynamic, dynamic> item) async {
  try {
    Box box;
    if (Hive.isBoxOpen("carts"))
      box = Hive.box("carts");
    else
      box = await Hive.openBox("carts");
    if (box.containsKey(userId)) {
      var userCart = box.get(userId);
      if (userCart.contains(item)) {
        return false;
      } else {
        userCart.add(item);
        await box.put(userId, userCart);
        return true;
      }
    } else {
      var newCart = [item];
      await box.put(userId, newCart);
      return true;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}
