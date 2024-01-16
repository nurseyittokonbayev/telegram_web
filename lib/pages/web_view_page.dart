import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri("https://web.telegram.org/a/"),
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            await Future.delayed(const Duration(seconds: 2));
            await runJsCode();
          },
        ),
      ),
    );
  }

  Future<void> runJsCode() async {
    await webViewController?.injectJavascriptFileFromAsset(
        assetFilePath: 'assets/js/auto.js');
  }
}
