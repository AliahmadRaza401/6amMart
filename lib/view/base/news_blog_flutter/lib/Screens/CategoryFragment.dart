import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/CategoryModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/NewsListScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/components/NoDataWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/shimmerScreen/CategoryShimmer.dart';

class CategoryFragment extends StatefulWidget {
  final bool? isTab;

  CategoryFragment({this.isTab});

  @override
  _CategoryFragmentState createState() => _CategoryFragmentState();
}

class _CategoryFragmentState extends State<CategoryFragment> with TickerProviderStateMixin {
  List<CategoryModel> categoryList = [];
  var scrollController = ScrollController();

  bool isLastPage = false;

  int page = 1;

  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    myBanner = buildBannerAd()..load();
    init();
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    fetchCategoryData(page: 1, perPageItem: perPageItemInCategory);
    scrollController.addListener(() {
      if (!isLastPage && (scrollController.position.pixels - 100 == scrollController.position.maxScrollExtent - 100)) {
        page++;
        appStore.setLoading(true);
        setState(() {});
        fetchCategoryData(page: page);
      }
    });
  }

  Future<void> init() async {
    if (allowPreFetched) {
      String res = getStringAsync(categoryData);
      if (res.isNotEmpty) {
        var categoryList = json.decode(res) as List<dynamic>;
        var list = categoryList.map((i) => CategoryModel.fromJson(i)).toList();

        setData(list);
      }
    }

    if (await isNetworkAvailable()) {
      fetchCategoryData(page: 1, perPageItem: perPageItemInCategory);
    }
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? bannerAdIdForAndroid : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(),
    );
  }

  Future<void> fetchCategoryData({int page = 1, int perPageItem = perPageItemInCategory}) async {
    await getCategories(page: page, perPage: perPageItem).then((res) async {
      if (!mounted) return;
      appStore.setLoading(false);

      if (page == 1) {
        categoryList.clear();
      }

      setData(res);
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);

      toast(error.toString());
      setState(() {});
    });
  }

  void setData(List<CategoryModel> res) {
    isLastPage = res.length != perPageCategory;
    categoryList.addAll(res);
    afterBuildCreated(() {
      appStore.setLoading(false);
    });
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: appBarWidget(
        appLocalization.translate('categories'),
        center: true,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: Observer(
        builder: (_) => Stack(
          children: [
            RefreshIndicator(
              onRefresh: () {
                return fetchCategoryData();
              },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                padding: EdgeInsets.only(bottom: 32),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: categoryList.map((e) {
                      return GestureDetector(
                        onTap: () {
                          NewsListScreen(title: e.name, id: e.cat_ID, categoryModel: e).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                        },
                        child: Container(
                          height: 120,
                          width: (context.width() / 2) - 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            color: context.cardColor,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            children: [
                              Hero(
                                tag: e,
                                child: cachedImage(e.image.validate(), height: 120, width: (context.width() / 2) - 12, fit: BoxFit.cover),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                    stops: [0.0, 1.0],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                right: 8,
                                child: Text(
                                  parseHtmlString(e.name.validate()),
                                  style: boldTextStyle(size: textSizeLargeMedium, color: Colors.white),
                                ).paddingAll(8),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            if (!appStore.isLoading && categoryList.isEmpty) NoDataWidget().center(),
            50.height,
            Align(alignment: Alignment.bottomCenter, child: Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).visible(appStore.isLoading && page != 1)),
            Observer(builder: (_) => CategoryShimmer().visible(appStore.isLoading && categoryList.isEmpty)),
          ],
        ),
      ),
      bottomNavigationBar: !isAdsDisabled && !widget.isTab!
          ? Container(
              height: AdSize.banner.height.toDouble(),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
            )
          : SizedBox(),
    );
  }
}
