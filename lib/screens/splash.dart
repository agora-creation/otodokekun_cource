import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/widgets/loading.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'お届けくん',
                  style: kTitleTextStyle,
                ),
                SizedBox(height: 8.0),
                Text('期間配達サービス'),
                SizedBox(height: 24.0),
                LoadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
