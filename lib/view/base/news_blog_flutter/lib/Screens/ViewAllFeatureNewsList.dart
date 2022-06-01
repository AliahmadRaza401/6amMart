import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/NewsListDetailScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/NewsItemWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/shimmerScreen/NewsItemShimmer.dart';

class ViewAllFeatureNewsList extends StatefulWidget {
  final String? title;

  ViewAllFeatureNewsList({required this.title});

  @override
  State<ViewAllFeatureNewsList> createState() => _ViewAllFeatureNewsListState();
}

class _ViewAllFeatureNewsListState extends State<ViewAllFeatureNewsList> {
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int recentNumPages = 1;
  List<PostModel> recentNewsListing = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (recentNumPages > page) {
          page++;
          getFeaturePostList();
        }
      }
    });
  }

  Future<void> init() async {
    getFeaturePostList();
  }

  Future<void> getFeaturePostList() async {
    isLoading = true;
    setState(() {});

    await getDashboardApi(page).then((value) {
      if (page == 1) {
        recentNewsListing.clear();
      }
      recentNumPages = value.featureNumPages.validate();
      recentNewsListing.addAll(value.featurePost.validate());
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      isLoading = false;
     // setState(() {});
      log(e.toString());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: appBarWidget(
        parseHtmlString(widget.title),
        center: true,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 50),
            controller: _scrollController,
            itemCount: recentNewsListing.length,
            itemBuilder: (context, i) {
              return NewsItemWidget(recentNewsListing[i], data: recentNewsListing, index: i).onTap(() {
                NewsListDetailScreen(newsData: recentNewsListing, index: i).launch(context);
              });
            },
          ),
          if (page == 1 && isLoading) NewsItemShimmer(),
          if (page > 1 && isLoading) Positioned(left: 0, right: 0, bottom: 16, child: LoadingDotsWidget())
        ],
      ),
    );
  }
}
