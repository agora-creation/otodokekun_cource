import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class CourseListTile extends StatelessWidget {
  final String openedAt;
  final String closedAt;
  final String name;
  final List<Widget> children;
  final Function onPressed;

  CourseListTile({
    this.openedAt,
    this.closedAt,
    this.name,
    this.children,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kSubColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$openedAt 〜 $closedAt',
                        style: TextStyle(fontSize: 14.0, color: Colors.black54),
                      ),
                      Text(
                        name,
                        style: TextStyle(fontSize: 18.0, color: Colors.black87),
                      )
                    ],
                  ),
                  FlatButton(
                    child: Text('注文する', style: TextStyle(color: Colors.white)),
                    color: Colors.blueAccent,
                    shape: StadiumBorder(),
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
            Theme(
              data: _theme,
              child: ExpansionTile(
                title: Text(
                  '商品詳細',
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
