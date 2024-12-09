import 'package:flutter/material.dart';

import '../common/colors.dart';

/// 通用的圆角button按钮
class RoundButton extends StatelessWidget {
  final Color backgroundColor;
  final Text buttonText;
  final VoidCallback onPressed; // 修改这里为 VoidCallback
  final String text;
  final EdgeInsetsGeometry padding;
  final double radius;

  RoundButton({
    required this.backgroundColor,
    required this.buttonText,
    required this.onPressed,
    required this.padding,
    this.radius = 20,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: padding ?? EdgeInsets.only(left: 7, right: 7, top: 4, bottom: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        backgroundColor: backgroundColor ?? color00CDA2,
      ),
      onPressed: onPressed, // 这里就直接使用 onPressed 了
      child: buttonText ??
          Text(
            text,
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
    );
  }
}
