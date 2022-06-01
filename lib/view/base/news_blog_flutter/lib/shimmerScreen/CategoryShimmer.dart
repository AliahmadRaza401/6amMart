import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        runAlignment: WrapAlignment.center,
        children: List.generate(
          15,
          (index) {
            return Container(
              height: 120,
              width: (context.width() / 2) - 24,
              decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(defaultRadius)),
            );
          },
        ),
      ).paddingOnly(left: 16,right: 16,top: 16,bottom: 16),
      baseColor: Colors.grey,
      highlightColor: Colors.black12,
      enabled: true,
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 1),
    );
  }
}
