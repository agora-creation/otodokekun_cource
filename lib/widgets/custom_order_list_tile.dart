import 'package:flutter/material.dart';

class CustomOrderListTile extends StatelessWidget {
  final String deliveryAt;
  final String name;
  final bool shipping;
  final Function onTap;

  CustomOrderListTile({
    this.deliveryAt,
    this.name,
    this.shipping,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: ListTile(
          leading: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Text(deliveryAt),
            ),
          ),
          title: ListTile(
            title: Text(name),
            subtitle: shipping ? Text('配達完了') : Text('配達待ち'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
