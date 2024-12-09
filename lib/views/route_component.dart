
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../route/application.dart';
import '../route/routes.dart';
import '../splash_page.dart';

class RouteComponent extends StatefulWidget {
  @override
  _RouteComponentState createState() => _RouteComponentState();
}

class _RouteComponentState extends State<RouteComponent> {
  _RouteComponentState() {
    final FluroRouter  router = new FluroRouter ();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: SplashPage(),
    );
  }
}