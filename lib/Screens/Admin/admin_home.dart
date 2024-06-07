import "package:decoar/Providers/User.dart";
import "package:decoar/Screens/Admin/all_items.dart";
import "package:decoar/Screens/Admin/all_users.dart";
import "package:decoar/Screens/Admin/payment.dart";
import "package:decoar/Screens/Recycke/search_screen.dart";
import "package:decoar/Screens/Recycke/searched_user.dart";
import "package:decoar/Screens/SearchScreen/search_suggestion_screen.dart";
import "package:decoar/Screens/ShowProduct/show_product.dart";
import "package:decoar/Screens/User/UserProfileScreen.dart";
import "package:decoar/Screens/User/user_home.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;
  late String userId;
  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AllItems(),
          AllUsers(),
          Search(),
          PaymentListScreen(),
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
            icon: Icon(Icons.list_alt),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_rounded),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
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
          case '/searchedUser':
            String userId = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => SearchedUser(userId: userId));
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
