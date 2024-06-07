import 'package:decoar/Classes/User.dart';
import 'package:decoar/Providers/ChatProvider.dart';
import 'package:decoar/Providers/NotificationProvider.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/Admin/admin_home.dart';
import 'package:decoar/Screens/Analytics/ExcelView.dart';
import 'package:decoar/Screens/Chat/chat_screen.dart';
import 'package:decoar/Screens/Profiling/forgot_password.dart';
import 'package:decoar/Screens/Profiling/login.dart';
import 'package:decoar/Screens/Profiling/signup.dart';
import 'package:decoar/Screens/Recycke/searched_user.dart';
import 'package:decoar/Screens/Seller/seller_home.dart';
import 'package:decoar/Screens/ShowProduct/show_product.dart';
import 'package:decoar/Screens/User/user_home.dart';
import 'package:decoar/varsiables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = publishableKey;
  Stripe.merchantIdentifier = 'DecoAR fyp';
  await Stripe.instance.applySettings();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Box box = await Hive.openBox("user");
  Box carts = await Hive.openBox("carts");
  Box wlist = await Hive.openBox('wishlists');
  Box tempFilter = await Hive.openBox('temp_filter');
  Box filter_criteria = await Hive.openBox('filter_criteria');
  Box a = await Hive.openBox('sheet_filter_criteria');
  Box filter_critebbbria = await Hive.openBox('_timeFilterBox');

  var userString = box.get('user');
  User? user = userString != null ? User.fromJson(userString) : null;
  runApp(MyApp(user: user));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  late User? user;

  MyApp({super.key, this.user});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    await Hive.box("carts").close();
    await Hive.box("wishlists").close();
    await Hive.box("filter_criteria").close();
    await Hive.box("temp_filter").close();
    await Hive.box("sheet_filter_criteria").close();
    await Hive.box("_timeFilterBox").close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MyProviderApp(
          user: widget.user,
        ));
  }
}

class MyProviderApp extends StatefulWidget {
  late User? user;

  MyProviderApp({super.key, this.user});

  @override
  _MyProviderAppState createState() => _MyProviderAppState();
}

class _MyProviderAppState extends State<MyProviderApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context, listen: false).user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "DecoAr",
        theme: new ThemeData(scaffoldBackgroundColor: Color(0xFFF0F8FF)),
        initialRoute: widget.user == null
            ? "/login"
            : widget.user?.userType == 'user'
                ? '/userHome'
                : widget.user?.userType == 'seller'
                    ? '/sellerHome'
                    : '/adminHome',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/userHome':
              return MaterialPageRoute(builder: (_) => UserHome());
            case '/adminHome':
              return MaterialPageRoute(builder: (_) => AdminHome());
            case '/sellerHome':
              return MaterialPageRoute(builder: (_) => SellerHome());
            case '/register':
              return MaterialPageRoute(builder: (_) => MyRegister());
            case '/login':
              return MaterialPageRoute(builder: (_) => MyLogin());
            case '/forgotPassword':
              return MaterialPageRoute(
                  builder: (_) => ForgotPasswordEmailScreen());
            case '/searchedUserAdmin':
              String id;
              id = settings.arguments as String;
              return MaterialPageRoute(
                  builder: (_) => SearchedUser(userId: id));
            case '/chatScreen':
              {
                final Map<String, dynamic>? arguments =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          loggedinUser: arguments?['user'],
                          otherUser: arguments?['otheruser'],
                        ));
              }

            case '/product':
              String id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => ShowProduct(id: id),
              );

            // default:
            //   return MaterialPageRoute(builder: (_) => InventryItems());
          }
          return null;
        });
  }
}
