import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/NewsDetails/NewsDetailPageVariantFirstWidget.dart';
import 'package:news_flutter/components/NewsDetails/NewsDetailPageVariantSecondWidget.dart';
import 'package:news_flutter/components/NewsDetails/NewsDetailPageVariantThirdWidget.dart';
import 'package:news_flutter/main.dart';

enum PostType { HTML, String, WordPress }

// ignore: must_be_immutable
class NewsDetailScreen extends StatefulWidget {
  final String? newsId;
  PostModel? post;

  NewsDetailScreen({this.newsId, this.post});

  @override
  NewsDetailScreenState createState() => NewsDetailScreenState();
}

class NewsDetailScreenState extends State<NewsDetailScreen> {
  int fontSize = 18;
  String postContent = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    fontSize = getIntAsync(FONT_SIZE, defaultValue: 18);
    afterBuildCreated(() {
      setStatusBarColor(Colors.transparent);
    });
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
    if (!isAdsDisabled) {
      if (mInterstitialAdCount < 5) {
        mInterstitialAdCount++;
      } else {
        mInterstitialAdCount = 0;
        buildInterstitialAd();
      }
    }
  }

  void buildInterstitialAd() {
    InterstitialAd.load(
      adUnitId: kReleaseMode ? InterstitialAdIdForAndroid : InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
        },
      ),
    );
  }

  Future<void> savePostResponse(PostModel res) async {
    setValue('$newsDetailData${widget.newsId}', jsonEncode(res));
  }

  @override
  Widget build(BuildContext context) {
    Widget getVariant({required PostModel postModel}) {
      savePostResponse(postModel);
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

    return Scaffold(
      body: FutureBuilder<PostModel>(
        initialData: widget.post,
        future: getBlogDetail({'post_id': widget.newsId}),
        builder: (context, snap) {
          if (snap.hasData) {
            return getVariant(postModel: snap.data!);
          } else if (snap.hasError) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(appLocalization!.translate('something_was_wrong'), style: boldTextStyle(size: 18,color: Colors.red)),
                8.height,
                AppButton(
                  text: "Click to refresh",
                  onTap: () => setState(() {}),
                  color: primaryColor,
                  textStyle: boldTextStyle(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ],
            ).center();
          }
          return SizedBox();
          /*return getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1
              ? FirstNewsDetailShimmer()
              : getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 2
                  ? SecondNewsDetailShimmer()
                  : ThirdNewsDetailShimmer();*/
        },
      ),
    );
  }
}
