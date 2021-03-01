import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final IconData iconData;
  final String labelText;

  LabelWidget({
    this.iconData,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData),
        SizedBox(width: 4.0),
        Text(labelText),
      ],
    );
  }
}
