import 'dart:convert';

import 'package:decoar/Screens/InventryItems/item_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../varsiables.dart';

class AllItems extends StatefulWidget {
  const AllItems({Key? key}) : super(key: key);

  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  late Future<List<Map<String, dynamic>>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Item List'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No items found'));
              } else {
                List<Map<String, dynamic>> items = snapshot.data!;
                print(items);
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18.0,
                      mainAxisSpacing: 18.0,
                      childAspectRatio: 0.65,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pushNamed("/product",
                              arguments: items[index]['_id']);
                        },
                        child: ItemCard(item: items[index]),
                      );
                    });
              }
            }));
  }
}

Future<List<Map<String, dynamic>>> fetchItems() async {
  final response = await http.get(Uri.parse(url + "admin/products"));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(body);
    return items;
  } else {
    throw Exception('Failed to load items');
  }
}
