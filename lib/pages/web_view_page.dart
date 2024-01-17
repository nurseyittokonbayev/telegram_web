import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;
  bool isAppOpened = false;

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
          onConsoleMessage: (controller, consoleMessage) {
            // Handle JavaScript console messages here
            log('JS Console: ${consoleMessage.message}', name: 'Flutter_log');
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

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('my_id', 'my_channel_name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            icon: '@mipmap/ic_launcher');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin().show(
      0,
      'Входящий звонок',
      'Кто-то звонит вам',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
