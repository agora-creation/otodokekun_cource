import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class ProductListTile extends StatelessWidget {
  final String name;
  final String image;
  final String unit;
  final int price;
  final bool value;
  final Function onChanged;

  ProductListTile({
    this.name,
    this.image,
    this.unit,
    this.price,
    this.value,
    this.onChanged,
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
        child: CheckboxListTile(
          title: Text(name),
          subtitle: Text('¥ $price / $unit'),
          secondary: Image.network(
            image,
            fit: BoxFit.cover,
          ),
          value: value,
          activeColor: Colors.blueAccent,
          onChanged: onChanged,
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
