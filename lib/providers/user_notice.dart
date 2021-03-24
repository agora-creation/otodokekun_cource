import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/services/user_notice.dart';

class UserNoticeProvider with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  String _message;
  UserNoticeService _userNoticeService = UserNoticeService();

  String get token => _token;
  String get message => _message;

  void updateRead({UserNoticeModel notice}) {
    _userNoticeService.update({
      'id': notice.id,
      'userId': notice.userId,
      'read': false,
    });
  }

  Future<void> initFCM() async {
    //iOS PUSH通知の許可確認
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    //FCM tokenの取得
    _firebaseMessaging.getToken().then((token) {
      _token = token;
      notifyListeners();
      print("token: $_token");
    });
    //メッセージ受信時の処理
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _message = 'onMessage: $message';
        notifyListeners();
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        _message = 'onLaunch: $message';
        notifyListeners();
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        _message = 'onResume: $message';
        notifyListeners();
        print("onResume: $message");
      },
    );
  }
}
