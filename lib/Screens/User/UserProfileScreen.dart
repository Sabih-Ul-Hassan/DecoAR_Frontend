import 'package:decoar/Classes/User.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).user!.userId;
    final user = Provider.of<UserProvider>(context).user!.user;
    User userobj = Provider.of<UserProvider>(context).user!;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(url + "uploads/" + user['picture']),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user['email'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Address: ${user['address']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Balance: \$${user['balance']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // if (!Hive.isBoxOpen('sheet_filter_criteria'))
                //   await Hive.openBox('sheet_filter_criteria');
                // if (!Hive.isBoxOpen('_timeFilterBox'))
                //   await Hive.openBox('_timeFilterBox');

                Provider.of<UserProvider>(context, listen: false)
                    .user!
                    .userType = userobj.userType == "user" ? "seller" : "user";
                Navigator.of(context).pushReplacementNamed(
                    userobj.userType == "user" ? "/userHome" : "/sellerHome");
                Hive.box("user").put(
                    'user',
                    Provider.of<UserProvider>(context, listen: false)
                        .user!
                        .toString());
              },
              child: Text(
                  'Switch to ${userobj.userType == "user" ? "Seller" : "Customer"}'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!Hive.isBoxOpen("user")) Hive.openBox("user");
                Provider.of<UserProvider>(context, listen: false).user = null;
                Navigator.of(context).pushReplacementNamed("/login");
                Hive.box("user").clear();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
