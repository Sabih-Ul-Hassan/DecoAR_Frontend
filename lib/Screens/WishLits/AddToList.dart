import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddToList extends StatefulWidget {
  final String userId;
  late Map item;
  AddToList({Key? key, required this.userId, required this.item})
      : super(key: key);

  @override
  _AddToListState createState() => _AddToListState();
}

class _AddToListState extends State<AddToList> {
  late ValueNotifier<Box<dynamic>> wishlistsNotifier;

  @override
  void initState() {
    super.initState();
    wishlistsNotifier = ValueNotifier(Hive.box('wishlists'));
  }

  @override
  void dispose() {
    wishlistsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlists'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showNewWishlistDialog(context);
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: wishlistsNotifier,
        builder: (context, Box<dynamic> wishlistsBox, child) {
          return _buildWishlistGrid(wishlistsBox);
        },
      ),
    );
  }

  Widget _buildWishlistGrid(Box<dynamic> wishlistsBox) {
    final Map<dynamic, dynamic>? userWishlists =
        wishlistsBox.get(widget.userId);
    if (userWishlists == null || userWishlists.isEmpty) {
      return Center(child: Text('No wishlists available'));
    }

    return SingleChildScrollView(
      child: Center(
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: userWishlists.values.map<Widget>((wishlist) {
            return _buildWishlistRow(wishlist);
          }).toList(),
        ),
      ),
    );
  }

  void _addItemToWishlist(Map<dynamic, dynamic> wishlist) {
    final Box<dynamic> wishlistsBox = Hive.box('wishlists');
    final List<dynamic> items = wishlist['items'];

    final bool isDuplicate =
        items.any((item) => item['_id'] == widget.item['_id']);

    if (!isDuplicate) {
      items.add(widget.item);
      wishlistsBox.put(widget.userId, wishlistsBox.get(widget.userId));

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item added to wishlist'),
          duration: Duration(milliseconds: 500),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item already exists in the wishlist'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  Widget _buildWishlistRow(Map<dynamic, dynamic> wishlist) {
    return GestureDetector(
      onTap: () {
        _addItemToWishlist(wishlist);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              wishlist['name'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  final item = index < wishlist['items'].length
                      ? wishlist['items'][index]
                      : null;
                  return SizedBox(
                    width: 75,
                    height: 75,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: item != null ? Colors.white : Colors.grey,
                      ),
                      child: item != null
                          ? Image.network(
                              url + "uploads/" + item['imageUrl'],
                              height: 50, // Adjust the height of the image
                              width: 50, // Adjust the width of the image
                              fit: BoxFit.contain,
                            )
                          : SizedBox(), // If no item, just leave it empty
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showNewWishlistDialog(BuildContext context) {
    String wishlistName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Wishlist'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Wishlist Name'),
            onChanged: (value) {
              wishlistName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createNewWishlist(wishlistName);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createNewWishlist(dynamic wishlistName) {
    if (wishlistName.isNotEmpty) {
      final wishlistsBox = Hive.box('wishlists');
      Map<dynamic, dynamic> newWishlist = {
        'name': wishlistName,
        'items': [],
      };
      final Map<dynamic, dynamic> userWishlists =
          Map<dynamic, dynamic>.from(wishlistsBox.get(widget.userId) ?? {});
      userWishlists[wishlistName] = newWishlist;
      wishlistsBox.put(widget.userId, userWishlists);
      wishlistsNotifier.value = wishlistsBox;
    }
  }
}
