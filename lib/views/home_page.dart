import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../common/colors.dart';
import '../common/constant.dart';
import '../model/home_tools.dart';
import '../model/home_wall_paper.dart';
import '../res/styles.dart';
import '../route/fluro_navigator.dart';
import '../utils/repository_utils.dart';
import '../utils/toast_utils.dart';
import '../widget/card_view.dart';
import '../widget/common_search_bar.dart';
import '../widget/header/home_wallpaper_header.dart';
import '../widget/home_common_card.dart';
import '../widget/main/main_widgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 控制顶部搜索框的颜色
  SearchBarController _searchBarController = SearchBarController(
    alpha: 0,
    searchBarBg: Color(0x1FFFFFFF),
    appbarTitleColor: colorA8ACBC,
    appbarLeftIcon: "ic_search_grey",
    appbarRightIcon: "ic_message_grey",
  );

  /// 是否需要设置渐变色
  bool _isNeedSetAlpha = false;

  /// 用于单独控制搜索框的状态
  GlobalKey<SearchBarState> _mTitleKey = GlobalKey();

  /// 顶部卡片
  List<Data> topCards = [];
  List<Data> bottomCards = [];
  List<String> topCardItems = [
    HomeCard.DIET_SPORT_RECORD,
    HomeCard.WISDOM,
    HomeCard.HEALTH_HABITS,
    HomeCard.WEIGHT_RECORD,
  ];

  /// 滑动监听
  ScrollController _controller = ScrollController();
  double percent = 0.0;
  HomeWallPaper? wallPaper;

  @override
  void initState() {
    super.initState();
    loadData();
    // 监听滚动事件，调整搜索框样式
    _controller.addListener(() {
      if (_controller.offset < 0) {
        return;
      }
      if (_controller.offset < 100) {
        _isNeedSetAlpha = true;
        double alpha = _controller.offset / 100;
        _searchBarController.value.alpha = (255 * alpha).toInt();
        _mTitleKey.currentState?.setState(() {});
      } else if (_isNeedSetAlpha) {
        _searchBarController.value.alpha = 255;
        _isNeedSetAlpha = false;
        _mTitleKey.currentState?.setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          EasyRefresh.custom(
            header: WallPaperHeader(
              wallPaperUrl: wallPaper?.welcomeImg?.backImg ?? "",
              key: Key(""),
            ),
            scrollController: _controller,
            onRefresh: () async {
              NavigatorUtils.goWallPaper(
                  context, wallPaper?.welcomeImg?.backImg ?? "");
            },
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: HomeHeaderWidget(
                  wallImg: wallPaper?.welcomeImg?.backImg ?? "",
                  progressPercent: percent,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    // Initialize widget with a default value
                    Widget widget = Container(); // Default value (empty container)

                    if (topCards[index].code == HomeCard.DIET_SPORT_RECORD) {
                      widget = DietSportRecordWidget(topCard: topCards[index]);
                    } else if (topCards[index].code == HomeCard.WISDOM) {
                      widget = WisdomWidget(topCard: topCards[index]);
                    } else if (topCards[index].code == HomeCard.WEIGHT_RECORD) {
                      widget = WeightRecordWidget(topCard: topCards[index]);
                    } else if (topCards[index].code == HomeCard.HEALTH_HABITS) {
                      widget = HealthHabitsWidget(
                        iconUrl: "ic_home_habit",
                        title: "健康习惯",
                      );
                    }
                    return widget;
                  },
                  childCount: topCards.length,
                ),
              ),
              createToolsCards(),
            ],
          ),
          Positioned(
            top: 0, // 放置位置
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white, // 搜索框背景颜色
              child: Row(
                children: [
                  Expanded(
                      child:TextField(
                        decoration: InputDecoration(
                          hintText: "搜索食物和热量",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          )
                        ),
                        enabled: true,

                      )
                  )
                ],
              ),

            ),
          )
        ],
      ),
    );
  }


  /// 加载数据
  void loadData() {
    Repository.loadAsset("home_health_tools", fileDir: "home").then((json) {
      HomeTools homeTools = HomeTools.fromJson(Repository.toMap(json));
      topCards = homeTools.data
          .where((item) => item.visible && topCardItems.contains(item.code))
          .toList();
      bottomCards = homeTools.data
          .where((item) => item.visible && !topCardItems.contains(item.code))
          .toList();
      setState(() {});
    });
    Repository.loadAsset("home_wallpaper", fileDir: "home").then((json) {
      wallPaper = HomeWallPaper.fromJson(Repository.toMapForList(json));
      setState(() {});
    });
    // 设置体重记录圆环动画
    Future.delayed(Duration(seconds: 3), () {
      percent = 0.8;
      setState(() {});
    });
  }

  /// 构建顶部卡片
  Widget buildTopCardWidget(int index) {
    final card = topCards[index];
    switch (card.code) {
      case HomeCard.DIET_SPORT_RECORD:
        return DietSportRecordWidget(topCard: card);
      case HomeCard.WISDOM:
        return WisdomWidget(topCard: card);
      case HomeCard.WEIGHT_RECORD:
        return WeightRecordWidget(topCard: card);
      case HomeCard.HEALTH_HABITS:
        return HealthHabitsWidget(iconUrl: "ic_home_habit", title: "健康习惯");
      default:
        return SizedBox();
    }
  }

  /// 底部健康工具列表
  Widget createToolsCards() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 13, bottom: 30),
        child: CardView(
          margin: EdgeInsets.symmetric(horizontal: 17),
          key: Key('unique_key'),
          onPressed: () {  },
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final card = bottomCards[index];
              return CommonCard(
                onPressed: () {
                  ToastUtils.showToast(context, card.name,duration: 0,gravity: 2);
                },
                title: card.name,
                iconUrl: "ic_home_${card.code.toLowerCase()}", subWidget: SizedBox.shrink(),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 0,
                thickness: 1,
                color: colorEEEFF3,
                indent: 16,
                endIndent: 16,
              );
            },
            itemCount: bottomCards.length,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchBarController.dispose();
    super.dispose();
  }
}
