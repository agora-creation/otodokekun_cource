import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class AddressListTile extends StatelessWidget {
  final String zip;
  final String address;
  final String tel;
  final Function onTap;

  AddressListTile({
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
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('〒$zip', style: TextStyle(color: kMainColor)),
                  Text(address, style: TextStyle(color: kMainColor)),
                  Text(tel, style: TextStyle(color: kMainColor)),
                ],
              ),
              Icon(Icons.edit, color: kSubColor),
            ],
          ),
        ),
      ),
    );
  }
}
