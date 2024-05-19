import 'package:flutter/foundation.dart';
import '../APICalls/chats.dart';

class ChatProvider with ChangeNotifier {
  late Future<Map<String, dynamic>> chatData;
  late Function scrollDown;
  void loadCats(requestingUser, user2) {
    chatData = getChat(requestingUser, user2);
  }

  void addMessage(Map<String, dynamic> message) async {
    dynamic data = await chatData;
    data['messages'].add(message);
    notifyListeners();
    scrollDown();
  }
}
