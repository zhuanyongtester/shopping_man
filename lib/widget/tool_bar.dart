
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../res/styles.dart';
import '../utils/utils.dart';

/// 通用的顶部标题栏
class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final GestureTapCallback onTabRightOne;  // 修改这里


  Toolbar({required this.text, required this.onTabRightOne});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color00CDA2,
      padding: EdgeInsets.only(
          left: 17,
          right: 17,
          top: ScreenUtil.getStatusBarH(context) + 17,
          bottom: 17),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: 11, bottom: 11),
            child: Text(text ?? "",
                style: TextStyle(fontSize: 14, color: Colors.white)),
          )),
          PaddingStyles.getPadding(14),
          InkWell(
            child: Image.asset(
              Utils.getImgPath("ic_settings_white"),
              width: 24,
              height: 24,
            ),
            onTap: onTabRightOne ?? () {},
          ),
          PaddingStyles.getPadding(14),
          Image.asset(
            Utils.getImgPath("ic_message_white"),
            width: 24,
            height: 24,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(200);
}