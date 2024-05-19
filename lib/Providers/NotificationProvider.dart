import 'package:decoar/NotificationsServices/NotificationsServices.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {
  bool isChatScreenLoaded = false;
  bool initilized = false;

  late NotificationsServices notificationsServices;
  void initilize(context) {
    if (initilized) return;
    notificationsServices = NotificationsServices();
    notificationsServices.requestNotificationPermission();
    notificationsServices.firebaseInit(context);
    NotificationsServices.getDeviceToken().then((value) => print(value));
    initilized = true;
  }

  void loadChatScreen() {
    notificationsServices.chatScreen = true;
  }

  void unloadChatScreen() {
    notificationsServices.chatScreen = false;
  }

  void addMessageOnChatScreen(Function f) {
    notificationsServices.initilizeaddMessageOnChatScreen(f);
  }
}
