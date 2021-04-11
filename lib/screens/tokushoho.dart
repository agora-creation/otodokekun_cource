import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TokushohoScreen extends StatefulWidget {
  @override
  _TokushohoScreenState createState() => _TokushohoScreenState();
}

class _TokushohoScreenState extends State<TokushohoScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('特定商取引法に関する方針'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller
                  .loadUrl('https://www.agora-c.com/otodokekun/tokushoho.html');
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'https://www.agora-c.com/otodokekun/tokushoho.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
