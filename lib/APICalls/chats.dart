import 'dart:convert';
import 'package:decoar/varsiables.dart';
import 'package:http/http.dart' as http;

// API endpoint for getting or creating a chat
Future<Map<String, dynamic>> getChat(
    String requestingUserId, String userId2) async {
  final _url = '${url}chats/getChat/$requestingUserId/$userId2';

  final response = await http.get(Uri.parse(_url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get or create chat');
  }
}

// API endpoint for sending a message
Future<void> sendMessage(String chatId, String senderId, String content) async {
  final _url = '${url}chats/sendMessage/$chatId';

  final response = await http.put(
    Uri.parse(_url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'senderId': senderId, 'content': content}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to send message');
  }
}

Future<List<Map<String, dynamic>>?> getAllChats(String userId) async {
  final String apiUrl = '${url}chats/getAllChats/$userId';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    print(response);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return List<Map<String, dynamic>>.from(jsonData);
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Exception: $error');
    return null;
  }
}
