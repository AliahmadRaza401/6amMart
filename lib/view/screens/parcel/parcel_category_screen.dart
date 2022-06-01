import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/screens/home/web/module_widget.dart';

class ParcelCategoryScreen extends StatefulWidget {
  @override
  State<ParcelCategoryScreen> createState() => _ParcelCategoryScreenState();
}

class _ParcelCategoryScreenState extends State<ParcelCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? null : CustomAppBar(
        title: 'parcel'.tr, leadingIcon: Images.module_icon,
        onBackPressed: () => Get.find<SplashController>().setModule(null),
      ),
      body: GetBuilder<ParcelController>(builder: (parcelController) {
        return Stack(clipBehavior: Clip.none, children: [

          SingleChildScrollView(
            padding: ResponsiveHelper.isDesktop(context) ? null : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: FooterView(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Center(child: Image.asset(Images.parcel, height: 200)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              Center(child: Text('instant_same_day_delivery'.tr, style: robotoMedium)),
              Center(child: Text(
                'send_things_to_your_destination_instantly_and_safely'.tr,
                style: robotoRegular, textAlign: TextAlign.center,
              )),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text('what_are_you_sending'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              parcelController.parcelCategoryList != null ? parcelController.parcelCategoryList.length > 0 ? GridView.builder(
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/0.25) : (1/0.20),
                  crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                ),
                itemCount: parcelController.parcelCategoryList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getParcelLocationRoute(parcelController.parcelCategoryList[index])),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      ),
                      child: Row(children: [

                        Container(
                          height: 55, width: 55, alignment: Alignment.center,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel.baseUrls.parcelCategoryImageUrl}'
                                  '/${parcelController.parcelCategoryList[index].image}',
                              height: 30, width: 30,
                            ),
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(parcelController.parcelCategoryList[index].name, style: robotoMedium),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text(
                            parcelController.parcelCategoryList[index].description, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ])),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        Icon(Icons.keyboard_arrow_right),

                      ]),
                    ),
                  );
                },
              ) : Center(child: Text('no_parcel_category_found'.tr)) : ParcelShimmer(isEnabled: parcelController.parcelCategoryList == null),

            ]))),
          ),

          ResponsiveHelper.isDesktop(context) ? Positioned(top: 150, right: 0, child: ModuleWidget()) : SizedBox(),

        ]);
      }),
    );
  }
}

class ParcelShimmer extends StatelessWidget {
  final bool isEnabled;
  ParcelShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
        childAspectRatio: (1/(ResponsiveHelper.isMobile(context) ? 0.15 : 0.20)),
        crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
      ),
      itemCount: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: isEnabled,
            child: Row(children: [

              Container(
                height: 50, width: 50, alignment: Alignment.center,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(height: 15, width: 200, color: Colors.grey[300]),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(height: 15, width: 100, color: Colors.grey[300]),
              ])),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Icon(Icons.keyboard_arrow_right),

            ]),
          ),
        );
      },
    );
  }
}

