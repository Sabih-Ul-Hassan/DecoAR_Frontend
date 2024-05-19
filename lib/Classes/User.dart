import 'dart:convert';

class User {
  late String userId;
  late String userType;
  late Map<String, dynamic> user;

  User({required this.userId, required this.userType, required this.user});

  factory User.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return User(
      userId: jsonMap['userId'],
      userType: jsonMap['userType'],
      user: jsonMap['user'],
    );
  }

  @override
  String toString() {
    return jsonEncode({"userId": userId, "userType": userType, "user": user});
  }
}
