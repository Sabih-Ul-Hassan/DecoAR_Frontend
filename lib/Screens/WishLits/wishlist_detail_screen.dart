import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WishlistDetailScreen extends StatefulWidget {
  final String userId;
  final Map<dynamic, dynamic> wishlist;

  const WishlistDetailScreen({
    Key? key,
    required this.userId,
    required this.wishlist,
  }) : super(key: key);

  @override
  _WishlistDetailScreenState createState() => _WishlistDetailScreenState();
}

class _WishlistDetailScreenState extends State<WishlistDetailScreen> {
  late Map<dynamic, dynamic> _wishlist;

  @override
  void initState() {
    super.initState();
    _wishlist = widget.wishlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_wishlist['name']),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _removeWishlist(context);
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _wishlist['items'].length,
        itemBuilder: (BuildContext context, int index) {
          final item = _wishlist['items'][index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/product', arguments: item['_id']);
            },
            child: Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9, // Set the aspect ratio
                    child: Image.network(
                      url + "uploads/" + item['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            _removeItemFromWishlist(context, index);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _removeItemFromWishlist(BuildContext context, int index) {
    final List<dynamic> items = _wishlist['items'];
    items.removeAt(index);
    _updateWishlist(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item removed from wishlist'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  void _removeWishlist(BuildContext context) {
    final Box<dynamic> wishlistsBox = Hive.box('wishlists');
    final Map<dynamic, dynamic> wishlists = wishlistsBox.get(widget.userId);
    wishlists.remove(_wishlist['name']);
    wishlistsBox.put(widget.userId, wishlists);
    Navigator.of(context)
        .pop(); // Optionally, you can navigate back after removing the wishlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wishlist removed'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  void _updateWishlist(BuildContext context) {
    final Box<dynamic> wishlistsBox = Hive.box('wishlists');
    final Map<dynamic, dynamic> wishlists = wishlistsBox.get(widget.userId);
    wishlists[_wishlist['name']] = _wishlist;
    wishlistsBox.put(widget.userId, wishlists);
    setState(() {
      _wishlist = Map.from(_wishlist);
    });
  }
}
