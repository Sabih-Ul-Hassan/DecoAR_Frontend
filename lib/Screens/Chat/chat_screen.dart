import 'package:decoar/APICalls/chats.dart';
import 'package:decoar/Providers/ChatProvider.dart';
import 'package:decoar/Providers/NotificationProvider.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  late String loggedinUser;
  late String otherUser;
  ChatScreen({required this.loggedinUser, required this.otherUser});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msg = TextEditingController();
  ScrollController scrollController = ScrollController();
  late NotificationProvider notificationProvider;
  late ChatProvider chatProvider;
  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    chatProvider.loadCats(widget.loggedinUser, widget.otherUser);
    chatProvider.scrollDown = scrollDown;
    notificationProvider.addMessageOnChatScreen(chatProvider.addMessage);
    notificationProvider.loadChatScreen();
  }

  @override
  void dispose() {
    super.dispose();
    notificationProvider.unloadChatScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: chatProvider.chatData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Shimmer effect while loading
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 120,
                  height: 20,
                  color: Colors.white,
                ),
              );
            } else {
              // Display user name when data is available
              return Text(snapshot.data?['users'][snapshot.data?['users'][0]
                              ['userId']['_id'] ==
                          widget.loggedinUser
                      ? 1
                      : 0]['userId']['name'] ??
                  'User');
            }
          },
        ),
      ),
      body: FutureBuilder(
        future: chatProvider.chatData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(radius: 25),
                    title: Container(
                      width: double.infinity,
                      height: 15,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 10,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            );
          } else {
            scrollDown(time: 0);

            late String loggedinUsersImage;
            late String otherUsersImage;

            if (widget.loggedinUser ==
                snapshot.data?['users'][0]['userId']['_id']) {
              loggedinUsersImage =
                  "${url}uploads/${snapshot.data?['users'][0]['userId']['picture']}";
              otherUsersImage =
                  "${url}uploads/${snapshot.data?['users'][1]['userId']['picture']}";
            } else {
              otherUsersImage =
                  "${url}uploads/${snapshot.data?['users'][0]['userId']['picture']}";
              loggedinUsersImage =
                  "${url}uploads/${snapshot.data?['users'][1]['userId']['picture']}";
            }
            return Container(
              child: Consumer<ChatProvider>(
                builder:
                    (BuildContext context, ChatProvider value, Widget? child) =>
                        Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: snapshot.data?['messages'].length,
                        itemBuilder: (context, index) {
                          final message = snapshot.data?['messages'][index];
                          final isMyMessage =
                              message?['sender'] == widget.loggedinUser;
                          return ListTile(
                              leading: isMyMessage
                                  ? CircleAvatar(
                                      radius: 25,
                                      child: ClipOval(
                                        child: Image.network(
                                          loggedinUsersImage,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : SizedBox(width: 40),
                              title: Align(
                                alignment: isMyMessage
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: EdgeInsets.all(9.0),
                                  child: Text(
                                    message['content'],
                                    textDirection: isMyMessage
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                  ),
                                ),
                              ),
                              subtitle: Align(
                                alignment: isMyMessage
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(
                                  message['timestamp'],
                                  textDirection: isMyMessage
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              trailing: isMyMessage
                                  ? SizedBox(width: 40)
                                  : CircleAvatar(
                                      radius: 25,
                                      child: ClipOval(
                                        child: Image.network(
                                          otherUsersImage,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ));
                        },
                      ),
                    ),
                    // Input field and send button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: msg,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              final messageContent = msg.text;
                              try {
                                await sendMessage(snapshot.data?['_id'],
                                    widget.loggedinUser, messageContent);

                                chatProvider.addMessage({
                                  "sender": widget.loggedinUser,
                                  "content": messageContent,
                                  "timestamp": DateTime.timestamp().toString()
                                });
                                msg.text = "";
                              } catch (e) {
                                print('Error sending message: $e');
                              }
                            },
                            child: Text('Send'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void scrollDown({int time = 300}) {
    time == 0
        ? WidgetsBinding.instance!.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          })
        : WidgetsBinding.instance!.addPostFrameCallback((_) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: time),
              curve: Curves.easeOut,
            );
          });
  }
}
