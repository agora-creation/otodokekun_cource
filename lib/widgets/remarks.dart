import 'package:flutter/material.dart';

class RemarksWidget extends StatelessWidget {
  final String remarks;

  RemarksWidget({@required this.remarks});

  @override
  Widget build(BuildContext context) {
    return remarks != null && remarks != ''
        ? Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(remarks),
              ),
            ),
          )
        : Container();
  }
}
