import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/services/user_notice.dart';

class UserNoticeProvider with ChangeNotifier {
  UserNoticeService _userNoticeService = UserNoticeService();

  List<UserNoticeModel> notices = [];
  bool isRead = false;

  void changeReadNotice({UserNoticeModel notice}) {
    _userNoticeService.updateNotice({
      'id': notice.id,
      'userId': notice.userId,
      'read': false,
    });
  }

  Future getNotices({String userId}) async {
    notices = await _userNoticeService.getNotices(userId: userId);
    notifyListeners();
  }

  Future getNoticeRead({String userId}) async {
    isRead = await _userNoticeService.getNoticeRead(userId: userId);
    notifyListeners();
  }
}
