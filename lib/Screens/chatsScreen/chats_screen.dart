import 'package:decoar/APICalls/chats.dart';
import 'package:decoar/NotificationsServices/NotificationsServices.dart';
import 'package:decoar/Providers/NotificationProvider.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late NotificationProvider notificationsprovider;
  late Future<List<Map<String, dynamic>>?> data;
  String? userId = null;

  void fetchUserId(context) {
    userId ??= Provider.of<UserProvider>(context).user?.userId;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserId(context);
    data = getAllChats(userId!);
    notificationsprovider = Provider.of<NotificationProvider>(context);
    notificationsprovider.initilize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerEffect();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> chats =
                snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(chats[index]['otherUserName']),
                    subtitle:
                        Text(chats[index]['lastMessage'] ?? 'No messages'),
                    leading: CircleAvatar(
                      radius: 25,
                      child: ClipOval(
                        child: Image.network(
                          "${url}uploads/${chats[index]['otherUserPicture']}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () async {
                      await Navigator.pushNamed(context, '/chatScreen',
                          arguments: {
                            "otheruser": chats[index]['otherUserId'],
                            "user": userId
                          });
                      setState(() {
                        data = getAllChats(userId!);
                      });
                    },
                    trailing: chats[index]['userHasReadAllMessages'] == false
                        ? Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.all(8.0),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Adjust the number of shimmer items
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.white,
            ),
            subtitle: Container(
              width: double.infinity,
              height: 12.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
