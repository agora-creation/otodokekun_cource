import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/providers/user_notice.dart';
import 'package:otodokekun_cource/screens/notice_details.dart';
import 'package:otodokekun_cource/services/user_notice.dart';
import 'package:otodokekun_cource/widgets/notice_list_tile.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    UserModel _user = userProvider.user;
    final userNoticeProvider = Provider.of<UserNoticeProvider>(context);
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
      body: StreamBuilder<QuerySnapshot>(
        stream: UserNoticeService().getNotices(userId: _user?.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('読み込み中'));
          }
          List<UserNoticeModel> notices = [];
          for (DocumentSnapshot notice in snapshot.data.docs) {
            notices.add(UserNoticeModel.fromSnapshot(notice));
          }
          if (notices.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              itemCount: notices.length,
              itemBuilder: (_, index) {
                UserNoticeModel _notice = notices[index];
                return NoticeListTile(
                  title: _notice.title,
                  read: _notice.read,
                  createdAt: DateFormat('yyyy年MM月dd日 HH:mm')
                      .format(_notice.createdAt)
                      .toString(),
                  onTap: () {
                    nextPage(
                      context,
                      NoticeDetailsScreen(
                        homeProvider: homeProvider,
                        userNoticeProvider: userNoticeProvider,
                        notice: _notice,
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('お知らせはありません'));
          }
        },
      ),
    );
  }
}
