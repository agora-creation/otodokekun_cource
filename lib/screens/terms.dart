import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatefulWidget {
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller
                  .loadUrl('https://www.agora-c.com/otodokekun/terms_use.html');
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'https://www.agora-c.com/otodokekun/terms_use.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
