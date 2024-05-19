import 'dart:async';
import 'package:decoar/APICalls/orders.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/UserOrder/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserOrders extends StatefulWidget {
  @override
  _UserOrdersState createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  String current = 'All';
  late String userType;
  late String userId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
    userType = Provider.of<UserProvider>(context).user!.userType;
    if (userType == 'user')
      _ordersFuture = fetchOrders(userId, current);
    else if (userType == 'seller')
      _ordersFuture = fetchSellersOrders(userId, current);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Orders'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TabPill(
                  value: 'All',
                  current: current,
                  change: () => setState(() {
                    current = 'All';
                    if (userType == 'user')
                      _ordersFuture = fetchOrders(userId, current);
                    else if (userType == 'seller')
                      _ordersFuture = fetchSellersOrders(userId, current);
                  }),
                ),
                TabPill(
                  value: 'Cancelled',
                  current: current,
                  change: () => setState(() {
                    current = 'Cancelled';
                    if (userType == 'user')
                      _ordersFuture = fetchOrders(userId, current);
                    else if (userType == 'seller')
                      _ordersFuture = fetchSellersOrders(userId, current);
                  }),
                ),
                TabPill(
                  value: 'In Progress',
                  current: current,
                  change: () => setState(() {
                    current = 'In Progress';
                    if (userType == 'user')
                      _ordersFuture = fetchOrders(userId, current);
                    else if (userType == 'seller')
                      _ordersFuture = fetchSellersOrders(userId, current);
                  }),
                ),
                TabPill(
                  value: 'Shipping',
                  current: current,
                  change: () => setState(() {
                    current = 'Shipping';
                    if (userType == 'user')
                      _ordersFuture = fetchOrders(userId, current);
                    else if (userType == 'seller')
                      _ordersFuture = fetchSellersOrders(userId, current);
                  }),
                ),
                TabPill(
                  value: 'Delivered',
                  current: current,
                  change: () => setState(() {
                    current = 'Delivered';
                    if (userType == 'user')
                      _ordersFuture = fetchOrders(userId, current);
                    else if (userType == 'seller')
                      _ordersFuture = fetchSellersOrders(userId, current);
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _ordersFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> orders = snapshot.data!;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      final order = orders[index];
                      return OrderTile(
                          orderId: order['orderId'],
                          productName: order['productName'],
                          quantity: order['quantity'],
                          totalPrice: order['totalPrice'],
                          status: order['status'],
                          imageUrl: order['imageUrl'],
                          refresh: () {
                            setState(() {
                              if (userType == 'user')
                                _ordersFuture = fetchOrders(userId, current);
                              else if (userType == 'seller')
                                _ordersFuture =
                                    fetchSellersOrders(userId, current);
                            });
                          });
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TabPill extends StatelessWidget {
  final String value;
  final String current;
  final Function change;
  const TabPill(
      {super.key,
      required this.value,
      required this.current,
      required this.change});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => change(),
      child: Container(
        constraints: BoxConstraints(minWidth: 70),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Center(child: Text(value)),
        decoration: BoxDecoration(
            color: value == current ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(80),
            border: Border.all(color: Colors.white, width: 2)),
      ),
    );
  }
}
