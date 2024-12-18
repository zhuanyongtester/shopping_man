import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:publiccomment/views/manger/ForgotPassword_page.dart';
import 'package:publiccomment/views/manger/Privacy_Page.dart';
import 'package:publiccomment/views/manger/Register_page.dart';

import '../views/common/browser_page.dart';
import '../views/common/wallpaper_page.dart';
import '../views/login/login_page.dart';
import '../views/main_page.dart';

// 根页面路由
var rootHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return MainPage();
  },
);

// 登录页面路由
var loginHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return LoginPage();
  },
);
// 忘记密码
var forgotPasswordHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return ForgotPassWordPage();
  },
);
// 注册账号
var registerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return RegisterPage();
  },
);
// 网络协议
var PrivacyNetworkHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return PrivacyNetWorkPage();
  },
);

// WebView 页面路由
var webViewHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    final String? param = params["web_url"]?.first;
    if (param == null) {
      return Scaffold(body: Center(child: Text('Missing web_url parameter')));
    }
    return BrowserPage(webViewUrl: param);
  },
);

// 壁纸页面路由
var wallPaperHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    final String? param = params["image_url"]?.first;
    if (param == null) {
      return Scaffold(body: Center(child: Text('Missing image_url parameter')));
    }
    return WallPaperPage(wallPaperImageUrl: param);
  },
);
