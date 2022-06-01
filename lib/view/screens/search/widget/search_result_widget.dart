import 'package:sixam_mart/controller/search_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/search/widget/filter_widget.dart';
import 'package:sixam_mart/view/screens/search/widget/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  SearchResultWidget({@required this.searchText});

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      GetBuilder<SearchController>(builder: (searchController) {
        bool _isNull = true;
        int _length = 0;
        if(searchController.isStore) {
          _isNull = searchController.searchStoreList == null;
          if(!_isNull) {
            _length = searchController.searchStoreList.length;
          }
        }else {
          _isNull = searchController.searchItemList == null;
          if(!_isNull) {
            _length = searchController.searchItemList.length;
          }
        }
        return _isNull ? SizedBox() : Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Row(children: [
            Text(
              _length.toString(),
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Expanded(child: Text(
              'results_found'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
            )),
            widget.searchText.isNotEmpty ? InkWell(
              onTap: () {
                List<double> _prices = [];
                if(!Get.find<SearchController>().isStore) {
                  Get.find<SearchController>().allItemList.forEach((product) => _prices.add(product.price));
                  _prices.sort();
                }
                double _maxValue = _prices.length > 0 ? _prices[_prices.length-1] : 1000;
                Get.dialog(FilterWidget(maxValue: _maxValue, isStore: Get.find<SearchController>().isStore));
              },
              child: Icon(Icons.filter_list),
            ) : SizedBox(),
          ]),
        )));
      }),

      Center(child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        color: Theme.of(context).cardColor,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          tabs: [
            Tab(text: 'item'.tr),
            Tab(text: Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                ? 'restaurants'.tr : 'stores'.tr),
          ],
        ),
      )),

      Expanded(child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            Get.find<SearchController>().setStore(_tabController.index == 1);
            Get.find<SearchController>().searchData(widget.searchText, false);
          }
          return false;
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            ItemView(isItem: false),
            ItemView(isItem: true),
          ],
        ),
      )),

    ]);
  }
}
