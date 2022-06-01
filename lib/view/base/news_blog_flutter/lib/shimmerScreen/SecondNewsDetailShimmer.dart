import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class SecondNewsDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Shimmer.fromColors(
            child: Container(
              height: 32.0,
              width: context.width(),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white30),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.black12,
            enabled: true,
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 1),
          ).paddingOnly(top: 24, bottom: 8),
          Shimmer.fromColors(
            child: Container(
              height: 16.0,
              width: context.width(),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white30),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.black12,
            enabled: true,
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 1),
          ),
          Shimmer.fromColors(
            child: Container(
              height: 280.0,
              width: context.width(),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: Colors.white30),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.black12,
            enabled: true,
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 1),
          ).paddingSymmetric(vertical: 16),
          Row(
            children: [
              Shimmer.fromColors(
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
                ),
                baseColor: Colors.grey,
                highlightColor: Colors.black12,
                enabled: true,
                direction: ShimmerDirection.ltr,
                period: Duration(seconds: 1),
              ),
              8.width,
              Shimmer.fromColors(
                child: Container(
                  height: 16.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white30),
                ),
                baseColor: Colors.grey,
                highlightColor: Colors.black12,
                enabled: true,
                direction: ShimmerDirection.ltr,
                period: Duration(seconds: 1),
              ).expand(),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                child: Container(
                  height: 16.0,
                  width: context.width(),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white30),
                ),
                baseColor: Colors.grey,
                highlightColor: Colors.black12,
                enabled: true,
                direction: ShimmerDirection.ltr,
                period: Duration(seconds: 1),
              ).paddingBottom(8);
            },
          ),
        ],
      ).paddingAll(16),
    );
  }
}
