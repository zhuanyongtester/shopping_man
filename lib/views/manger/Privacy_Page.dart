import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../route/fluro_navigator.dart';
import '../../route/routes.dart';  // 导入路由文件

class PrivacyNetWorkPage extends StatefulWidget {
  @override
  _PrivacyNetWorkPageState createState() => _PrivacyNetWorkPageState();
}

class _PrivacyNetWorkPageState extends State<PrivacyNetWorkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacy_agreement), // 网络协议标题
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 点击返回按钮销毁当前页面
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 网络协议内容
            Text(
              AppLocalizations.of(context)!.privacy_agreement_content,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            SizedBox(height: 20),
            // 添加协议内容的其他部分
            // ... (你可以继续填充更多协议的内容)

            SizedBox(height: 40),
            // OK 按钮
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 点击 OK 后返回登录界面并销毁当前页面
                  NavigatorUtils.push(context, Routes.login, replace: true);
                },
                child: Text(AppLocalizations.of(context)!.lg_privacy_agree),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 按钮颜色
                  minimumSize: Size(double.infinity, 50), // 按钮宽度
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
