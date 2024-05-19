import 'package:decoar/Screens/AddProduct/add_product.dart';
import 'package:decoar/Screens/Analytics/AnalyticsScreen.dart';
import 'package:decoar/Screens/Analytics/ExcelView.dart';
import 'package:decoar/Screens/InventryItems/inventry_items.dart';
import 'package:decoar/Screens/Notifications/notifications_screen.dart';
import 'package:decoar/Screens/OrderNav/order.dart';
import 'package:decoar/Screens/ShowProduct/show_product.dart';
import 'package:decoar/Screens/UpdateProduct/update_product.dart';
import 'package:decoar/Screens/User/UserProfileScreen.dart';
import 'package:decoar/Screens/chatsScreen/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({Key? key}) : super(key: key);

  @override
  _SellerHomeState createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Inventory(),
          ChatsScreen(),
          Order(),
          NotificationsScreen(),
          AnalyticsScreen(),
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
            icon: Icon(Icons.inventory),
            label: 'Inventory',
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
            icon: Icon(Icons.auto_graph_outlined),
            label: 'Analytics',
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

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/inventory',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/inventory':
            return MaterialPageRoute(builder: (_) => const InventryItems());
          case '/inventryProduct':
            String id;
            id = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ShowProduct(id: id),
            );
          case '/updateProduct':
            Map item;
            item = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (_) => UpdateProduct(item: item),
            );
          case '/addProduct':
            return MaterialPageRoute(builder: (_) => AddProduct());
        }
      },
    );
  }
}
