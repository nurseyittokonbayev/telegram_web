import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.audio,
    ].request();
  }

  Future<PermissionResponse?> handlePermissionRequest(
      InAppWebViewController controller, PermissionRequest request) async {
    var resources = request.resources;

    var response = PermissionResponse(
      resources: resources,
      action: PermissionResponseAction.GRANT,
    );

    return response;
  }

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
          onPermissionRequest: handlePermissionRequest,
        ),
      ),
    );
  }

  Future<void> runJsCode() async {
    await webViewController?.injectJavascriptFileFromAsset(
      assetFilePath: 'assets/js/auto.js',
    );
  }
}
