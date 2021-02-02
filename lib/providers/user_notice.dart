import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/services/user_notice.dart';

class UserNoticeProvider with ChangeNotifier {
  UserNoticeService _userNoticeService = UserNoticeService();

  FirebaseMessaging firebaseMessaging;

  void changeReadNotice({UserNoticeModel notice}) {
    _userNoticeService.updateNotice({
      'id': notice.id,
      'userId': notice.userId,
      'read': false,
    });
  }

  Stream<List<UserNoticeModel>> getNotices({String userId}) async* {
    List<UserNoticeModel> notices = [];
    notices = await _userNoticeService.getNotices(userId: userId);
    yield notices;
  }

  Future<void> initNotification() async {
    firebaseMessaging = FirebaseMessaging();
    if (Platform.isIOS) {
      bool permitted = await firebaseMessaging.requestNotificationPermissions();
      if (!permitted) {
        return;
      }
    }
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('FirebaseMessaging onMessage');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('FirebaseMessaging onLaunch');
      },
      onResume: (Map<String, dynamic> message) async {
        print('FirebaseMessaging onResume');
      },
    );
    String token = await firebaseMessaging.getToken();
    print('FirebaseMessaging token: $token');
  }
}
