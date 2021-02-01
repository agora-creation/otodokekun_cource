import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CompanyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('運営会社'),
      ),
      body: WebView(
        initialUrl: 'https://agora-c.com/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
