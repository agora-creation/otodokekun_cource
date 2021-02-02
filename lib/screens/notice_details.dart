import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/models/user_notice.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/user_notice.dart';

class NoticeDetailsScreen extends StatefulWidget {
  final HomeProvider homeProvider;
  final UserNoticeProvider userNoticeProvider;
  final UserNoticeModel notice;

  NoticeDetailsScreen({
    @required this.homeProvider,
    @required this.userNoticeProvider,
    @required this.notice,
  });

  @override
  _NoticeDetailsScreenState createState() => _NoticeDetailsScreenState();
}

class _NoticeDetailsScreenState extends State<NoticeDetailsScreen> {
  void readCheck() {
    if (widget.notice.read) {
      widget.userNoticeProvider.changeReadNotice(notice: widget.notice);
    }
  }

  @override
  void initState() {
    super.initState();
    readCheck();
  }

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
            widget.notice.title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.notice.message,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Divider(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              DateFormat('yyyy年MM月dd日 HH:mm')
                  .format(widget.notice.createdAt)
                  .toString(),
            ),
          ),
        ],
      ),
    );
  }
}
