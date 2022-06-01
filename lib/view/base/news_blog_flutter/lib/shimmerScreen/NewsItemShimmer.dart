import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class NewsItemShimmer extends StatelessWidget {
  static String tag = '/NewsItemShimmer';

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 50),
        itemBuilder: (_, i) => Container(
          margin: EdgeInsets.all(8),
          height: 250.0,
          width: context.width(),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: Colors.white30),
        ),
        itemCount: 5,
      ),
      baseColor: Colors.grey,
      highlightColor: Colors.black12,
      enabled: true,
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 1),
    );
  }
}
