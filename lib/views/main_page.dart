import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:publiccomment/views/shop_pages/shop_page.dart';

import '../common/colors.dart';
import '../utils/toast_utils.dart';
import 'discover_page.dart';
import 'home_page.dart';
import 'mine_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<StatefulWidget> with SingleTickerProviderStateMixin {
  late DateTime _lastPressedAt;
  int _selectedIndex = 0;
  List<Widget> _list = []; // 可变长度的 List
  final List<Widget> _selectIcon = [
    Image.asset("images/ic_tab_bar_home_green.png", width: 22, height: 22),
    Image.asset("images/ic_tab_bar_partner_green.png", width: 22, height: 22),
    Image.asset("images/ic_home_tabbar_plus.png", width: 36, height: 36),
    Image.asset("images/ic_tab_bar_shop_green.png", width: 22, height: 22),
    Image.asset("images/ic_tab_bar_me_green.png", width: 22, height: 22),
  ];
  final List<Widget> _unselectIcon = [
    Image.asset("images/ic_tab_bar_home_grey.png", width: 22, height: 22),
    Image.asset("images/ic_tab_bar_partner_grey.png", width: 22, height: 22),
    Image.asset("images/ic_home_tabbar_plus.png", width: 36, height: 36),
    Image.asset("images/ic_tab_bar_shop_grey.png", width: 22, height: 22),
    Image.asset("images/ic_tab_bar_me_grey.png", width: 22, height: 22),
  ];
  static List<String> tabData = [
    "首页",
    "伙伴",
    "",
    "商店",
    "我",
  ];
  List<BottomNavigationBarItem> _myTabs = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < tabData.length; i++) {
      _myTabs.add(BottomNavigationBarItem(
        icon: _unselectIcon[i],
        activeIcon: _selectIcon[i],
        label: tabData[i],
      ));
    }
    _list
      ..add(HomePage())
      ..add(DiscoverPage())
      ..add(ShopPage())
      ..add(MinePage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex > 2 ? _selectedIndex - 1 : _selectedIndex,
          children: _list,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 10,
          unselectedFontSize: 10,
          backgroundColor: Colors.white,
          items: _myTabs,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          fixedColor: mainColor,
        ),
      ),
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          ToastUtils.showToast(context, "再按一次返回退出APP", duration: 0, gravity: ToastGravity.BOTTOM);
          return false;
        }
        return true;
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      ToastUtils.showToast(context, "暂无", duration: 0, gravity: ToastGravity.BOTTOM);
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}