import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/providers/user_notice.dart';
import 'package:otodokekun_cource/screens/notice_details.dart';
import 'package:otodokekun_cource/widgets/notice_list_tile.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userNoticeProvider = Provider.of<UserNoticeProvider>(context)
      ..getNotices(userId: userProvider.user?.id);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        title: Text('お知らせ'),
      ),
      body: userNoticeProvider.notices.length > 0
          ? ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              itemCount: userNoticeProvider.notices.length,
              itemBuilder: (_, index) {
                UserNoticeModel _notice = userNoticeProvider.notices[index];
                return NoticeListTile(
                  createdAt: DateFormat('yyyy年MM月dd日 HH:mm')
                      .format(_notice.createdAt)
                      .toString(),
                  title: _notice.title,
                  read: _notice.read,
                  onTap: () {
                    if (_notice.read) {
                      userNoticeProvider.changeReadNotice(notice: _notice);
                    }
                    nextPage(context, NoticeDetailsScreen(notice: _notice));
                  },
                );
              },
            )
          : Center(child: Text('お知らせはありません')),
    );
  }
}
