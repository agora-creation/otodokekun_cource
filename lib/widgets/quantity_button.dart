import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class QuantityButton extends StatelessWidget {
  final String unit;
  final int quantity;
  final Function removeOnPressed;
  final Function addOnPressed;

  QuantityButton({
    this.unit,
    this.quantity,
    this.removeOnPressed,
    this.addOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        removeOnPressed != null
            ? FlatButton(
                onPressed: removeOnPressed,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Icon(Icons.remove, color: Colors.redAccent),
              )
            : Container(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '数量 : ',
                style: TextStyle(
                  fontSize: 14.0,
                  color: kMainColor,
                ),
              ),
              TextSpan(
                text: '$quantity',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: kMainColor,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontSize: 14.0,
                  color: kMainColor,
                ),
              ),
            ],
          ),
        ),
        addOnPressed != null
            ? FlatButton(
                onPressed: addOnPressed,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.blueAccent,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Icon(Icons.add, color: Colors.blueAccent),
              )
            : Container(),
      ],
    );
  }
}
