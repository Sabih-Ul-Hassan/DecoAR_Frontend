import 'package:decoar/Hive/CartHIve.dart';
import 'package:flutter/material.dart';

class AddItemBottomSheet extends StatefulWidget {
  final int availability;
  late int price;
  final String userId;
  final dynamic item;

  AddItemBottomSheet({
    Key? key,
    required this.availability,
    required this.item,
    required this.userId,
    required this.price,
  }) : super(key: key);

  @override
  _AddItemBottomSheetState createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  late TextEditingController _controller;
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = 1;
    _controller = TextEditingController(text: '1');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
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
                          if (value.isNotEmpty && int.tryParse(value) != null) {
                            quantity = int.parse(value);
                            if (quantity > widget.availability) {
                              quantity = widget.availability;
                              _controller.text = quantity.toString();
                            }
                          } else {
                            quantity = 1;
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
                        } else if (inputValue > widget.availability) {
                          return 'Maximum availability is ${widget.availability}';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        if (quantity < widget.availability) {
                          quantity++;
                          _controller.text = quantity.toString();
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                'Availability: ${widget.availability}',
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await checkAndAddItemToCart(widget.userId, {
                "_id": widget.item['_id'],
                "quantity": int.tryParse(_controller.text) ?? 1,
                "price": widget.price
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item added to cart'),
                  duration: Duration(seconds: 1),
                ),
              );
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
