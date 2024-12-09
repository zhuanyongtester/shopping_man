import 'package:flutter/cupertino.dart';

class BrowserPage extends StatefulWidget {
  final String webViewUrl;

  BrowserPage( {required this.webViewUrl});

  @override
  _BrowserPageState createState() => _BrowserPageState(webViewUrl);
}

class _BrowserPageState extends State<BrowserPage>{
  _BrowserPageState(String webViewUrl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}