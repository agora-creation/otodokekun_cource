import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class DeliveryWidget extends StatelessWidget {
  final String deliveryAt;
  final Function onTap;

  DeliveryWidget({
    this.deliveryAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: kSubColor),
              SizedBox(width: 8.0),
              Text(deliveryAt, style: TextStyle(color: kMainColor)),
            ],
          ),
        ),
      ),
    );
  }
}
