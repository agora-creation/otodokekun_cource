import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class CustomNoticeListTile extends StatelessWidget {
  final String createdAt;
  final String title;
  final bool read;
  final Function onTap;

  CustomNoticeListTile({
    this.createdAt,
    this.title,
    this.read,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Colors.grey.shade300,
            ),
          ),
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
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: kSubColor),
            ],
          ),
        ),
      ),
    );
  }
}
