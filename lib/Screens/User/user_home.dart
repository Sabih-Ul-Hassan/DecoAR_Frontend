import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/Cart/cart_screen.dart';
import 'package:decoar/Screens/Chat/chat_screen.dart';
import 'package:decoar/Screens/Notifications/notifications_screen.dart';
import 'package:decoar/Screens/Recycke/search_screen.dart';
import 'package:decoar/Screens/SearchScreen/search_suggestion_screen.dart';
import 'package:decoar/Screens/ShowProduct/show_product.dart';
import 'package:decoar/Screens/User/UserProfileScreen.dart';
import 'package:decoar/Screens/UserLanding/user_lading_screen.dart';
import 'package:decoar/Screens/UserOrder/OrderDetail.dart';
import 'package:decoar/Screens/UserOrder/user_orders.dart';
import 'package:decoar/Screens/WishLits/wishlist_screen.dart';
import 'package:decoar/Screens/chatsScreen/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../OrderNav/order.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);
  @override
  void initState() {}

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _currentIndex = 0;
  late String userId;
  @override
  void initState() {
    super.initState();
    manageBoxes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
  }

  void manageBoxes() async {
    if (!Hive.isBoxOpen("user")) {
      Hive.openBox("user").then((value) => setState(() {}));
    }
    if (!Hive.isBoxOpen("carts"))
      Hive.openBox("carts").then((value) => setState(() {}));
    if (!Hive.isBoxOpen("wishlists"))
      Hive.openBox('wishlists').then((value) => setState(() {}));
    if (!Hive.isBoxOpen("temp_filter"))
      Hive.openBox('temp_filter').then((value) => setState(() {}));
    if (!Hive.isBoxOpen("filter_criteria"))
      Hive.openBox('filter_criteria').then((value) => setState(() {}));
    if (!Hive.isBoxOpen("sheet_filter_criteria"))
      Hive.openBox('sheet_filter_criteria').then((value) => setState(() {}));
    if (!Hive.isBoxOpen("_timeFilterBox"))
      Hive.openBox('_timeFilterBox').then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          UserLandingScreen(),
          Search(),
          CartScreen(),
          WishlistScreen(
            userId: userId,
          ),
          ChatsScreen(),
          Order(),
          NotificationsScreen(),
          UserProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'WishList',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_sharp),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_sharp),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/searchSuggestionScreen',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/product':
            String id;
            id = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ShowProduct(id: id),
            );

          case '/searchScreen':
            String query;
            if (settings.arguments != null)
              query = settings.arguments as String;
            else
              query = "none";
            return MaterialPageRoute(
                builder: (_) => SearchScreen(query: query));
          case '/searchSuggestionScreen':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SearchSuggestionScreen();
              },
              transitionDuration: Duration.zero,
            );
        }
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Enter some text',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(_textEditingController.text);
              },
              child: Text('Print Text'),
            ),
          ],
        ),
      ),
    );
  }
}
