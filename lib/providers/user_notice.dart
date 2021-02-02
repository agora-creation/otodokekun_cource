import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/services/user_notice.dart';

class UserNoticeProvider with ChangeNotifier {
  UserNoticeService _userNoticeService = UserNoticeService();

  void changeReadNotice({UserNoticeModel notice}) {
    _userNoticeService.updateNotice({
      'id': notice.id,
      'userId': notice.userId,
      'read': false,
    });
  }
}
