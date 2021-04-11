import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('運営会社'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.loadUrl('https://www.agora-c.com/');
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'https://www.agora-c.com/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
