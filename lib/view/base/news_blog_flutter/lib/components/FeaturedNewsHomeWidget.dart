import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Screens/NewsListDetailScreen.dart';
import 'package:news_flutter/Screens/SignInScreen.dart';
import 'package:news_flutter/Screens/ViewAllFeatureNewsList.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BookmarkWidget.dart';
import 'package:news_flutter/components/SeeAllButtonWidget.dart';
import 'package:news_flutter/components/UnBookmarkWidget.dart';

import '../main.dart';

class FeaturedNewsHomeWidget extends StatefulWidget {
  final AppLocalizations? appLocalization;
  final List<PostModel> recentNewsListing;
  final double? width;

  FeaturedNewsHomeWidget({this.appLocalization, required this.recentNewsListing, this.width});

  @override
  State<FeaturedNewsHomeWidget> createState() => _FeaturedNewsHomeWidgetState();
}

class _FeaturedNewsHomeWidgetState extends State<FeaturedNewsHomeWidget> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentIndex, viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.appLocalization!.translate('featured_News'),
              style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: 20),
            ).paddingOnly(left: 8.0),
            SeeAllButtonWidget(
              onTap: () {
                ViewAllFeatureNewsList(title: widget.appLocalization!.translate('featured_News')).launch(context);
              },
              widget: Text(
                widget.appLocalization!.translate('see_All'),
                style: primaryTextStyle(color: primaryColor, size: textSizeSMedium),
              ).paddingRight(8.0),
            ),
          ],
        ).paddingSymmetric(horizontal: 8),
        16.height,
        Container(
          width: context.width(),
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            pageSnapping: true,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              PostModel postModel = widget.recentNewsListing[index % 4];
              return Observer(
                builder: (_) {
                  return GestureDetector(
                    onTap: () async {
                      bool? res = await NewsListDetailScreen(newsData: widget.recentNewsListing, index: widget.recentNewsListing.indexOf(postModel)).launch(context);
                      if (res ?? false) {
                        setState(() {});
                      }
                    },
                    child: AnimatedScale(
                      scale: index == currentIndex ? 1.0 : 0.93,
                      duration: const Duration(milliseconds: 270),
                      curve: Curves.easeInOutCubic,
                      child: Stack(
                        children: [
                          cachedImage(
                            postModel.image.validate().toString(),
                            height: context.height(),
                            width: context.width(),
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: context.width(),
                            height: context.height(),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                stops: [0.0, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.mirror,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child:bookmarkStore.mBookmark.any((e) => e.iD == postModel.iD.validate())? IconWidget(
                              icon: cachedImage(
                                bookmarkStore.mBookmark.any((e) => e.iD == postModel.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                height: 22,
                                width: 22,
                                color: Colors.white,
                              ),
                              onTap: () {
                                if (appStore.isLoggedIn) {
                                  bookmarkStore.addToWishList(postModel);
                                } else {
                                  SignInScreen().launch(context);
                                }
                                setState(() {});
                              },
                            ): UnBookMarkIconWidget(
                                    icon: cachedImage(
                                      bookmarkStore.mBookmark.any((e) => e.iD == postModel.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                      height: 22,
                                      width: 22,
                                      color: primaryColor,
                                    ),
                                    onTap: () {
                                      if (appStore.isLoggedIn) {
                                        bookmarkStore.addToWishList(postModel);
                                      } else {
                                        SignInScreen().launch(context);
                                      }
                                      setState(() {});
                                    },
                                  ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  parseHtmlString(postModel.postTitle.validate()),
                                  style: boldTextStyle(color: Colors.white, size: textSizeNormal),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                4.height,
                                Text(postModel.readableDate.validate(), style: secondaryTextStyle(size: textSizeSMedium, color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                        ],
                      ).cornerRadiusWithClipRRect(defaultRadius),
                    ),
                  );
                },
              );
            },
          ),
        ),
        16.height,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.recentNewsListing.take(4).map((e) {
            return AnimatedContainer(
              margin: EdgeInsets.symmetric(horizontal: 2),
              height: 8,
              width: 8,
              decoration: BoxDecoration(color: (currentIndex % 4) == widget.recentNewsListing.indexOf(e) ? primaryColor : primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
              duration: Duration(milliseconds: 270),
            );
          }).toList(),
        )
      ],
    );
  }
}
