import 'dart:convert';
import 'package:decoar/APICalls/Auth.dart';
import 'package:decoar/Classes/User.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<dynamic> transactions = [];
  bool isLoading = false;
  late String userId;
  late User userobj;
  late var user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
    user = Provider.of<UserProvider>(context).user!.user;
    userobj = Provider.of<UserProvider>(context).user!;
    fetchTransactions(userId);
  }

  Future<void> fetchTransactions(String userId) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('${url}user/payments/$userId'));
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        transactions = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load transactions');
    }
  }

  Future<void> _refresh() async {
    await fetchTransactions(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(url + "uploads/" + user['picture']),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user['email'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Address: ${user['address']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Balance: \$${user['balance']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .userType =
                          userobj.userType == "user" ? "seller" : "user";
                      Navigator.of(context).pushReplacementNamed(
                          userobj.userType == "user"
                              ? "/userHome"
                              : "/sellerHome");
                      Hive.box("user").put(
                          'user',
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .toString());
                    },
                    child: Text(
                        'Switch - ${userobj.userType == "user" ? "Seller" : "Customer"}'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        logout(Provider.of<UserProvider>(context, listen: false)
                            .user!
                            .userId);
                        if (!Hive.isBoxOpen("user")) await Hive.openBox("user");
                        Provider.of<UserProvider>(context, listen: false).user =
                            null;

                        Navigator.of(context).pushReplacementNamed("/login");
                        Hive.box("user").clear();
                      },
                      child: Text('Logout'),
                    ),
                  ),
                ),
              ],
            ),
            Divider(thickness: 0.5),
            const Center(
                child: Text("Transactions",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Divider(thickness: 0.5),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final transaction = transactions[index];
                          final bool isReceiving =
                              transaction['transactionType'] == 'receiving';

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${transaction['amount']}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat.yMd().add_jm().format(
                                          DateTime.parse(
                                              transaction["dateTime"])),
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Icon(
                                      isReceiving
                                          ? Icons.arrow_circle_down
                                          : Icons.arrow_circle_up,
                                      color: isReceiving
                                          ? Colors.green
                                          : Colors.red,
                                      size: 32.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
