import 'package:flutter/material.dart';

class CustomProductRegularListTile extends StatelessWidget {
  final String deliveryAt;
  final String productName;
  final String productImage;
  final String productUnit;
  final int productPrice;
  final String productDescription;

  CustomProductRegularListTile({
    this.deliveryAt,
    this.productName,
    this.productImage,
    this.productUnit,
    this.productPrice,
    this.productDescription,
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
                leading: productImage != ''
                    ? Image.network(
                        productImage,
                        fit: BoxFit.cover,
                      )
                    : null,
                title: Text(productName),
                subtitle: Text('¥ $productPrice / $productUnit'),
              ),
            ),
            Divider(height: 0.0),
            productDescription != ''
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      productDescription,
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
