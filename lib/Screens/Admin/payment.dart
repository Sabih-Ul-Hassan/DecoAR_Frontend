import 'dart:convert';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentListScreen extends StatefulWidget {
  @override
  _PaymentListScreenState createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  List<dynamic> paymentReqs = [];

  @override
  void initState() {
    super.initState();
    fetchPaymentReqs();
  }

  Future<void> fetchPaymentReqs() async {
    final response = await http.get(Uri.parse(url + "paymentReq/unpaid"));
    if (response.statusCode == 200) {
      setState(() {
        paymentReqs = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load payment requests');
    }
  }

  Future<void> markPaymentAsPaid(String id, int amount) async {
    final String endpoint = 'paymentReq/markpaid/$id/$amount';
    final String url1 = '$url$endpoint';
    print("object");
    try {
      final response = await http.get(Uri.parse(url1));

      if (response.statusCode == 200) {
        fetchPaymentReqs();
      } else {
        print(
            'Failed to mark payment as paid. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error making the API call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Requests'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchPaymentReqs,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: paymentReqs.length,
        itemBuilder: (BuildContext context, int index) {
          final paymentReq = paymentReqs[index];
          return Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.all(4),
            color: Colors.white,
            child: ListTile(
              title: Text('User: ${paymentReq['userName']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance: ${paymentReq['balance']}'),
                  Text('Account: ${paymentReq['accountNo']}'),
                  Text('name: ${paymentReq['userName']}'),
                  ElevatedButton(
                      child: Text("pay"),
                      onPressed: () => {
                            markPaymentAsPaid(
                                paymentReq['_id'], paymentReq['balance'])
                          })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
