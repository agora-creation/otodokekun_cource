import 'package:flutter/material.dart';

class CustomInvoicesListTile extends StatelessWidget {
  final String labelText;
  final Function onTap;

  CustomInvoicesListTile({
    this.labelText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(Icons.calendar_today, color: Colors.white),
          title: Text(labelText, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
