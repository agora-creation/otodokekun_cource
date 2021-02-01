import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TokushohoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('特定商取引法に関する方針'),
      ),
      body: WebView(
        initialUrl: 'https://agora-c.com/otodokekun/tokushoho.html',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
