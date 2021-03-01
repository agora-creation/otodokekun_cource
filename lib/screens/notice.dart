import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/providers/user_notice.dart';
import 'package:otodokekun_cource/screens/notice_details.dart';
import 'package:otodokekun_cource/widgets/custom_notice_list_tile.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    UserModel _user = userProvider.user;
    final userNoticeProvider = Provider.of<UserNoticeProvider>(context);
    final Stream<QuerySnapshot> streamNotice = FirebaseFirestore.instance
        .collection('user')
        .doc(_user?.id)
        .collection('notice')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Text('お知らせ'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: streamNotice,
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
                return CustomNoticeListTile(
                  createdAt:
                      '${DateFormat('yyyy年MM月dd日 HH:mm').format(_notice.createdAt)}',
                  title: _notice.title,
                  read: _notice.read,
                  onTap: () {
                    if (_notice.read) {
                      userNoticeProvider.updateRead(notice: _notice);
                    }
                    nextPage(context, NoticeDetailsScreen(notice: _notice));
                  },
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
