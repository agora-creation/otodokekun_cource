import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class NoticeListTile extends StatelessWidget {
  final String createdAt;
  final String title;
  final bool read;
  final Function onTap;

  NoticeListTile({
    this.createdAt,
    this.title,
    this.read,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kSubColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        read
                            ? Icon(
                                Icons.circle,
                                color: Colors.redAccent,
                                size: 8.0,
                              )
                            : Container(),
                        read ? SizedBox(width: 8.0) : Container(),
                        Text(
                          createdAt,
                          style: TextStyle(
                            color: kSubColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.chevron_right, color: kSubColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
