import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  int selectedIndex = 0;
  bool isLoading = false;
  FirebaseMessaging firebaseMessaging;

  void changeTabs(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
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
