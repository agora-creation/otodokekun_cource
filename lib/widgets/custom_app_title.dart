import 'package:flutter/material.dart';

class CustomAppTitle extends StatelessWidget {
  final String title;
  final Function onTap;

  CustomAppTitle({
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(title),
          SizedBox(width: 4.0),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
