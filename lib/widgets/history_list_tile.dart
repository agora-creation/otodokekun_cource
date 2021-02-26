import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/cart.dart';

class HistoryListTile extends StatelessWidget {
  final List<CartModel> cart;
  final String deliveryAt;
  final bool shipping;
  final Function onTap;

  HistoryListTile({
    this.cart,
    this.deliveryAt,
    this.shipping,
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
            border: Border.all(color: kSubColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            leading: cart[0].image != ''
                ? Image.network(
                    cart[0].image,
                    fit: BoxFit.cover,
                  )
                : null,
            title: cart.length > 1
                ? Text('${cart[0].name} 他')
                : Text('${cart[0].name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('お届け日 : $deliveryAt'),
                shipping
                    ? Text(
                        '配達完了',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text(
                        '配達待ち',
                        style: TextStyle(color: Colors.redAccent),
                      ),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
            contentPadding: EdgeInsets.all(8.0),
          ),
        ),
      ),
    );
  }
}
