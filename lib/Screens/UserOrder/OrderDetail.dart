import 'dart:async';
import 'dart:core';
import 'package:decoar/APICalls/orders.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/ModelViewer/model_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetails extends StatelessWidget {
  final String orderId;
  late String usertype;
  late Map<String, dynamic> data;
  late Function refreshPre;
  final TextEditingController quantitityController = TextEditingController();
  OrderDetails({required this.orderId, required this.refreshPre});

  @override
  Widget build(BuildContext context) {
    usertype = Provider.of<UserProvider>(context).user!.userType;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: FutureBuilder(
        future: fetchOrder(orderId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingUI();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> orderDetails = snapshot.data!;
            quantitityController.text = orderDetails['quantity'].toString();
            return _buildOrderDetailsUI(
              orderDetails: orderDetails,
              context: context,
              userType: usertype,
              quantitityController: quantitityController,
              refreshPre: refreshPre,
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20, width: 200, color: Colors.white),
            SizedBox(height: 8.0),
            Container(height: 20, width: 300, color: Colors.white),
            SizedBox(height: 8.0),
            Container(height: 20, width: 150, color: Colors.white),
            SizedBox(height: 8.0),
            Container(height: 20, width: 200, color: Colors.white),
            SizedBox(height: 8.0),
            Container(height: 20, width: 250, color: Colors.white),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class NumberInputWidget extends StatefulWidget {
  final int initialValue;
  final int max;
  final TextEditingController controller;
  const NumberInputWidget(
      {Key? key,
      this.initialValue = 0,
      this.max = 10,
      required this.controller})
      : super(key: key);

  @override
  _NumberInputWidgetState createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends State<NumberInputWidget> {
  late TextEditingController _controller;
  late int _value;
  late int max;
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = widget.controller;
    _controller.text = _value.toString();
    max = widget.max;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      if (_value >= max) return;
      _value++;
      _controller.text = '$_value';
    });
  }

  void _decrement() {
    setState(() {
      _value = _value > 0 ? _value - 1 : 0;
      _controller.text = '$_value';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _decrement,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (int.parse(value) > max) {
                        _controller.text = _value.toString();
                        return;
                      }
                      ;
                      _value = int.parse(value) ?? 0;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _increment,
                ),
              ],
            ),
          ),
          Text(
            'Avaliable: $max',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          )
        ],
      ),
    );
  }
}

class _buildOrderDetailsUI extends StatefulWidget {
  Map<String, dynamic> orderDetails;
  late var context;
  late TextEditingController quantitityController;
  late String userType;
  late Function refreshPre;
  _buildOrderDetailsUI({
    Key? key,
    required this.orderDetails,
    required this.context,
    required this.userType,
    required this.quantitityController,
    required this.refreshPre,
  }) : super(key: key);

  @override
  State<_buildOrderDetailsUI> createState() => _buildOrderDetailsUIState();
}

class _buildOrderDetailsUIState extends State<_buildOrderDetailsUI> {
  late String status;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = widget.orderDetails['status'];
  }

  @override
  Widget build(BuildContext context) {
    {
      bool isInProgress = widget.orderDetails['status'] == 'In Progress';
      String orderId = widget.orderDetails['orderId'];

      return Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ModelWidget(
                item: widget.orderDetails['item'],
                poster: "",
                ar: false,
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2.4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.0),
                      Text('Order ID: ${widget.orderDetails['orderId']}'),
                      SizedBox(height: 8.0),
                      Text(
                          'Product Name: ${widget.orderDetails['productName']}'),
                      SizedBox(height: 8.0),
                      if (!isInProgress ||
                          widget.userType == 'seller' ||
                          widget.orderDetails['paymentMethod'] == "online")
                        Text('Quantity: ${widget.orderDetails['quantity']}')
                      else
                        Row(
                          children: [
                            Text('Quantity: '),
                            SizedBox(
                              width: 200,
                              child: NumberInputWidget(
                                initialValue: widget.orderDetails['quantity']
                                            .runtimeType ==
                                        2.runtimeType
                                    ? widget.orderDetails['quantity']
                                    : int.parse(
                                        widget.orderDetails['quantity']),
                                max: widget.orderDetails['item']
                                    ['availability'],
                                controller: widget.quantitityController,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 8.0),
                      Text(
                        'Total Price: ${(widget.orderDetails['totalPrice']).toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 8.0),
                      Text('Status: ${widget.orderDetails['status']}'),
                      SizedBox(height: 8.0),
                      Text(
                          'Shipping Address: ${widget.orderDetails['shippingAddress']}'),
                      SizedBox(height: 8.0),
                      Text(
                          'Payment Method: ${widget.orderDetails['paymentMethod']}'),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.userType != "seller"
                              ? "Seller:${widget.orderDetails['sellerName']}"
                              : "Customer: ${widget.orderDetails['userName']}"),
                          ElevatedButton(
                              onPressed: () => {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed('/chatScreen', arguments: {
                                      "user": widget.userType == "seller"
                                          ? widget.orderDetails['sellerId']
                                          : widget.orderDetails['userId'],
                                      "otheruser": widget.userType == "seller"
                                          ? widget.orderDetails['userId']
                                          : widget.orderDetails['sellerId']
                                    })
                                  },
                              child: const Text("Chat"))
                        ],
                      ),
                      if (isInProgress && widget.userType != "seller")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (widget.orderDetails['paymentMethod'] !=
                                'online')
                              ElevatedButton(
                                onPressed: () async {
                                  await updateOrder(
                                      orderId,
                                      int.parse(
                                          widget.quantitityController.text));
                                  widget.refreshPre();
                                  Navigator.pop(context);
                                },
                                child: Text('Update order'),
                              ),
                            ElevatedButton(
                              onPressed: () async {
                                await cancelOrder(orderId);
                                widget.refreshPre();
                                Navigator.pop(context);
                              },
                              child: Text('Cancel Order'),
                            ),
                          ],
                        ),
                      if (widget.userType == 'seller' &&
                          widget.orderDetails['status'] != 'Cancelled' &&
                          widget.orderDetails['status'] != 'Delivered')
                        Column(
                          children: [
                            SizedBox(height: 16.0),
                            DropdownButtonFormField<String>(
                              value: status,
                              decoration: InputDecoration(
                                labelText: 'Status',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              items: [
                                'Delivered',
                                'In Progress',
                                'Shipping',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                status = value!;
                                setState(() {});
                              },
                            ),
                            SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () async {
                                print(status);
                                await updateOrderStatus(orderId, status);
                                widget.refreshPre();
                              },
                              child: Text('Update Status'),
                            ),
                          ],
                        ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
