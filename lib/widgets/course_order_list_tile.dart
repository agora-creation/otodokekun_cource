import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class CourseOrderListTile extends StatelessWidget {
  final String openedAt;
  final String closedAt;
  final String name;
  final List<Widget> children;
  final Widget child;

  CourseOrderListTile({
    this.openedAt,
    this.closedAt,
    this.name,
    this.children,
    this.child,
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
          children: [
            Theme(
              data: _theme,
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$openedAt 〜 $closedAt',
                      style: TextStyle(fontSize: 14.0, color: Colors.black54),
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 18.0, color: Colors.black87),
                    ),
                  ],
                ),
                children: children,
                tilePadding: EdgeInsets.all(8.0),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
