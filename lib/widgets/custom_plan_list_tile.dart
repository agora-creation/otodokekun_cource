import 'package:flutter/material.dart';

class CustomPlanListTile extends StatelessWidget {
  final String deliveryAt;
  final String name;
  final String image;
  final String unit;
  final int price;
  final String description;

  CustomPlanListTile({
    this.deliveryAt,
    this.name,
    this.image,
    this.unit,
    this.price,
    this.description,
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
                leading: image != ''
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                      )
                    : null,
                title: Text(name),
                subtitle: Text('¥ $price / $unit'),
              ),
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
