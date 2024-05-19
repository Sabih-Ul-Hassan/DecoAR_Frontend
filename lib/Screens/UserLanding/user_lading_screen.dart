import 'dart:convert';
import 'package:decoar/APICalls/recommendation.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/InventryItems/item_card.dart';
import 'package:decoar/Screens/InventryItems/shimmer_item_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserLandingScreen extends StatefulWidget {
  @override
  _UserLandingScreenState createState() => _UserLandingScreenState();
}

class _UserLandingScreenState extends State<UserLandingScreen> {
  late String userId;
  late Future<Map<String, dynamic>> data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
    data = fetchRecommendations(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'New Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 190,
                          child: ShimmerItemCard(),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Recommendations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 190,
                          child: ShimmerItemCard(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<dynamic> recommendations = snapshot.data?['recommendations'];
            List<dynamic> newProducts = snapshot.data?['newProducts'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'New Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newProducts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 190,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/product',
                                    arguments: newProducts[index]['_id']);
                              },
                              child: ItemCard(item: newProducts[index])),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Recommendations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 190,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/product',
                                    arguments: recommendations[index]['_id']);
                              },
                              child: ItemCard(item: recommendations[index])),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
