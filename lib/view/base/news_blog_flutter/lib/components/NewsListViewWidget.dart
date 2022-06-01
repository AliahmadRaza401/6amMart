import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news_flutter/Model/PostModel.dart';

import 'NewsItemWidget.dart';

class NewsListViewWidget extends StatelessWidget {
  final List<PostModel>? latestNewsList;

  NewsListViewWidget({this.latestNewsList});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: latestNewsList!.take(10).length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          if (latestNewsList!.isEmpty) return SizedBox();
          PostModel post = latestNewsList![i];

          return AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 44.0,
              child: FadeInAnimation(
                child: NewsItemWidget(post, data: latestNewsList, index: i),
              ),
            ),
          );
        },
      ),
    );
  }
}
