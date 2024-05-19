import 'package:decoar/Screens/UserOrder/OrderDetail.dart';
import 'package:decoar/Screens/UserOrder/user_orders.dart';
import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/orders':
            return MaterialPageRoute(builder: (_) => UserOrders());
          case '/orderDetails':
            Map<String, dynamic> arguments =
                settings.arguments as Map<String, dynamic>;
            String orderId = arguments['orderId'] as String;
            Function refreshPre = arguments['refresh'] as Function;
            return MaterialPageRoute(
              builder: (_) =>
                  OrderDetails(orderId: orderId, refreshPre: refreshPre),
            );
          default:
            return MaterialPageRoute(builder: (_) => UserOrders());
        }
      },
    );
  }
}
