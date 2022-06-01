import 'package:sixam_mart/controller/campaign_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BasicCampaignView extends StatelessWidget {
  final CampaignController campaignController;
  BasicCampaignView({@required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 15),
          child: TitleWidget(title: 'basic_campaigns'.tr),
        ),
        SizedBox(
          height: 80,
          child: campaignController.basicCampaignList != null ? ListView.builder(
            itemCount: campaignController.basicCampaignList.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getBasicCampaignRoute(
                    campaignController.basicCampaignList[index],
                  )),
                  child: Container(
                    margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}'
                            '/${campaignController.basicCampaignList[index].image}',
                        width: 200, height: 80, fit: BoxFit.cover,
                      ),
                    ),
                  )
              );
            },
          ) : CampaignShimmer(campaignController: campaignController),
        ),
      ],
    );
  }
}

class CampaignShimmer extends StatelessWidget {
  final CampaignController campaignController;
  CampaignShimmer({@required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemBuilder: (context, index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled: campaignController.basicCampaignList == null,
          child: Container(
            width: 200, height: 80,
            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            ),
          ),
        );
      },
    );
  }
}

