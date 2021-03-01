import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class AddressWidget extends StatelessWidget {
  final String zip;
  final String address;
  final String tel;
  final Function onTap;

  AddressWidget({
    this.zip,
    this.address,
    this.tel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.edit, color: kSubColor),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('〒$zip', style: TextStyle(color: kMainColor)),
                  Text(address, style: TextStyle(color: kMainColor)),
                  Text(tel, style: TextStyle(color: kMainColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
