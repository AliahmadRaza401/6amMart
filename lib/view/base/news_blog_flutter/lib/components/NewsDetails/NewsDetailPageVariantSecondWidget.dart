import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:news_flutter/components/CommentButtonWidget.dart';
import 'package:news_flutter/components/HtmlWidget.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/ReadAloudDialog.dart';
import 'package:news_flutter/components/ViewCommentWidget.dart';
import 'package:share/share.dart';

import '../../main.dart';

// ignore: must_be_immutable
class NewsDetailPageVariantSecondWidget extends StatefulWidget {
  PostModel? post;
  final String? postContent;

  NewsDetailPageVariantSecondWidget({this.post, this.postContent});

  @override
  _NewsDetailPageVariantSecondWidgetState createState() => _NewsDetailPageVariantSecondWidgetState();
}

class _NewsDetailPageVariantSecondWidgetState extends State<NewsDetailPageVariantSecondWidget> {
  ScrollController _controller = ScrollController();
  bool isAdsLoad = false;
  bool isPostLoaded = false;
  String newsTitle = '';

  InterstitialAd? myInterstitial;
  BannerAd? myBanner;

  int fontSize = 18;

  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    setStatusBarColor(context.scaffoldBackgroundColor);
    myBanner = buildBannerAd()..load();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? bannerAdIdForAndroid : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(
          //  testDevices: [testDeviceId],
          ),
    );
  }

  void onShareTap(String url) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share('$url', subject: '', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void afterFirstLayout(BuildContext context) {
    setStatusBarColor(Colors.transparent);
  }

  void dispose() async {
    _controller.dispose();
    if (mInterstitialAdCount < 5) {
      mInterstitialAdCount++;
    } else {
      mInterstitialAdCount = 0;
      buildInterstitialAd();
    }
    setStatusBarColor(context.scaffoldBackgroundColor);
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '',
        color: context.scaffoldBackgroundColor,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            padding: EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    cachedImage(widget.post!.image.validate(), fit: BoxFit.cover, width: context.width(), height: 280).cornerRadiusWithClipRRect(defaultRadius),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: context.scaffoldBackgroundColor),
                        child: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                          offset: Offset(-12, 45),
                          icon: Icon(Icons.more_vert_rounded, color:appStore.isDarkMode?white: primaryColor),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            PopupMenuItem(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              onTap: () {
                                onShareTap(widget.post!.shareUrl.validate());
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  cachedImage(ic_send, width: 22, height: 22, color: primaryColor),
                                  8.width,
                                  Text(appLocalization!.translate('share').validate(), style: primaryTextStyle()),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              onTap: () {
                                if (appStore.isLoggedIn) {
                                  bookmarkStore.addToWishList(widget.post!);
                                } else {
                                  SignInScreen().launch(context);
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  cachedImage(bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark, height: 22, width: 22, color: primaryColor),
                                  8.width,
                                  Text(appLocalization!.translate('WishList').validate(), style: primaryTextStyle()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ).paddingAll(16),
                Row(
                  children: [
                    if (widget.post!.category != null)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.post!.category.validate().map((e) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
                      icon: cachedImage(ic_voice, height: 22, width: 22, color: Colors.white),
                      onTap: () async {
                        await showInDialog(
                          context,
                          builder: (_) => ReadAloudDialog(parseHtmlString(widget.post!.postContent.validate())),
                          contentPadding: EdgeInsets.zero,
                          barrierDismissible: false,
                        );
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 8),
                Text('${parseHtmlString(widget.post!.postTitle.validate())}', style: boldTextStyle(size: textSizeXLarge, color: Theme.of(context).textTheme.headline6!.color))
                    .paddingSymmetric(horizontal: 16, vertical: 8),
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
                            style: primaryTextStyle(color: primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ).expand(),
                    Text(widget.post!.readableDate.validate(), style: secondaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color)),
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 8),
                HtmlWidget(postContent: widget.postContent).paddingSymmetric(horizontal: 8),
                Divider(color: Colors.grey.shade500, thickness: 0.3),
                ViewCommentWidget(id: widget.post!.iD.validate(), itemLength: 3),
                if (widget.post!.postContent != null) Divider(color: Colors.grey.shade500, thickness: 0.3).paddingTop(8),
                if (widget.post!.postContent != null) WriteCommentScreen(id: widget.post!.iD.validate()),
              ],
            ),
          ),
          LoadingDotsWidget().center().visible(appStore.isLoading),
          Positioned(
            bottom: 16,
            right: 16,
            child: CommentButtonWidget(_controller),
          ),
        ],
      ),
      bottomNavigationBar: isAdsLoad
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 60,
              child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
            )
          : SizedBox(),
    );
  }
}
