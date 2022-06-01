import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class WebPopularStoreView extends StatelessWidget {
  final StoreController storeController;
  final bool isPopular;
  WebPopularStoreView({@required this.storeController, @required this.isPopular});

  @override
  Widget build(BuildContext context) {
    List<Store> _storeList = isPopular ? storeController.popularStoreList : storeController.latestStoreList;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: TitleWidget(title: isPopular ? Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
              ? 'popular_restaurants'.tr : 'popular_stores'.tr : '${'new_on'.tr} ${AppConstants.APP_NAME}'),
        ),

        _storeList != null ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: (1/0.7),
            crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          itemCount: _storeList.length > 5 ? 6 : _storeList.length,
          itemBuilder: (context, index){
            if(index == 5) {
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute(isPopular ? 'popular' : 'latest')),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+${_storeList.length-5}\n${'more'.tr}', textAlign: TextAlign.center,
                    style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                  ),
                ),
              );
            }

            return InkWell(
              onTap: () {
                Get.toNamed(
                  RouteHelper.getStoreRoute(_storeList[index].id, 'store'),
                  arguments: StoreScreen(store: _storeList[index], fromModule: false),
                );
              },
              child: Container(
                width: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [BoxShadow(
                    color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                    blurRadius: 5, spreadRadius: 1,
                  )],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}'
                            '/${_storeList[index].coverPhoto}',
                        height: 120, width: 500, fit: BoxFit.cover,
                      ),
                    ),
                    DiscountTag(
                      discount: storeController.getDiscount(_storeList[index]),
                      discountType: storeController.getDiscountType(_storeList[index]),
                      freeDelivery: _storeList[index].freeDelivery,
                    ),
                    storeController.isOpenNow(_storeList[index]) ? SizedBox() : NotAvailableWidget(isStore: true),
                    Positioned(
                      top: Dimensions.PADDING_SIZE_EXTRA_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      child: GetBuilder<WishListController>(builder: (wishController) {
                        bool _isWished = wishController.wishStoreIdList.contains(_storeList[index].id);
                        return InkWell(
                          onTap: () {
                            if(Get.find<AuthController>().isLoggedIn()) {
                              _isWished ? wishController.removeFromWishList(_storeList[index].id, true)
                                  : wishController.addToWishList(null, _storeList[index], true);
                            }else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            ),
                            child: Icon(
                              _isWished ? Icons.favorite : Icons.favorite_border,  size: 20,
                              color: _isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                            ),
                          ),
                        );
                      }),
                    ),
                  ]),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          _storeList[index].name,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        Text(
                          _storeList[index].address,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        RatingBar(
                          rating: _storeList[index].avgRating,
                          ratingCount: _storeList[index].ratingCount,
                          size: 15,
                        ),
                      ]),
                    ),
                  ),

                ]),
              ),
            );
          },
        ) : PopularStoreShimmer(storeController: storeController),
      ],
    );
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final StoreController storeController;
  PopularStoreShimmer({@required this.storeController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: (1/0.7),
        crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      itemCount: 6,
      itemBuilder: (context, index){
        return Container(
          width: 500,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 120, width: 500,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 15, width: 100, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

