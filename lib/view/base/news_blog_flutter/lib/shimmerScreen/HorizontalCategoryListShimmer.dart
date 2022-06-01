import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalCategoryListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        HorizontalList(
          itemCount: 5,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: Colors.white30),
                height: 80,
                width: 150,
              ),
              baseColor: Colors.grey,
              highlightColor: Colors.black12,
              enabled: true,
              direction: ShimmerDirection.ltr,
              period: Duration(seconds: 1),
            );
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 8);
  }
}
