import 'package:decoar/APICalls/notification.dart';
import 'package:decoar/Providers/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<Map<String, dynamic>>> notifications;
  late String userId;
  String current = 'All';
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
    notifications = fetchNotifications(userId, current);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TabPill(
                  value: "All",
                  current: current,
                  change: () => setState(() {
                        this.current = "All";
                        this.notifications =
                            fetchNotifications(userId, current);
                      })),
              TabPill(
                  value: "User",
                  current: current,
                  change: () => setState(() {
                        this.current = "User";
                        this.notifications =
                            fetchNotifications(userId, current);
                      })),
              TabPill(
                  value: "Seller",
                  current: current,
                  change: () => setState(() {
                        this.current = "Seller";
                        this.notifications =
                            fetchNotifications(userId, current);
                      })),
            ],
          ),
          FutureBuilder(
            future: notifications,
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final notifications = snapshot.data!;

                return Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final notificationText = notification['notification'];
                        final date = DateTime.parse(notification['createdAt']);
                        final formattedDate =
                            '${_formatDate(date)} ${_formatTime(date)}';

                        return Column(
                          children: [
                            ListTile(
                              title: Text(notificationText),
                              subtitle: Text(
                                formattedDate,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                              ),
                            ),
                            const Center(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                indent: 60,
                                endIndent: 60,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute}';
  }
}

class TabPill extends StatelessWidget {
  final String value;
  final String current;
  final Function change;
  const TabPill(
      {super.key,
      required this.value,
      required this.current,
      required this.change});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => change(),
      child: Container(
        constraints: BoxConstraints(minWidth: 110),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Center(child: Text(value)),
        decoration: BoxDecoration(
            color: value == current ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(80),
            border: Border.all(color: Colors.white, width: 2)),
      ),
    );
  }
}
