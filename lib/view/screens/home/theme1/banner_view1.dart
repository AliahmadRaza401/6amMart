import 'package:carousel_slider/carousel_slider.dart';
import 'package:sixam_mart/controller/banner_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/basic_campaign_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/item_bottom_sheet.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView1 extends StatelessWidget {
  final bool isFeatured;
  BannerView1({@required this.isFeatured});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String> bannerList = isFeatured ? bannerController.featuredBannerList : bannerController.bannerImageList;
      List<dynamic> bannerDataList = isFeatured ? bannerController.featuredBannerDataList : bannerController.bannerDataList;

      return (bannerList != null && bannerList.length == 0) ? SizedBox() : Container(
        width: MediaQuery.of(context).size.width,
        height: GetPlatform.isDesktop ? 500 : MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
        child: bannerList != null ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: 0.95,
                  autoPlayInterval: Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    bannerController.setCurrentIndex(index, true);
                  },
                ),
                itemCount: bannerList.length == 0 ? 1 : bannerList.length,
                itemBuilder: (context, index, _) {
                  String _baseUrl = bannerDataList[index] is BasicCampaignModel ? Get.find<SplashController>()
                      .configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.bannerImageUrl;
                  return InkWell(
                    onTap: () {
                      if(bannerDataList[index] is Item) {
                        Item _product = bannerDataList[index];
                        ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                          builder: (con) => ItemBottomSheet(item: _product),
                        ) : showDialog(context: context, builder: (con) => Dialog(
                            child: ItemBottomSheet(item: _product)),
                        );
                      }else if(bannerDataList[index] is Store) {
                        Store _store = bannerDataList[index];
                        if(isFeatured && Get.find<SplashController>().moduleList != null) {
                          for(ModuleModel module in Get.find<SplashController>().moduleList) {
                            if(module.id == _store.moduleId) {
                              Get.find<SplashController>().setModule(module);
                              break;
                            }
                          }
                        }
                        Get.toNamed(
                          RouteHelper.getStoreRoute(_store.id, isFeatured ? 'module' : 'banner'),
                          arguments: StoreScreen(store: _store, fromModule: isFeatured),
                        );
                      }else if(bannerDataList[index] is BasicCampaignModel) {
                        BasicCampaignModel _campaign = bannerDataList[index];
                        Get.toNamed(RouteHelper.getBasicCampaignRoute(_campaign));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: GetBuilder<SplashController>(builder: (splashController) {
                          return CustomImage(
                            image: '$_baseUrl/${bannerList[index]}',
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerList.map((bnr) {
                int index = bannerList.indexOf(bnr);
                return TabPageSelectorIndicator(
                  backgroundColor: index == bannerController.currentIndex ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.5),
                  borderColor: Theme.of(context).backgroundColor,
                  size: index == bannerController.currentIndex ? 10 : 7,
                );
              }).toList(),
            ),

          ],
        ) : Shimmer(
          duration: Duration(seconds: 2),
          enabled: bannerList == null,
          child: Container(margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: Colors.grey[300],
          )),
        ),
      );
    });
  }

}