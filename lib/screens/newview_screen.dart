import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


// ignore: must_be_immutable
class NewsViewScreen extends StatefulWidget {

  String url;
  NewsViewScreen(this.url, {super.key});
  @override
  State<NewsViewScreen> createState() => _NewsViewScreenState();
}

class _NewsViewScreenState extends State<NewsViewScreen> {
  bool isLoading = true;
  String finalUrl="";
  final Completer<WebViewController> controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    setState(() {
      finalUrl = widget.url.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NEWS UPDATES"),
        centerTitle: true,
      ),
      body: Stack(
        children:  [
          WebView(
            initialUrl: finalUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish){
              setState(() {
                isLoading = false;
              });
            },
          ),
          //isLoading ? const Center(child: CircularProgressIndicator()) : Stack(),
          const Stack()
        ],
      ),
    );
  }
}