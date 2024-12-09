import 'package:flutter/cupertino.dart';

class WallPaperPage extends StatefulWidget {
  final String wallPaperImageUrl;

  WallPaperPage({required this.wallPaperImageUrl});

  @override
  _WallPaperPageState createState() => _WallPaperPageState(wallPaperImageUrl);
}

class _WallPaperPageState extends State<WallPaperPage>{
  _WallPaperPageState(String wallPaperImageUrl
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}