import 'package:flutter/material.dart';

class ScrollHelper {
  static void startAutoScrolling(List itemList, ScrollController scrollController, int viewWidth) {
    if(itemList != null && itemList.length > 0) {
      Future.delayed(Duration(seconds: 1), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: (itemList.length * viewWidth) ~/ 15),
          curve: Curves.linear,
        );
      });
      scrollController.addListener(() {
        if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          scrollController.jumpTo(0);
          Future.delayed(Duration(seconds: 1), () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(seconds: (itemList.length * viewWidth) ~/ 15),
              curve: Curves.linear,
            );
          });
        }
      });
    }
  }
}