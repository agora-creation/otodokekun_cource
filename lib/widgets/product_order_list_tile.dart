import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class ProductOrderListTile extends StatelessWidget {
  final String name;
  final String image;
  final String unit;
  final int price;
  final Function onTap;
  final Widget child;

  ProductOrderListTile({
    this.name,
    this.image,
    this.unit,
    this.price,
    this.onTap,
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
              leading: image != ''
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(name),
              subtitle: Text('¥ $price / $unit'),
              trailing: GestureDetector(
                onTap: onTap,
                child: Icon(Icons.close, color: kMainColor),
              ),
              contentPadding: EdgeInsets.all(8.0),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
