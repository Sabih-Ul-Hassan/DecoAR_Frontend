import 'package:decoar/Providers/User.dart';
import 'package:flutter/material.dart';
import 'package:decoar/varsiables.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class CartTile extends StatefulWidget {
  final Map<String, dynamic> item;

  const CartTile({Key? key, required this.item}) : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  int quantity = 0;
  late final String title;
  late final String image;
  late final String userId;
  late final String itemId;
  late final int available;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
  }

  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    itemId = widget.item['_id'] ?? '';
    title = widget.item['title'] ?? '';
    image = widget.item['image'] ?? '';
    available = widget.item['availability'] ?? 0;
    quantity = widget.item['quantity'] ?? 0;
    _controller.text = quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(
          "${url}uploads/$image",
          // width: 70,
          // height: 70,
          fit: BoxFit.fill,
        ),
        subtitle: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Availability: ${available}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                  updateCartItemQuantity(
                                      userId, itemId, quantity);
                                  _controller.text = quantity.toString();
                                }
                              });
                            },
                          ),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty &&
                                      int.tryParse(value) != null) {
                                    quantity = int.parse(value);
                                    if (quantity > available) {
                                      quantity = available;
                                      updateCartItemQuantity(
                                          userId, itemId, quantity);
                                      _controller.text = quantity.toString();
                                    }
                                  } else {
                                    quantity = 1;
                                    _controller.text = quantity.toString();
                                    updateCartItemQuantity(
                                        userId, itemId, quantity);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.zero,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter quantity';
                                }
                                int inputValue = int.tryParse(value) ?? 0;
                                if (inputValue < 1) {
                                  return 'Minimum quantity is 1';
                                } else if (inputValue > available) {
                                  return 'Maximum availability is ${available}';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (quantity < available) {
                                  quantity++;
                                  updateCartItemQuantity(
                                      userId, itemId, quantity);
                                  _controller.text = quantity.toString();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        try {
                          final box = Hive.box('carts');
                          var cartItems = box.get(userId);

                          cartItems
                              .removeWhere((item) => item['_id'] == itemId);

                          await box.put(userId, cartItems);
                        } catch (error) {
                          print('Error removing item from cart: $error');
                          throw error;
                        }
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> updateCartItemQuantity(
    String userId, String itemId, int quantity) async {
  try {
    final box = Hive.box('carts');
    var cartItems = box.get(userId, defaultValue: []);

    final itemIndex = cartItems.indexWhere((item) => item['_id'] == itemId);
    if (itemIndex != -1) {
      cartItems[itemIndex]['quantity'] = quantity;
      await box.put(userId, cartItems);
    }
  } catch (error) {
    print('Error updating cart item quantity: $error');
    throw error;
  }
}
