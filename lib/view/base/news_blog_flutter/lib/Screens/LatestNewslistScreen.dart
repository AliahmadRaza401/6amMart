import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/NewsListDetailScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/NewsItemWidget.dart';
import 'package:news_flutter/shimmerScreen/NewsItemShimmer.dart';

import '../main.dart';

class LatestNewsListScreen extends StatefulWidget {
  final String? title;

  LatestNewsListScreen({this.title});

  @override
  LatestNewsListScreenState createState() => LatestNewsListScreenState();
}

class LatestNewsListScreenState extends State<LatestNewsListScreen> {
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int recentNumPages = 1;
  List<PostModel> recentNewsListing = [];
  bool isLoading = false;

  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    init();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (recentNumPages > page) {
          page++;
          fetchLatestData();
        }
      }
    });
  }

  init() async {
    myBanner = buildBannerAd()..load();

    fetchLatestData();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? bannerAdIdForAndroid : BannerAd.testAdUnitId,
      size: AdSize.largeBanner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(),
    );
  }

  Future<void> fetchLatestData() async {
    afterBuildCreated(() => appStore.setLoading(true));
    await getDashboardApi(page).then((value) async {
      if (page == 1) {
        recentNewsListing.clear();
      }
      recentNumPages = value.recentNumPages.validate();
      recentNewsListing.addAll(value.recentPost.validate());
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    myBanner!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        parseHtmlString(widget.title),
        center: true,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 50),
                  controller: _scrollController,
                  itemCount: recentNewsListing.length,
                  itemBuilder: (context, i) {
                    return AnimationConfiguration.staggeredList(
                      position: i,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 44.0,
                        child: FadeInAnimation(
                          child: NewsItemWidget(recentNewsListing[i], data: recentNewsListing, index: i).onTap(() {
                            NewsListDetailScreen(newsData: recentNewsListing, index: i).launch(context);
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (page == 1 && appStore.isLoading) NewsItemShimmer(),
              if (page > 1 && appStore.isLoading) Positioned(left: 0, right: 0, bottom: 16, child: LoadingDotsWidget())
            ],
          );
        },
      ),
    );
  }
}
