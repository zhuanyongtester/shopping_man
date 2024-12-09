
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/styles.dart';
import '../utils/utils.dart';

/// 首页通用卡片样式
class CommonCard extends StatelessWidget {
  final String iconUrl;
  final String title;
  final Widget subWidget;
  final GestureTapCallback onPressed; // 修改这里

  CommonCard({
    required this.onPressed,
    required this.iconUrl,
    required this.title,
    required this.subWidget,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(top: 19, bottom: 19),
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  Utils.getImgPath(iconUrl),
                  height: 18,
                  width: 18,
                ),
                PaddingStyles.getPadding(6),
                Text(
                  title,
                  style: TextStyles.get14TextBold_373D52(),
                )
              ],
            ),
            Row(
              children: <Widget>[
                subWidget == null ? Text("") : subWidget,
                Image.asset(
                  Utils.getImgPath(
                    "ic_arrow_grey",
                  ),
                  height: 18,
                  width: 18,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
