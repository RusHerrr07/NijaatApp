import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController? controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://socialjustice.gov.in/common/1236"));
    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}