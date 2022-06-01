import 'package:sixam_mart/controller/campaign_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/item_bottom_sheet.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebCampaignView extends StatelessWidget {
  final CampaignController campaignController;
  WebCampaignView({@required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text('campaigns'.tr, style: robotoMedium.copyWith(fontSize: 24)),
        ),

        campaignController.itemCampaignList != null ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: (1/1.1),
            mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE, crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          itemCount: campaignController.itemCampaignList.length > 3 ? 4 : campaignController.itemCampaignList.length,
          itemBuilder: (context, index){
            if(index == 3) {
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getItemCampaignRoute()),
                child: Container(
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
                    '+${campaignController.itemCampaignList.length-3}\n${'more'.tr}', textAlign: TextAlign.center,
                    style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                  ),
                ),
              );
            }

            return InkWell(
              onTap: () {
                ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                  ItemBottomSheet(item: campaignController.itemCampaignList[index], isCampaign: true),
                  backgroundColor: Colors.transparent, isScrollControlled: true,
                ) : Get.dialog(
                  Dialog(child: ItemBottomSheet(item: campaignController.itemCampaignList[index], isCampaign: true)),
                );
              },
              child: Container(
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
                        image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}'
                            '/${campaignController.itemCampaignList[index].image}',
                        height: 135, fit: BoxFit.cover, width: context.width/4,
                      ),
                    ),
                    DiscountTag(
                      discount: campaignController.itemCampaignList[index].storeDiscount > 0
                          ? campaignController.itemCampaignList[index].storeDiscount
                          : campaignController.itemCampaignList[index].discount,
                      discountType: campaignController.itemCampaignList[index].storeDiscount > 0 ? 'percent'
                          : campaignController.itemCampaignList[index].discountType,
                      fromTop: Dimensions.PADDING_SIZE_LARGE, fontSize: Dimensions.fontSizeExtraSmall,
                    ),
                    Get.find<ItemController>().isAvailable(campaignController.itemCampaignList[index])
                        ? SizedBox() : NotAvailableWidget(),
                  ]),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          campaignController.itemCampaignList[index].name,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        Text(
                          campaignController.itemCampaignList[index].storeName,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                PriceConverter.convertPrice(campaignController.itemCampaignList[index].price),
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 12),
                            Text(
                              campaignController.itemCampaignList[index].avgRating.toStringAsFixed(1),
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),

                ]),
              ),
            );
          },
        ) : WebPopularItemShimmer(campaignController: campaignController),
      ],
    );
  }
}

class WebPopularItemShimmer extends StatelessWidget {
  final CampaignController campaignController;
  WebPopularItemShimmer({@required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, childAspectRatio: (1/1.1),
        mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE, crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      itemCount: 8,
      itemBuilder: (context, index){
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: campaignController.itemCampaignList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 135,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                  color: Colors.grey[300],
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

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(height: 10, width: 30, color: Colors.grey[300]),
                      RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                    ]),
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

