import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  CustomDialog({
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: content,
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      actions: actions,
      actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}
