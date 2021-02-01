import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class SettingListTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function onTap;

  SettingListTile({
    this.title,
    this.iconData,
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
          leading: Icon(iconData),
          title: Text(title),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
