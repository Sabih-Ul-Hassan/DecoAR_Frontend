import 'dart:convert';

import 'package:decoar/APICalls/cart.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/Cart/cart_tile.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Box cartBox;
  late ValueNotifier<int> updateNotifier;
  late String userId;
  late String selectedAddressOption;
  late String addressUser;
  TextEditingController newAddress = TextEditingController();

  String selectedPaymentOption = "cod";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
    selectedAddressOption =
        Provider.of<UserProvider>(context).user!.user['address'];
    addressUser = Provider.of<UserProvider>(context).user!.user['address'];
  }

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box('carts');
    updateNotifier = ValueNotifier<int>(0); // Initialize with a dummy value
    cartBox.watch().listen((event) {
      updateNotifier.value++; // Increment the notifier value to trigger rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Items'),
      ),
      body: ValueListenableBuilder(
        valueListenable: updateNotifier,
        builder: (BuildContext context, _, __) {
          return _buildCartList(userId);
        },
      ),
    );
  }

  Widget _buildCartList(String userId) {
    if (!cartBox.containsKey(userId)) {
      return Center(child: Text('No items in the cart'));
    } else if ((cartBox.get(userId) as List).isEmpty) {
      return Center(child: Text('No items in the cart'));
    }

    return FutureBuilder(
      future: fetchData(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items in the cart'));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cartItem = snapshot.data![index];
                    return CartTile(item: cartItem);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // bool res = await createOrders(userId, "shippingAddress");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(res
                  //         ? 'Order placed successfully'
                  //         : "some problem occured, try later"),
                  //   ),
                  // );
                  _showAddressSelectionBottomSheet();
                },
                child: Text('Place Order'),
              ),
              SizedBox(height: 16),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    Hive.close(); // Close the Hive box when the screen is disposed
    updateNotifier.dispose(); // Dispose the update notifier
    super.dispose();
  }

  void _showAddressSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(
                    title: Text(this.addressUser),
                    value: this.addressUser,
                    groupValue: selectedAddressOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedAddressOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Add new address'),
                    value: 'new',
                    groupValue: selectedAddressOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedAddressOption = value!;
                      });
                    },
                  ),
                  Visibility(
                    visible: this.selectedAddressOption != this.addressUser,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: newAddress,
                        decoration: const InputDecoration(
                          hintText: 'Address',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        _showPaymentMethodBottomSheet();
                      },
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPaymentMethodBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(
                    title: Text('Cash on Delivery'),
                    value: 'cod',
                    groupValue: selectedPaymentOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Online Payment'),
                    value: 'online',
                    groupValue: selectedPaymentOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentOption = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedPaymentOption == 'cod') {
                          bool res = await createOrders(
                              userId,
                              selectedAddressOption == addressUser
                                  ? addressUser
                                  : newAddress.text);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res
                                  ? 'Order placed successfully'
                                  : "Some problem occurred, try later"),
                            ),
                          );
                        } else {
                          bool res = await makePayment(context, userId);
                          if (!res) {
                            Navigator.pop(
                                context); // Close payment method bottom sheet
                            Navigator.pop(
                                context); // Close address selection bottom sheet
                            SnackBar(
                              content: Text("Some problem occurred, try later"),
                            );
                            //  return;
                          }
                          bool res1 = await createOrderOnlinePayment(
                              userId,
                              selectedAddressOption == addressUser
                                  ? addressUser
                                  : newAddress.text);
                          Navigator.pop(
                              context); // Close payment method bottom sheet
                          Navigator.pop(
                              context); // Close address selection bottom sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res1
                                  ? 'Order placed successfully'
                                  : "Some problem occurred, try later"),
                            ),
                          );
                        }
                      },
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Future<String> createPaymentIntent(String userId) async {
  try {
    int price = await getCartPrice(userId);
    price = price * 100;
    final response = await http.post(
      Uri.parse('${url}create-payment-intent'),
      body: json.encode({
        'amount': price,
        'currency': 'usd',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['clientSecret'];
    } else {
      throw Exception('Failed to create payment intent');
    }
  } catch (e) {
    throw Exception('Failed to create payment intent: $e');
  }
}

Future<bool> makePayment(BuildContext context, String userId) async {
  try {
    final clientSecret = await createPaymentIntent(userId);

    await Future.delayed(const Duration(seconds: 1));
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "DecoAR"),
    );

    await Stripe.instance.presentPaymentSheet();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment successful'),
      ),
    );
    return true;
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed or cancelled'),
      ),
    );
    return false;
  }
}
