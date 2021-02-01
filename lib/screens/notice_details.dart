import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/models/user_notice.dart';

class NoticeDetailsScreen extends StatelessWidget {
  final UserNoticeModel notice;

  NoticeDetailsScreen({@required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お知らせ詳細'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        children: [
          Text(
            notice.title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            notice.message,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Divider(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              DateFormat('yyyy年MM月dd日 HH:mm')
                  .format(notice.createdAt)
                  .toString(),
            ),
          ),
        ],
      ),
    );
  }
}
