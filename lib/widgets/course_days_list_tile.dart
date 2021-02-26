import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class CourseDaysListTile extends StatelessWidget {
  final String deliveryAt;
  final String name;
  final String image;

  CourseDaysListTile({
    this.deliveryAt,
    this.name,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kSubColor.withOpacity(0.3),
        ),
        child: Center(child: Text(deliveryAt)),
      ),
      title: ListTile(
        leading: image != ''
            ? Image.network(
                image,
                fit: BoxFit.cover,
              )
            : null,
        title: name != '' ? Text(name) : Container(),
      ),
      contentPadding: EdgeInsets.all(8.0),
    );
  }
}
