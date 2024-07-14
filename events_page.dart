import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController? controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://socialjustice.gov.in/whats-new/1493"));
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}