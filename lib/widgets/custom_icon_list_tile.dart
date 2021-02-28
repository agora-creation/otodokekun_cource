import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class CustomIconListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;

  CustomIconListTile({
    this.iconData,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kSubColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: Icon(iconData, color: kSubColor),
          title: Text(title),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
