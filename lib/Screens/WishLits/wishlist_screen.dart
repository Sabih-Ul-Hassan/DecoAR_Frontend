import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'wishlist_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  final String userId;

  const WishlistScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Box<dynamic> wishlistsBox;

  @override
  void initState() {
    super.initState();
    wishlistsBox = Hive.box('wishlists');
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
      body: _buildWishlistGrid(),
    );
  }

  Widget _buildWishlistGrid() {
    return StreamBuilder(
      stream: wishlistsBox.watch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          {
            final Map<dynamic, dynamic>? userWishlists =
                wishlistsBox.get(widget.userId);
            if (userWishlists == null || userWishlists.isEmpty) {
              return Center(child: Text('No wishlists available'));
            }

            return GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: userWishlists.values.map<Widget>((wishlist) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WishlistDetailScreen(
                          userId: widget.userId,
                          wishlist: wishlist,
                        ),
                      ),
                    );
                  },
                  child: _buildWishlistRow(wishlist),
                );
              }).toList(),
            );
          }
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No wishlists available'));
        }

        final Map<dynamic, dynamic>? userWishlists =
            wishlistsBox.get(widget.userId);
        if (userWishlists == null || userWishlists.isEmpty) {
          return Center(child: Text('No wishlists available'));
        }

        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: userWishlists.values.map<Widget>((wishlist) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WishlistDetailScreen(
                      userId: widget.userId,
                      wishlist: wishlist,
                    ),
                  ),
                );
              },
              child: _buildWishlistRow(wishlist),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildWishlistRow(Map<dynamic, dynamic> wishlist) {
    return Column(
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
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                          )
                        : SizedBox(),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
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

  void _createNewWishlist(String wishlistName) {
    if (wishlistName.isNotEmpty) {
      Map<dynamic, dynamic> newWishlist = {
        'name': wishlistName,
        'items': [],
      };
      final Map<dynamic, dynamic> userWishlists =
          Map<dynamic, dynamic>.from(wishlistsBox.get(widget.userId) ?? {});
      userWishlists[wishlistName] = newWishlist;
      wishlistsBox.put(widget.userId, userWishlists);
    }
  }
}
