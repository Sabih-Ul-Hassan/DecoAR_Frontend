import 'dart:convert';

import 'package:decoar/APICalls/cart.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/Recycke/user_reviews_bottom_sheet.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

Future<Map<String, dynamic>> fetchUser(String userId) async {
  final response = await http.get(Uri.parse(url + 'search/user/' + userId));

  if (response.statusCode == 200) {
    print(Map<String, dynamic>.from(json.decode(response.body)));
    return Map<String, dynamic>.from(json.decode(response.body));
  } else {
    return {};
  }
}

class SearchedUser extends StatefulWidget {
  late String userId;
  SearchedUser({super.key, required this.userId});

  @override
  _SearchedUserState createState() => _SearchedUserState();
}

class _SearchedUserState extends State<SearchedUser> {
  late Future<Map<String, dynamic>> user;
  late String currentUser;
  @override
  void initState() {
    super.initState();
    user = fetchUser(widget.userId);
    print(user);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentUser =
        Provider.of<UserProvider>(context, listen: false).user!.userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No user found'));
          } else {
            final user = snapshot.data!;
            final avg = user['averageRating'];
            final deleted = user['deleted'] ?? false;
            return Padding(
              padding: const EdgeInsets.all(5.0),
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
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                    Row(children: [
                      Text(
                        "(${user['reviews']} ratings)",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      ...List.generate(
                          5,
                          (index) => Icon(
                                index > avg && index == avg.ceil()
                                    ? Icons.star_half
                                    : Icons.star,
                                color: index < avg ||
                                        index == avg.ceil() && index != avg
                                    ? Colors.yellow
                                    : Colors.grey,
                              ))
                    ]),
                    if (deleted)
                      const Text("Deleted",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red)),
                    SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed('/chatScreen', arguments: {
                                "user": currentUser,
                                "otheruser": widget.userId
                              });
                            },
                            child: Text("Chat"))),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.9,
                                  ),
                                  child: UserReviewsBottomSheet(
                                      userId: widget.userId));
                            },
                          );
                        },
                        child: Text('Reviews'),
                      ),
                    ),
                    if (Provider.of<UserProvider>(context).user!.userType ==
                            "admin" &&
                        !deleted)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await deleteUserById(widget.userId);
                            final scaffold = ScaffoldMessenger.of(context);

                            scaffold.showSnackBar(
                              const SnackBar(
                                content: Text('User deleted'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ),
                    if (Provider.of<UserProvider>(context).user!.userType ==
                        "admin")
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await toggleAdmin(widget.userId);
                            final scaffold = ScaffoldMessenger.of(context);

                            scaffold.showSnackBar(
                              const SnackBar(
                                content: Text('Updated'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Text(user["admin"] == false
                              ? "Make admin"
                              : "remove admin"),
                        ),
                      ),
                  ]),
            );
          }
        },
      ),
    );
  }
}

Future<bool> deleteUserById(String UserId) async {
  final apiUrl = url + 'admin/toggle/' + UserId;

  try {
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool> toggleAdmin(String UserId) async {
  final apiUrl = url + 'admin/toggle/' + UserId;

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}
