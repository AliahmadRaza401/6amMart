import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class ThirdNewsDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Shimmer.fromColors(
                child: Container(
                  height: context.height() * 0.5,
                  width: context.width(),
                  decoration: BoxDecoration(color: Colors.white30),
                ),
                baseColor: Colors.grey,
                highlightColor: Colors.black12,
                enabled: true,
                direction: ShimmerDirection.ltr,
                period: Duration(seconds: 1),
              ),
              Positioned(
                bottom: -context.height() * 0.1,
                left: 16,
                right: 16,
                child: Shimmer.fromColors(
                  child: Container(
                    height: 150.0,
                    width: context.width(),
                    decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(defaultRadius)),
                  ),
                  baseColor: Colors.grey,
                  highlightColor: Colors.black12,
                  enabled: true,
                  direction: ShimmerDirection.ltr,
                  period: Duration(seconds: 1),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 20,
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
          ).paddingOnly(left: 16, top: context.height() * 0.1, right: 16),
        ],
      ),
    );
  }
}
