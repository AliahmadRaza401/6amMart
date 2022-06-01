import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isStore;
  final bool hasDivider;
  ItemShimmer({@required this.isEnabled, @required this.hasDivider, this.isStore = false});

  @override
  Widget build(BuildContext context) {
    bool _desktop = ResponsiveHelper.isDesktop(context);

    return Container(
      padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
        boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
          color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5,
        )] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(children: [

                Container(
                  height: _desktop ? 120 : 65, width: _desktop ? 120 : 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(height: _desktop ? 20 : 10, width: double.maxFinite, color: Colors.grey[300]),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Container(
                      height: _desktop ? 15 : 10, width: double.maxFinite, color: Colors.grey[300],
                      margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                    ),
                    SizedBox(height: isStore ? Dimensions.PADDING_SIZE_SMALL : 0),

                    !isStore ? RatingBar(rating: 0, size: _desktop ? 15 : 12, ratingCount: 0) : SizedBox(),
                    isStore ? RatingBar(
                      rating: 0, size: _desktop ? 15 : 12,
                      ratingCount: 0,
                    ) : Row(children: [
                      Container(height: _desktop ? 20 : 15, width: 30, color: Colors.grey[300]),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Container(height: _desktop ? 15 : 10, width: 20, color: Colors.grey[300]),
                    ]),

                  ]),
                ),

                Column(mainAxisAlignment: isStore ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [
                  !isStore ? Padding(
                    padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                    child: Icon(Icons.add, size: _desktop ? 30 : 25),
                  ) : SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                    child: Icon(
                      Icons.favorite_border,  size: _desktop ? 30 : 25,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ]),

              ]),
            ),
          ),
          _desktop ? SizedBox() : Padding(
            padding: EdgeInsets.only(left: _desktop ? 130 : 90),
            child: Divider(color: hasDivider ? Theme.of(context).disabledColor : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
