import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;
  final String productName;
  final int quantity;
  final int totalPrice;
  final String status;
  final String imageUrl;
  final Function refresh;
  OrderTile({
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.imageUrl,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      // margin: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        tileColor: Colors.white,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(url + "uploads/" + imageUrl),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Order ID: $orderId"),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$productName',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('Quantity: $quantity'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Status: $status',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed("/orderDetails",
              arguments: {"orderId": orderId, "refresh": refresh});
        },
      ),
    );
  }
}
