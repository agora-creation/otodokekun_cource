import 'package:flutter/material.dart';

class CustomTotalPriceListTile extends StatelessWidget {
  final String labelText;
  final Function onTap;

  CustomTotalPriceListTile({
    this.labelText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: ListTile(
          title: Text(labelText, style: TextStyle(color: Colors.white)),
          trailing: Icon(Icons.arrow_drop_up, color: Colors.white),
        ),
      ),
    );
  }
}
