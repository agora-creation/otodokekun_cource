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

  Future<List<UserNoticeModel>> getNotices({String userId}) async {
    List<UserNoticeModel> notices = [];
    notices = await _userNoticeService.getNotices(userId: userId);
    return notices;
  }

  Future<Icon> getNoticeRead({String userId}) async {
    bool isRead = false;
    isRead = await _userNoticeService.getNoticeRead(userId: userId);
    if (isRead) {
      return Icon(
        Icons.notifications_active,
        color: Colors.redAccent,
      );
    } else {
      return Icon(Icons.notifications_none);
    }
  }
}
