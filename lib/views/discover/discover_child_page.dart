
import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';

import '../../common/colors.dart';
import '../../model/discover/sub_discover.dart';
import '../../res/styles.dart';
import '../../utils/repository_utils.dart';
import '../../widget/top_bottom_widget.dart';

class DiscoverChildPage extends StatefulWidget {
  @override
  _DiscoverChildPageState createState() => _DiscoverChildPageState();
}

class _DiscoverChildPageState extends State<DiscoverChildPage> {
  EasyRefreshController _controller = EasyRefreshController();
  late SubDiscover _subDiscover = SubDiscover.empty();


  /// tab、列表集合合集
  var mList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 模拟的加载数据方
  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      slivers: <Widget>[
        createBannerView(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              Widget widget = Container(); // 给widget一个默认值

              if (mList[index] is List<Labels>) {
                var list = (mList[index] as List<Labels>);
                // 生成tab内容
                widget = createTabView(list);
              } else if (mList[index] is Sections) {
                // 生成列表内容
                widget = createListChild(mList[index] as Sections);
              }
              return widget; // 返回最终的widget
            },
            childCount: mList.length,
          ),
        ),
      ],
      header: MaterialHeader(
        valueColor: AlwaysStoppedAnimation(mainColor),
      ),
      controller: _controller,
      onRefresh: () async {
        loadData();
        _controller.finishRefresh();
        setState(() {});
      },
    );
  }
  Widget createBannerView() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            height: ScreenUtil.getScreenW(context) * (250 / 750 * 1.0).toDouble(),
            child: PageView.builder(
              itemCount: _subDiscover.banners.length,
              controller: PageController(
                viewportFraction: 1.0,  // 控制图片显示的大小
              ),
              itemBuilder: (context, index) {
                return createBannerChildView(_subDiscover.banners[index]);
              },
            ),
          ),
          createIndicator(),
        ],
      ),
    );
  }

  Widget createBannerChildView(Banners data) {
    return Container(
      margin: EdgeInsets.only(top: 13.0, left: 17, right: 17),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(data.picUrl, cache: true),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  Widget createIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _subDiscover.banners.map((bean) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 8.0,
          height: 5.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        );
      }).toList(),
    );
  }

  /// 发现页数据 banner、tab、列表数据
  void loadData() {
    Repository.loadAsset("discover_sub", fileDir: "discover").then((response) {
      _subDiscover = SubDiscover.fromJson(Repository.toMap(response));
      mList.clear();
      mList.add(_subDiscover.labels);
      mList.addAll(_subDiscover.sections);
      setState(() {});
    });
  }



  /// Tab
  Widget createTabView(List<Labels> list) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // 禁用GradView滚动事件
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 2.2),
          itemBuilder: (BuildContext context, int index) {
            return TopBottom(
              margin: 5,
              top: ExtendedImage.network(
                list[index].picUrl,
                enableLoadState: false,
                height: 34,
                width: 34,
              ),
              bottom: Text(
                list[index].title,
                style: TextStyles.get12Text_373D52(),
              ),
            );
          }),
    );
  }

  /// 列表
  Widget createListChild(Sections sections) {
    return Container(
      height: 172,
      margin: EdgeInsets.only(top: 33),
      padding: EdgeInsets.only(left: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sections.name,
            style: TextStyles.get15TextBold_373D52(),
          ),
          _getHorizontalListView(sections.subContents)
        ],
      ),
    );
  }

  /// 横向列表
  Widget _getHorizontalListView(List<Sub_contents> subContents) {
    var horizontalList = ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 11, top: 14, bottom: 10),
                height: 92,
                width: 144,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExtendedNetworkImageProvider(
                        subContents[index].imgUrl,
                        cache: true),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
              ),
              Text(
                subContents[index].title,
                style: TextStyle(fontSize: 13, color: color373D52),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizeBoxFactory.getVerticalSizeBox(1),
              Text(
                subContents[index].subTitle,
                style: TextStyle(fontSize: 11, color: colorA8ACBC),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          );
        },
        itemCount: subContents.length);

    return Expanded(
        child: Container(width: double.infinity, child: horizontalList));
  }
}
