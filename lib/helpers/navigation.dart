import 'package:flutter/material.dart';

void nextPage(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void changePage(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: true,
    ),
  );
}
