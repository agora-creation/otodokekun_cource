import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プライバシーポリシー'),
      ),
      body: WebView(
        initialUrl: 'https://agora-c.com/otodokekun/privacy_policy.html',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
