import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プライバシーポリシー'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.loadUrl(
                  'https://www.agora-c.com/otodokekun/privacy_policy.html');
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'https://www.agora-c.com/otodokekun/privacy_policy.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
