import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../common/colors.dart';
import '../../model/home_tools.dart';
import '../../res/styles.dart';
import '../../route/fluro_navigator.dart';
import '../../utils/browser_url.dart';
import '../../utils/toast_utils.dart';
import '../../utils/utils.dart';
import '../card_view.dart';
import '../round_button.dart';

/// 壁纸和减肥进度条组件
class HomeHeaderWidget extends StatelessWidget {
  final String wallImg;
  final double progressPercent;

  const HomeHeaderWidget({
    Key? key,
    required this.wallImg,
    this.progressPercent = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedImage.network(
          wallImg,
          height: 181,
          width: double.infinity,
          fit: BoxFit.cover,
          cache: true,
          enableLoadState: false,
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(
              height: 181,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          top: 104,
          left: 17,
          right: 17,
          child: CardView(
            key: Key('unique_key'),
            margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
            onPressed: () {  },
            child: Container(
              height: 156,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWeightInfo("初始(公斤)", "58.5", color373D52),
                  _buildCircularProgress(context),
                  _buildWeightInfo("目标(公斤)", "52.5", color00CDA2),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInfo(String title, String value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyles.get10TextA8ACBC()),
        Text(
          value,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 23,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularProgress(BuildContext context) {
    return CircularPercentIndicator(
      animation: true,
      radius: 95.0,
      lineWidth: 8.0,
      percent: progressPercent,
      animationDuration: 800,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: const Color(0xFFF5F6FA),
      progressColor: color00CDA2,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("已减去(公斤)", style: TextStyles.get10TextA8ACBC()),
          Text(
            "3.2",
            style: TextStyle(
              fontSize: 28,
              fontFamily: "Montserrat",
              color: color373D52,
            ),
          ),
        ],
      ),
    );
  }
}

/// 饮食运动记录组件
class DietSportRecordWidget extends StatelessWidget {
  final Data topCard;

  const DietSportRecordWidget({
    Key? key,
    required this.topCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardView(
      key: Key('unique_key'),
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
      onPressed: () {
        BrowserUrlManager.handleUrl(BrowserUrlManager.URL_CALORY).then((url) {
          NavigatorUtils.goBrowserPage(context, url!);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecordHeader(),
            const SizedBox(height: 16),
            _buildCalorieChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordHeader() {
    return Row(
      children: [
        Image.asset(
          Utils.getImgPath("ic_home_calorie"),
          height: 18,
          width: 18,
        ),
        const SizedBox(width: 6),
        Text(topCard.name, style: TextStyles.get14TextBold_373D52()),
      ],
    );
  }

  Widget _buildCalorieChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "还可以吃 ",
                style: TextStyles.get12TextA8ACBC(),
              ),
              TextSpan(
                text: "230",
                style: TextStyles.get15TextBold_373D52(),
              ),
              TextSpan(
                text: " 千卡",
                style: TextStyles.get12TextA8ACBC(),
              ),
            ],
          ),
        ),
        Container(
          width: 93,
          height: 60,
          child: Placeholder(), // 替代为具体的 BarChart 实现
        ),
      ],
    );
  }
}

// 其他小组件按照类似逻辑拆分和优化
/// 饮食运动记录
class WisdomWidget extends StatelessWidget {
  final Data topCard;

  WisdomWidget({required this.topCard});

  @override
  Widget build(BuildContext context) {
    return CardView(
      onPressed: () {
        BrowserUrlManager.handleUrl(BrowserUrlManager.getSmartAnalysisUrl())
            .then((url) {
          NavigatorUtils.goBrowserPage(context, url!);
        });
      },
      margin: EdgeInsets.only(left: 17, right: 17, top: 13),
      key: Key('unique_key'),
      child: Container(
        padding: EdgeInsets.only(
          top: 19,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    Utils.getImgPath("ic_home_dietician"),
                    height: 18,
                    width: 18,
                  ),
                  PaddingStyles.getPadding(6),
                  Text(
                    "饮食计划",
                    style: TextStyles.get14TextBold_373D52(),
                  )
                ],
              ),
            ),
            SizeBoxFactory.getVerticalSizeBox(22),
            Padding(
              padding: EdgeInsets.only(left: 39),
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(text: "晚餐: ", style: TextStyles.get12Text_373D52()),
                  TextSpan(
                      text: "米饭、番茄炒蛋、水煮鱼片",
                      style: TextStyles.get12TextA8ACBC()),
                ]),
              ),
            ),
            SizeBoxFactory.getVerticalSizeBox(22),
            Container(
              width: double.infinity,
              height: 39,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0x33FEC407),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Utils.getImgPath("ic_dietician_logo"),
                      width: 20,
                      height: 20,
                    ),
                    SizeBoxFactory.getHorizontalSizeBox(4),
                    Text(
                      "智慧营养师",
                      style: TextStyle(
                        fontSize: 14,
                        color: colorFEBB07,
                      ),
                    ),
                    Image.asset(
                      Utils.getImgPath("ic_arrow_light_yellow"),
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// 体重记录
class WeightRecordWidget extends StatelessWidget {
  final Data topCard;

  WeightRecordWidget({required this.topCard});

  @override
  Widget build(BuildContext context) {
    return CardView(
      onPressed: () {
        ToastUtils.showToast(context, topCard.name,duration: 0,gravity: ToastGravity.BOTTOM);
      },
      margin: EdgeInsets.only(left: 17, right: 17, top: 13),
      key: Key('unique_key'),
      child: Container(
        padding: EdgeInsets.only(top: 19, left: 15, right: 15, bottom: 19),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      Utils.getImgPath("ic_home_weight"),
                      height: 18,
                      width: 18,
                    ),
                    SizeBoxFactory.getHorizontalSizeBox(6),
                    Text(
                      topCard.name,
                      style: TextStyles.get14TextBold_373D52(),
                    )
                  ],
                ),

              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 7, right: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      PaddingStyles.getPadding(24),
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "58.9 ",
                              style: TextStyles.get15TextBold_373D52()),
                          TextSpan(
                              text: "公斤", style: TextStyles.get12TextA8ACBC()),
                        ]),
                      )
                    ],
                  ),
                  Container(
                    width: 93,
                    height: 41,

                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// 健康习惯
class HealthHabitsWidget extends StatelessWidget {
  final String iconUrl;
  final String title;

  HealthHabitsWidget({required this.iconUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return CardView(
      onPressed: () {
        ToastUtils.showToast(context, title,duration: 0,gravity: ToastGravity.BOTTOM);
      },
      margin: EdgeInsets.only(left: 17, right: 17, top: 13),
      key: Key('unique_key'),
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
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
                SizeBoxFactory.getHorizontalSizeBox(6),
                Text(
                  title,
                  style: TextStyles.get14TextBold_373D52(),
                )
              ],
            ),
            Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "今日完成: ", style: TextStyles.get11TextA8ACBC()),
                    TextSpan(text: "57%", style: TextStyles.get11Text_00CDA2()),
                  ]),
                ),
                Image.asset(
                  Utils.getImgPath("ic_arrow_grey"),
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