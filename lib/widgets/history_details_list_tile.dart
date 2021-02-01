import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class HistoryDetailsListTile extends StatelessWidget {
  final String name;
  final String image;
  final String unit;
  final int price;
  final Widget child;

  HistoryDetailsListTile({
    this.name,
    this.image,
    this.unit,
    this.price,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kSubColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Image.network(
                image,
                fit: BoxFit.cover,
              ),
              title: Text(name),
              subtitle: Text('¥ $price / $unit'),
              contentPadding: EdgeInsets.all(8.0),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
