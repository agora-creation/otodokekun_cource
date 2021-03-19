import 'package:flutter/material.dart';

class CustomProductListTile extends StatelessWidget {
  final String name;
  final String image;
  final String unit;
  final int price;
  final String description;
  final bool value;
  final Function onChanged;

  CustomProductListTile({
    this.name,
    this.image,
    this.unit,
    this.price,
    this.description,
    this.value,
    this.onChanged,
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
            CheckboxListTile(
              secondary: image != ''
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(name),
              subtitle: Text('¥ $price / $unit'),
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blueAccent,
            ),
            Divider(height: 0.0),
            description != ''
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      description,
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
