import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  int tabsIndex = 0;
  bool isLoading = false;

  String get token => _token;

  void changeTabs(int index) {
    tabsIndex = index;
    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> initFCM() async {
    //iOS PUSH通知の許可確認
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    //FCM tokenの取得
    _firebaseMessaging.getToken().then((token) {
      _token = token;
      print("token: $_token");
    });
    //メッセージ受信時の処理
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
    );
  }
}
