import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../widget/md2_tab_indicator.dart';
import 'discover/discover_child_page.dart';

class DiscoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var mTabs = ["发现", "精选", "好友圈"];
  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: mTabs.length, vsync: this);
    _tabController.addListener(() {
      switch (_tabController.index) {
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // 设置 AppBar 的高度
        child: SearchBar(
          hintText: "搜索动态、文章、话题、用户",
        ),
      ),
      body: DefaultTabController(
        length: mTabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TabBar(
              controller: _tabController,
              labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: mainColor,
              unselectedLabelColor: color373D52,
              isScrollable: true,
              indicator: MD2Indicator(
                indicatorHeight: 5,
                indicatorColor: mainColor,
                indicatorSize: MD2IndicatorSize.tiny,
              ),
              tabs: mTabs.map((e) => Tab(text: e)).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  DiscoverChildPage(),
                  Center(child: Text('精选')),
                  Center(child: Text('好友圈')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}