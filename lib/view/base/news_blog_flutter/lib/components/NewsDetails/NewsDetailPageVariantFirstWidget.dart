import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Screens/NewsDetailScreen.dart';
import 'package:news_flutter/Screens/SignInScreen.dart';
import 'package:news_flutter/Screens/WriteCommentScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/BookmarkWidget.dart';
import 'package:news_flutter/components/CommentButtonWidget.dart';
import 'package:news_flutter/components/HtmlWidget.dart';
import 'package:news_flutter/components/ReadAloudDialog.dart';
import 'package:news_flutter/components/UnBookmarkWidget.dart';
import 'package:news_flutter/components/ViewCommentWidget.dart';
import 'package:share/share.dart';

import '../../main.dart';

class NewsDetailPageVariantFirstWidget extends StatefulWidget {
  final PostModel? post;
  final String? postContent;

  NewsDetailPageVariantFirstWidget({this.post, this.postContent});

  @override
  NewsDetailPageVariantFirstWidgetState createState() => NewsDetailPageVariantFirstWidgetState();
}

class NewsDetailPageVariantFirstWidgetState extends State<NewsDetailPageVariantFirstWidget> {
  ScrollController _scrollController = ScrollController();
  bool isAdsLoad = false;
  bool isPostLoaded = false;
  String newsTitle = '';
  bool isBookMark = false;

  int fontSize = 18;

  PostType postType = PostType.HTML;
  BannerAd? myBanner;

  @override
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

  @override
  void dispose() {
    myBanner?.dispose();
    _scrollController.dispose();
    //setStatusBarColor(context.scaffoldBackgroundColor);
    super.dispose();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? bannerAdIdForAndroid : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          //
        },
      ),
      request: AdRequest(),
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
      appBar: appBarWidget(
        '',
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        showBack: true,
        backWidget: Icon(Icons.arrow_back_ios, size: 20).onTap(() {
          finish(context);
        }),
      ),
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: widget.post!,
                          child: cachedImage(
                            widget.post!.image.validate(),
                            height: 280,
                            width: context.width(),
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(defaultRadius),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            children: [
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: widget.post!.category.validate().take(2).map((e) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                        ),
                      ],
                    ).paddingAll(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                    style: primaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ).expand(),
                            Text(widget.post!.readableDate.validate(), style: secondaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color)),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        16.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${parseHtmlString(widget.post!.postTitle.validate())}',
                              style: boldTextStyle(
                                size: textSizeXLarge,
                                color: Theme.of(context).textTheme.headline6!.color,
                              ),
                              maxLines: 5,
                            ).expand(),
                            IconWidget(
                              backgroundColor: primaryColor,
                              icon: cachedImage(ic_voice, height: 20, width: 20, color: Colors.white),
                              onTap: () async {
                                showInDialog(
                                  context,
                                  builder: (_) => ReadAloudDialog(parseHtmlString(widget.post!.postContent.validate())),
                                  contentPadding: EdgeInsets.zero,
                                  barrierDismissible: false,
                                );
                              },
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        16.height,
                        HtmlWidget(postContent: widget.postContent).paddingSymmetric(horizontal: 8),
                        8.height,
                        Divider(color: Colors.grey.shade500, thickness: 0.3),
                        8.height,
                        ViewCommentWidget(id: widget.post!.iD.validate(), itemLength: 3),
                        if (widget.post!.postContent != null) Divider(color: Colors.grey.shade500, thickness: 0.1).paddingTop(8),
                        if (widget.post!.postContent != null) WriteCommentScreen(id: widget.post!.iD.validate()),
                      ],
                    ),
                  ],
                ),
              ),
              Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading),
              Positioned(
                bottom: 16,
                right: 16,
                child: CommentButtonWidget(_scrollController),
              ),
            ],
          );
        },
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
