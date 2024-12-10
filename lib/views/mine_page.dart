import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publiccomment/model/mine_cards.dart';

import '../common/colors.dart';
import '../model/login_user.dart';

import '../res/styles.dart';
import '../route/fluro_navigator.dart';
import '../route/routes.dart';
import '../utils/account_utils.dart';
import '../utils/repository_utils.dart';
import '../utils/utils.dart';
import '../widget/card_view.dart';
import '../widget/tool_bar.dart';
import '../widget/top_bottom_widget.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  late User mUser;
  List<Data> mCards = [];

  @override
  void initState() {
    super.initState();
    mUser = AccountUtils.getUser();
    getMineCards();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        onTabRightOne: () {
          settingClick();
        },
        text: '',
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(child: createMineHeader()),
          createMenuTab()
        ],
      ),
    );

  }

  void getMineCards() {
    Repository.loadAsset("mine_cards", fileDir: "me").then((json) {
      MineCards mineCards = MineCards.fromJson(Repository.toMap(json));
      mCards = mineCards.data;
      setState(() {});
    });
  }
  /// 我的页面头部
  Widget createMineHeader() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 47),
          color: color00CDA2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PaddingStyles.getPadding(17),
                  new ClipOval(
                    child: ExtendedImage.network(
                      mUser.avatarUrl,
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                    ),
                  ),
                  PaddingStyles.getPadding(13),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        mUser.userName,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "修改个人资料",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizeBoxFactory.getVerticalSizeBox(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  TopBottom(
                    top: Text(
                      "57",
                      style: TextStyles.get15White(),
                    ),
                    bottom: Text(
                      "动态",
                      style: TextStyle(fontSize: 12, color: Color(0x9EFFFFFF)),
                    ),
                    margin: 2,
                  ),
                  TopBottom(
                    top: Text(
                      "74",
                      style: TextStyles.get15White(),
                    ),
                    bottom: Text(
                      "关注",
                      style: TextStyle(fontSize: 12, color: Color(0x9EFFFFFF)),
                    ),
                    margin: 2,
                  ),
                  TopBottom(
                    top: Text(
                      "423",
                      style: TextStyles.get15White(),
                    ),
                    bottom: Text(
                      "粉丝",
                      style: TextStyle(fontSize: 12, color: Color(0x9EFFFFFF)),
                    ),
                    margin: 2,
                  )
                ],
              ),
            ],
          ),
        ),
        CardView(
          margin: EdgeInsets.only(left: 17, right: 17, top: 160),
          key: Key('unique_key'),
          onPressed: () {  },
          child: Padding(
            padding: EdgeInsets.only(top: 22, bottom: 22, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TopBottom(
                  top: Image.asset(
                    Utils.getImgPath("ic_me_order"),
                    width: 34,
                    height: 34,
                  ),
                  bottom: Text(
                    "订单",
                    style: TextStyles.get12Text_373D52(),
                  ),
                  margin: 5,
                ),
                TopBottom(
                  top: Image.asset(
                    Utils.getImgPath("ic_me_shopping_cart"),
                    width: 34,
                    height: 34,
                  ),
                  bottom: Text(
                    "购物车",
                    style: TextStyles.get12Text_373D52(),
                  ),
                  margin: 5,
                ),
                TopBottom(
                  top: Image.asset(
                    Utils.getImgPath("ic_me_ticket"),
                    width: 34,
                    height: 34,
                  ),
                  bottom: Text(
                    "优惠券",
                    style: TextStyles.get12Text_373D52(),
                  ),
                  margin: 5,
                ),
                TopBottom(
                  top: Image.asset(
                    Utils.getImgPath("ic_me_address"),
                    width: 34,
                    height: 34,
                  ),
                  bottom: Text(
                    "收货地址",
                    style: TextStyles.get12Text_373D52(),
                  ),
                  margin: 5,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  /// 分类
  Widget createMenuTab() {
    return SliverToBoxAdapter(
      child: Container(
        height: 176,
        child: CardView(
          margin: EdgeInsets.only(left: 17, right: 17, top: 14),
          key: Key('unique_key'),
          onPressed: () {  },
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), // 禁用GradView滚动事件
                itemCount: mCards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return createCard(mCards[index]);
                }),
          ),
        ),
      ),
    );
  }
  /// 菜单卡片
  Widget createCard(Data mCard) {
    return TopBottom(
      top: ExtendedImage.network(
        mCard.iconUrl,
        width: 22,
        height: 22,
      ),
      bottom: Text(
        mCard.name,
        style: TextStyles.get12Text_373D52(),
      ),
      margin: 6,
    );
  }

  void settingClick() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "是否确认退出登录?",
            style: TextStyles.get15Text_373D52(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // 清空登陆信息
                SpUtil.clear();
                // 关闭弹框
                Navigator.of(context).pop();
                // 打开登陆页面
                NavigatorUtils.push(context, Routes.login,
                    replace: true, clearStack: true);
              },
              child: Text(
                "确定",
                style: TextStyle(color: mainColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消", style: TextStyle(color: mainColor)),
            ),
          ],
        );
      },
    );
  }

}