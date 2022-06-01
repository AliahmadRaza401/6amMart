import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Utils/constant.dart';

import '../Network/rest_apis.dart';
import '../Utils/Colors.dart';
import '../components/NewsDetails/NewsDetailPageVariantFirstWidget.dart';
import '../components/NewsDetails/NewsDetailPageVariantSecondWidget.dart';
import '../components/NewsDetails/NewsDetailPageVariantThirdWidget.dart';
import '../main.dart';

class NewsListDetailScreen extends StatefulWidget {
  final List<PostModel>? newsData;
  final int index;

  NewsListDetailScreen({this.newsData, this.index = 0});

  @override
  NewsListDetailScreenState createState() => NewsListDetailScreenState();
}

class NewsListDetailScreenState extends State<NewsListDetailScreen> {
  late PageController pageController;
  String postContent = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    pageController = PageController(initialPage: widget.index);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String setDetails(PostModel res) {
    return res.postContent
        .validate()
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('[embed]', '<embed>')
        .replaceAll('[/embed]', '</embed>')
        .replaceAll('[caption]', '<caption>')
        .replaceAll('[/caption]', '</caption>')
        .replaceAll('[blockquote]', '<blockquote>')
        .replaceAll('[/blockquote]', '</blockquote>');
  }

  Future<void> savePostResponse(PostModel res, int id) async {
    setValue('$newsDetailData$id', jsonEncode(res));
  }

  @override
  Widget build(BuildContext context) {
    Widget getVariant({required PostModel postModel, required int id}) {
      savePostResponse(postModel, id);
      postContent = setDetails(postModel);

      if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1) {
        return NewsDetailPageVariantFirstWidget(post: postModel, postContent: postContent);
      } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 2) {
        return NewsDetailPageVariantSecondWidget(post: postModel, postContent: postContent);
      } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 3) {
        return NewsDetailPageVariantThirdWidget(post: postModel, postContent: postContent);
      } else {
        return SizedBox();
      }
    }

    return PageView(
      controller: pageController,
      children: widget.newsData!.map((e) {
        return FutureBuilder<PostModel>(
          initialData: e,
          future: getBlogDetail({'post_id': e.iD.validate().toString()}),
          builder: (context, snap) {
            if (snap.hasData) {
              return getVariant(postModel: snap.data!, id: snap.data!.iD.validate());
            } else if (snap.hasError) {
              return Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(appLocalization!.translate('something_was_wrong'), style: boldTextStyle(size: 18)),
                    8.height,
                    AppButton(
                      text: "Click to refresh",
                      onTap: () => setState(() {}),
                      color: primaryColor,
                      textStyle: boldTextStyle(color: Colors.white),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ],
                ).center(),
              );
            }
            return SizedBox();
            /*return getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1
                ? FirstNewsDetailShimmer()
                : getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 2
                    ? SecondNewsDetailShimmer()
                    : ThirdNewsDetailShimmer();*/
          },
        );
      }).toList(),
    );
  }
}
