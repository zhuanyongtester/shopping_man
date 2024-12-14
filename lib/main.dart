import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:publiccomment/route/application.dart';
import 'package:publiccomment/splash_page.dart';
import 'package:publiccomment/views/main_page.dart';
import 'package:publiccomment/views/route_component.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'autosize/auto_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize the binding
  // runAutoSizeApp(RouteComponent(),width: 375, height: 600);

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
