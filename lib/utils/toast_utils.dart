import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ToastUtils {
  static void showToast(BuildContext context, String msg,
      {required int duration, required int gravity}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: duration == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: ToastGravity.values[gravity], // 根据传入的 gravity 值设置位置
      timeInSecForIosWeb: duration == 0 ? 1 : 2, // 设置 iOS 上 Toast 持续时间
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}