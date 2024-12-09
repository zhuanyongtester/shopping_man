import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publiccomment/splash_page.dart';
import 'package:publiccomment/views/main_page.dart';
import 'package:publiccomment/views/route_component.dart';

import 'autosize/auto_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize the binding
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RouteComponent(), // Your main route
    );
  }
}
