import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class VideoShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 30, top: 8),
          itemBuilder: (_, i) => Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            padding: EdgeInsets.all(8),
            child: Container(
              width: context.width(),
              color: Colors.white12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 150, color: Colors.white30),
                  8.height,
                  Container(width: 100, height: 20, color: Colors.white30, margin: EdgeInsets.only(left: 16)),
                  8.height,
                  Container(width: 50, height: 20, color: Colors.white30, margin: EdgeInsets.only(left: 16)),
                  16.height,
                ],
              ),
            ).cornerRadiusWithClipRRect(8),
          ),
          itemCount: 5,
        ),
        baseColor: Colors.grey,
        highlightColor: Colors.black12,
        enabled: true,
        direction: ShimmerDirection.ltr,
        period: Duration(seconds: 1),
      ),
    );
  }
}
