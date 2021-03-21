import 'package:flutter/material.dart';

class CustomProductsListTile extends StatelessWidget {
  final String name;
  final String image;
  final String unit;
  final int price;
  final Function onTap;
  final Widget child;

  CustomProductsListTile({
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
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              trailing: onTap != null
                  ? GestureDetector(
                      onTap: onTap,
                      child: Icon(Icons.clear, color: Colors.redAccent),
                    )
                  : null,
            ),
            Divider(height: 0.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
