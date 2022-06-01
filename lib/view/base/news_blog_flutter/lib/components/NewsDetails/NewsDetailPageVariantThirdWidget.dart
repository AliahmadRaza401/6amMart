import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Screens/SignInScreen.dart';
import 'package:news_flutter/Screens/WriteCommentScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/components/BookmarkWidget.dart';
import 'package:news_flutter/components/HtmlWidget.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/ReadAloudDialog.dart';
import 'package:news_flutter/components/UnBookmarkWidget.dart';
import 'package:news_flutter/components/ViewCommentWidget.dart';
import 'package:share/share.dart';

import '../../main.dart';

class NewsDetailPageVariantThirdWidget extends StatefulWidget {
  final PostModel? post;
  final String? postContent;

  NewsDetailPageVariantThirdWidget({this.post, this.postContent});

  @override
  NewsDetailPageVariantThirdWidgetState createState() => NewsDetailPageVariantThirdWidgetState();
}

class NewsDetailPageVariantThirdWidgetState extends State<NewsDetailPageVariantThirdWidget> {
  BannerAd? myBanner;
  InterstitialAd? myInterstitial;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    myBanner = buildBannerAd()..load();
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

  void dispose() async {
    setStatusBarColor(appStore.isDarkMode ? card_color_dark : card_color_light);
    myBanner!.dispose();
    if (mInterstitialAdCount < 5) {
      mInterstitialAdCount++;
    } else {
      mInterstitialAdCount = 0;
      buildInterstitialAd();
    }

    super.dispose();
  }

  Future<void> buildInterstitialAd() {
    return InterstitialAd.load(
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

  void onShareTap(String url) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share('$url', subject: '', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              if (innerBoxIsScrolled) {
                setStatusBarColor(appStore.isDarkMode ? card_color_dark : white);
              }
              return <Widget>[
                SliverAppBar(
                  pinned: false,
                  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
                  expandedHeight: context.height() * 0.50,
                  flexibleSpace: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FlexibleSpaceBar(
                        background: cachedImage(widget.post!.image.validate(), fit: BoxFit.cover, width: context.width(), height: 280),
                      ),
                      Positioned(
                        bottom: -context.height() * 0.1,
                        left: 16,
                        right: 16,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 100),
                          opacity: innerBoxIsScrolled == true ? 0.0 : 1.0,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: widget.post!.category.validate().take(2).map((e) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(32.0),
                                        ),
                                        child: Text(e.name.validate(), style: primaryTextStyle(color: Colors.white)),
                                      );
                                    }).toList(),
                                  ).expand(),
                                  8.width,
                                  IconWidget(
                                    icon: cachedImage(ic_voice, height: 22, width: 22, color: primaryColor),
                                    backgroundColor: Colors.white,
                                    onTap: () async {
                                      await showInDialog(
                                        context,
                                        builder: (_) => ReadAloudDialog(parseHtmlString(widget.post!.postContent.validate())),
                                        contentPadding: EdgeInsets.zero,
                                        barrierDismissible: false,
                                      );
                                    },
                                  ),
                                  16.width,
                                  IconWidget(
                                    backgroundColor: Colors.white,
                                    icon: cachedImage(ic_send, width: 20, height: 20, color: primaryColor),
                                    onTap: () {
                                      onShareTap(widget.post!.shareUrl.validate());
                                    },
                                  ),
                                  16.width,
                                  bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate())
                                      ? IconWidget(
                                          icon: cachedImage(
                                            bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                            height: 20,
                                            width: 20,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            if (appStore.isLoggedIn) {
                                              bookmarkStore.addToWishList(widget.post!);
                                            } else {
                                              SignInScreen().launch(context);
                                            }
                                            setState(() {});
                                          },
                                        )
                                      : UnBookMarkIconWidget(
                                          icon: cachedImage(
                                            bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                            height: 22,
                                            width: 22,
                                            color: primaryColor,
                                          ),
                                          onTap: () {
                                            if (appStore.isLoggedIn) {
                                              bookmarkStore.addToWishList(widget.post!);
                                            } else {
                                              SignInScreen().launch(context);
                                            }
                                            setState(() {});
                                          },
                                        ),
                                ],
                              ),
                              16.height,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(defaultRadius),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    width: context.width(),
                                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            if (widget.post!.postAuthorName.validate().isNotEmpty)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  createNews(userImage: ic_profile),

                                                  6.width,
                                                  Text(
                                                    '${appLocalization!.translate('lbl_authorBy') + ' ${parseHtmlString(admin_author.any((e) => e == widget.post!.postAuthorName.validate()) ? AppName : widget.post!.postAuthorName.validate())}'}',
                                                    style: primaryTextStyle(color: Colors.white),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ).expand(),
                                            Text(widget.post!.readableDate.validate(), style: secondaryTextStyle(color: Colors.white)),
                                          ],
                                        ),
                                        8.height,
                                        Text('${parseHtmlString(widget.post!.postTitle.validate())}', style: boldTextStyle(size: textSizeLarge, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: BackWidget(
                    color: innerBoxIsScrolled
                        ? appStore.isDarkMode
                            ? Colors.white
                            : Colors.black
                        : Colors.white,
                    onPressed: () async {
                      finish(context);
                    },
                  ),
                )
              ];
            },
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsetsDirectional.all(0),
                 // padding: EdgeInsets.only(left: 8, top: context.height() * 0.1, right: 8, bottom: 24),
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      64.height,
                      HtmlWidget(postContent: widget.postContent).paddingOnly(left: 8,right: 8),
                      Divider(color: Colors.grey.shade500, thickness: 0.3),
                      ViewCommentWidget(id: widget.post!.iD.validate(), itemLength: 3),
                      if (widget.post!.postContent != null) Divider(color: Colors.grey.shade500, thickness: 0.3).paddingTop(8),
                      if (widget.post!.postContent != null) WriteCommentScreen(id: widget.post!.iD.validate()),
                    ],
                  ),
                ),
                LoadingDotsWidget().center().visible(appStore.isLoading),
              ],
            ),
          );
        },
      ),
    );
  }
}
