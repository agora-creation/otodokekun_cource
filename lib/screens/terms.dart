import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
      ),
      body: WebView(
        initialUrl: 'https://agora-c.com/otodokekun/terms_use.html',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
