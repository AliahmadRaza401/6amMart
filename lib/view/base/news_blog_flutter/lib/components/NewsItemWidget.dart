import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Screens/NewsListDetailScreen.dart';
import 'package:news_flutter/Screens/SignInScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/OverlayHandler.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/BookmarkWidget.dart';
import 'package:news_flutter/components/QuickNewsPostDialogWidget.dart';
import 'package:news_flutter/components/UnBookmarkWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:palette_generator/palette_generator.dart';

class NewsItemWidget extends StatefulWidget {
  static String tag = '/NewsItemWidget';
  final PostModel post;
  final int index;
  final List<PostModel>? data;

  NewsItemWidget(this.post, {this.data, this.index = 0});

  @override
  _NewsItemWidgetState createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {
  OverlayHandler _overlayHandler = OverlayHandler();
  PaletteGenerator? paletteGenerator;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return GestureDetector(
          onTap: () async {
            bool? res = await NewsListDetailScreen(newsData: widget.data, index: widget.index).launch(context);
            if (res ?? false) {
              setState(() {});
            }
          },
          onLongPress: () {
            _overlayHandler.insertOverlay(context, OverlayEntry(
              builder: (context) {
                return QuickNewsPostDialogWidget(postModel: widget.post);
              },
            ));
          },
          onLongPressEnd: (details) => _overlayHandler.removeOverlay(context),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 250,
            width: context.width(),
            child: Stack(
              children: [
                cachedImage(widget.post.image.validate(), height: context.height(), width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
                Container(
                  width: context.width(),
                  height: context.height(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                  child:bookmarkStore.mBookmark.any((e) => e.iD == widget.post.iD.validate())? IconWidget(
                    icon: cachedImage(bookmarkStore.mBookmark.any((e) => e.iD == widget.post.iD.validate()) ? ic_bookmarked : ic_bookmark, height: 22, width: 22, color: Colors.white),
                    onTap: () {
                      if (appStore.isLoggedIn) {
                        bookmarkStore.addToWishList(widget.post);
                      } else {
                        SignInScreen().launch(context);
                      }
                      setState(() {});
                    },
                  ):UnBookMarkIconWidget(
                    icon: cachedImage(
                      bookmarkStore.mBookmark.any((e) => e.iD == widget.post.iD.validate()) ? ic_bookmarked : ic_bookmark,
                      height: 22,
                      width: 22,
                      color: primaryColor,
                    ),
                    onTap: () {
                      if (appStore.isLoggedIn) {
                        bookmarkStore.addToWishList(widget.post);
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
                    children: <Widget>[
                      Text(
                        parseHtmlString(widget.post.postTitle.validate()),
                        style: boldTextStyle(color: Colors.white, size: textSizeNormal),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.height,
                      Text(widget.post.readableDate.validate(), style: secondaryTextStyle(size: textSizeSMedium, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
          ).paddingAll(8),
        );
      },
    );
  }
}
