import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class DeliveryListTile extends StatelessWidget {
  final String deliveryAt;
  final Function onTap;

  DeliveryListTile({
    this.deliveryAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(deliveryAt, style: TextStyle(color: kMainColor)),
                Icon(Icons.calendar_today, color: kSubColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
