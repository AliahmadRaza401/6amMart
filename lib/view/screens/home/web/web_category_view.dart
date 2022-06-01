import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  WebCategoryView({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(Dimensions.RADIUS_SMALL)),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200], blurRadius: 5, spreadRadius: 1)]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL, left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Text('categories'.tr, style: robotoMedium.copyWith(fontSize: 24)),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        categoryController.categoryList != null ? ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categoryController.categoryList.length > 10 ? 11 : categoryController.categoryList.length,
          itemBuilder: (context, index) {

            if(index == 10) {
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  child: Row(children: [

                    Container(
                      height: 65, width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(Icons.arrow_downward, color: Theme.of(context).cardColor),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                    Text(
                      'view_all'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),

                  ]),
                ),
              );
            }

            return InkWell(
              onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                categoryController.categoryList[index].id, categoryController.categoryList[index].name,
              )),
              child: Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                child: Row(children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    child: CustomImage(
                      image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                      height: 65, width: 70, fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Expanded(child: Text(
                    categoryController.categoryList[index].name,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  )),

                ]),
              ),
            );
          },
        ) : WebCategoryShimmer(categoryController: categoryController),

      ]),
    );
  }
}

class WebCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  WebCategoryShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: categoryController.categoryList == null,
            child: Row(children: [

              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.grey[300]),
                height: 65, width: 70,
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Container(height: 15, width: 150, color: Colors.grey[300]),

            ]),
          ),
        );
      },
    );
  }
}

