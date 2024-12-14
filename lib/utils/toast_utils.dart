import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtils {
  static void showToast(BuildContext context, String msg,
      {required int duration, required ToastGravity gravity}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: duration == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: gravity, // 使用正确的类型
      timeInSecForIosWeb: duration == 0 ? 1 : 2, // 设置 iOS 上 Toast 持续时间
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
