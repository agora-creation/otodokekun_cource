import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPouringHourglass(
        color: kMainColor,
        size: 30.0,
      ),
    );
  }
}
