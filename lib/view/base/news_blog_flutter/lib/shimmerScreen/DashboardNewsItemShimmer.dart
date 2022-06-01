import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class DashboardNewsItemShimmer extends StatelessWidget {
  static String tag = '/NewsItemShimmer';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 45),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer.fromColors(
            child: Container(
              margin: EdgeInsets.all(8),
              height: 80.0,
              width: context.width(),
              decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(defaultRadius)),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.black12,
            enabled: true,
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 1),
          ),
          Shimmer.fromColors(
            child: Container(
              margin: EdgeInsets.all(8),
              height: 16.0,
              width: context.width(),
              color: Colors.white30,
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.black12,
            enabled: true,
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 1),
          ),
          Shimmer.fromColors(
            child: Container(
              margin: EdgeInsets.all(8),
              height: 250.0,
              width: context.width(),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: Colors.white30),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.black12,
            enabled: true,
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 1),
          ),
          16.height,
          Shimmer.fromColors(
            child: Container(
              margin: EdgeInsets.all(8),
              height: 16.0,
              width: context.width(),
              color: Colors.white30,
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.black12,
            enabled: true,
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 1),
          ),
          Shimmer.fromColors(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 30),
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
          ),
        ],
      ),
    );
  }
}
