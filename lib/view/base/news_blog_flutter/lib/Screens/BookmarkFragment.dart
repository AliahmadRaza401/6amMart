import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/BookmarkNewsResponse.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/NewsItemWidget.dart';
import 'package:news_flutter/components/NoDataWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/shimmerScreen/NewsItemShimmer.dart';

class BookmarkFragment extends StatefulWidget {
  final bool? isTab;

  BookmarkFragment({this.isTab});

  @override
  BookmarkFragmentState createState() => BookmarkFragmentState();
}

class BookmarkFragmentState extends State<BookmarkFragment> {
  List<PostModel> bookMarkListing = [];
  ScrollController scrollController = ScrollController();

  bool isLoadAds = false;
  bool isLastPage = false;
  int page = 1;
  int numPages = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });

    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (numPages > page) {
          page++;
          appStore.setLoading(true);

          setState(() {});
          getWishListData();
        }
      }
    });
  }

  init() async {
    getWishListData();

    if (allowPreFetched) {
      String res = getStringAsync(bookmarkData);

      if (res.isNotEmpty) {
        setData(BookmarkNewsResponse.fromJson(jsonDecode(res)));
      }
    }
  }

  Future<void> getWishListData() async {
    appStore.setLoading(true);
    //  isLoading = true;
    // setState(() {});

    await getWishList({}, page).then((res) async {
      await removeKey(bookmarkData);
      await setValue(bookmarkData, jsonEncode(res));
      setData(res);
      appStore.setLoading(false);
      /*isLoading = false;
      setState(() {});*/
    }).catchError((error) {
      appStore.setLoading(false);
      //isLoading = false;
      log(error.toString());
      setState(() {});
    });
  }

  void setData(BookmarkNewsResponse res) {
    afterBuildCreated(() {
      appStore.setLoading(false);
    });

    if (page == 1) numPages = res.num_pages.validate();

    bookMarkListing.clear();
    bookMarkListing.addAll(res.posts!);

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
      body: Observer(
        builder: (_) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: context.statusBarHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalization.translate('WishList'), style: boldTextStyle(size: 24)).paddingOnly(left: 16, top: 16, right: 16),
                    if (bookmarkStore.mBookmark.isNotEmpty)
                      ListView.builder(
                        itemCount: bookmarkStore.mBookmark.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          PostModel post = bookmarkStore.mBookmark[i];

                          return NewsItemWidget(post, data: bookmarkStore.mBookmark, index: i);
                        },
                      ).paddingOnly(top: 8.0, bottom: 16.0),
                  ],
                ),
              ),
              if (!appStore.isLoading && bookmarkStore.mBookmark.isEmpty) NoDataWidget(),
              if (appStore.isLoading && page == 1 && bookmarkStore.mBookmark.isEmpty) NewsItemShimmer(),
              if (appStore.isLoading) LoadingDotsWidget(),
            ],
          );
        },
      ),
    );
  }
}
