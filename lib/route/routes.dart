/*
 * fluro
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:publiccomment/route/route_handlers.dart';



class Routes {
  /// 首页
  static String root = "/home";

  /// 登陆
  static String login = "/login";
  /// 忘记密码
  static String forgotPassword = "/forgot";
  /// 注册账号
  static String register = "/register";
  /// 网络协议
  static String privacy = "/privacy";
  /// WebView
  static String webView = "/browserweb";

  /// 壁纸
  static String wallPaper = "/wallPaper";


  static void configureRoutes(FluroRouter router) {
    router.define(root, handler: rootHandler);
    router.define(login, handler: loginHandler);
    router.define(forgotPassword, handler: forgotPasswordHandler);
    router.define(register, handler: registerHandler);
    router.define(privacy, handler: PrivacyNetworkHandler);
    router.define(webView, handler: webViewHandler);
    router.define(wallPaper, handler: wallPaperHandler);
  }

  /// 从顶部弹出动画
  static RouteTransitionsBuilder transitionTopToBottom() {
    return (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      /// x,y代表是的相对自己x轴移动一倍的自己 y轴移动2倍的自己
      const Offset begin = const Offset(0.0, -1.0);
      const Offset end = const Offset(0.0, 0.0);

      /// 相对自己移动的动画
      return SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: end,
        ).animate(animation),
        child: child,
      );
    };
  }
}
