import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/InventryItems/item_card.dart';
import 'package:decoar/Screens/InventryItems/shimmer_item_card.dart';
import 'package:flutter/material.dart';
import 'package:decoar/APICalls/inventry.dart';
import 'package:decoar/varsiables.dart';
import 'package:provider/provider.dart';

class InventryItems extends StatefulWidget {
  const InventryItems({Key? key}) : super(key: key);

  @override
  _InventryItemsState createState() => _InventryItemsState();
}

class _InventryItemsState extends State<InventryItems> {
  late Future<List<Map>> items;
  String? userId;

  void fetchUserId(context) {
    userId ??= Provider.of<UserProvider>(context).user?.userId;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserId(context);
    print(userId);
    items = fetchProductsByUserId(userId!);
  }

  Future<void> _refresh() async {
    setState(() {
      items = fetchProductsByUserId(userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addProduct');
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Map>>(
          future: items,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18.0,
                    mainAxisSpacing: 18.0,
                    childAspectRatio: 0.65,
                  ),
                  padding: EdgeInsets.all(10),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ShimmerItemCard();
                  });
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map> items = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      var result = await Navigator.pushNamed(
                        context,
                        '/inventryProduct',
                        arguments: items[index]['id'],
                      );

                      if (result == true) {
                        if (ModalRoute.of(context)?.isCurrent == true) {
                          _refresh();
                        }
                      }
                    },
                    child: ItemCard(item: items[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
