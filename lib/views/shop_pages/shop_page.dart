import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../common/colors.dart';
import '../../model/ShopBanner.dart';
import '../../model/ShopRecommendList.dart';
import '../../res/styles.dart';
import '../../utils/repository_utils.dart';
import '../../widget/card_view.dart';
import '../../widget/common_search_bar.dart';

class ShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Banner_showcases> _bannerList = [];
  List<Categories> _categoriseList = [];
  List<Goods> _goodsList = [];
  double bannerHeight = 200;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  /// 加载数据
  void loadData() {
    /// 商店Banner
    Repository.loadAsset("shop_banner", fileDir: "shop").then((json) {
      _categoriseList.clear();
      ShopBanner data = ShopBanner.fromJson(Repository.toMap(json));
      _bannerList = data.bannerShowcases;
      // 保证数据最多为10条
      data.categories.forEach((it) {
        // 默认第一个分类
        if (data.categories.indexOf(it) < 10) {
          _categoriseList.add(it);
        }
      });
      // 计算Banner的高度
      double screenWidth = MediaQuery.of(context).size.width;
      if (_bannerList.length > 0) {
        bannerHeight = (screenWidth - 2 * 17) *
            (_bannerList[0].defaultPhotoHeight /
                _bannerList[0].defaultPhotoWidth);
      }
      _controller.finishRefresh();
      setState(() {});
    });

    /// 商店推荐商品
    Repository.loadAsset("shop_recommend_list", fileDir: "shop").then((json) {
      ShopRecommendList data =
      ShopRecommendList.fromJson(Repository.toMap(json));
      _goodsList.clear();
      _goodsList.addAll(data.goods);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: SearchBar(
        //   isShowCartIcon: true,
        //   text: "商店搜索",
        // ),
        body: EasyRefresh.custom(
          slivers: <Widget>[
            createBannerView(),
            createCategoryGridView(),
            createGoodsGridView(),
          ],
          header: MaterialHeader(
            valueColor: AlwaysStoppedAnimation(mainColor),
          ),
          taskIndependence: true,
          enableControlFinishRefresh: true,
          firstRefresh: true,
          controller: _controller,
          onRefresh: () async {
            loadData();
          },
        ));
  }

  Widget createBannerView() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            height: ScreenUtil.getScreenW(context) * (250 / 750 * 1.0).toDouble(),  // 设置banner的高度
            child: PageView.builder(
              itemCount: _bannerList.length,  // 设置轮播图数量
              controller: PageController(
                viewportFraction: 1.0,  // 控制图片显示的大小
              ),
              itemBuilder: (context, index) {
                return createBannerChildView(_bannerList[index]);  // 生成每个轮播项
              },
            ),
          ),
          // 创建指示器
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerList.length,  // 根据轮播图数量生成指示器
                    (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 8.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEFF3),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget createBannerChildView(Banner_showcases data) {
    return Container(
      margin: EdgeInsets.only(top: 13.0, left: 17, right: 17),
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
          ExtendedNetworkImageProvider(data.defaultPhotoUrl, cache: true),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
    );
  }

  // 分类
  Widget createCategoryGridView() {
    return SliverToBoxAdapter(
      child: Container(
        child: CardView(
          margin: EdgeInsets.only(left: 17, right: 17, top: 13),
          key: Key("qull"),
          onPressed: () {  },
          child: Padding(
            padding: EdgeInsets.only(top: 13, left: 10, right: 10),
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // 禁用GradView滚动事件
                itemCount: _categoriseList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (BuildContext context, int index) {
                  return getCategoryItemContainer(_categoriseList[index]);
                }),
          ),
        ),
      ),
    );
  }

  Widget getCategoryItemContainer(Categories item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ExtendedImage.network(
          item.iconUrl,
          width: 35,
          cache: true,
          height: 35,
        ),
        Text(
          item.name,
          style: TextStyle(fontSize: 12, color: color373D52),
        ),
      ],
    );
  }

  Widget createGoodsGridView() {
    return SliverPadding(
      padding: EdgeInsets.only(top: 13.0, bottom: 13, left: 17.0, right: 17),
      sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              childAspectRatio: 0.68),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return getGoodsItemContainer(_goodsList[index]);
            },
            childCount: _goodsList.length,
          )),
    );
  }

  Widget getGoodsItemContainer(Goods item) {
    return CardView(
      margin: EdgeInsets.all(0.0),
      key: Key("null"),
      onPressed: () {  },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                ExtendedNetworkImageProvider(item.bigPhotoUrl, cache: true),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 8),
                    child: Text(
                      item.title.split("｜")[0] ?? "",
                      style: TextStyle(fontSize: 13, color: color373D52),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 1),
                    child: Text(
                      item.title.split("｜").length > 1
                          ? item.title.split("｜")[1]
                          : "",
                      style: TextStyle(fontSize: 11, color: colorA8ACBC),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "¥" + item.basePrice.toString(),
                          style: TextStyle(fontSize: 11, color: colorFF6C65),
                        ),
                        SizeBoxFactory.getHorizontalSizeBox(8),
                        Text(
                          "¥" + item.marketPrice.toString(),
                          style: TextStyle(
                              fontSize: 11,
                              color: colorA8ACBC,
                              decoration: TextDecoration.lineThrough),
                        )
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}