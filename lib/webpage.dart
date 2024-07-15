// ignore_for_file: unnecessary_import

import 'package:chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webpage extends StatefulWidget {
  const Webpage({super.key});

  @override
  State<Webpage> createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {
  late final WebViewController controller;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          setState(() {
            isloading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse('https://nabulsi.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          // ignore: unnecessary_const
          body:  isloading
              ? const Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Expanded(
                        child: WebViewWidget(
                      controller: controller,
                    ))
                  ]),
                ),
        );
      },
    );
  }
}
