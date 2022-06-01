import 'package:sixam_mart/controller/search_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/screens/search/widget/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterWidget extends StatelessWidget {
  final double maxValue;
  final bool isStore;
  FilterWidget({@required this.maxValue, @required this.isStore});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: 600,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: GetBuilder<SearchController>(builder: (searchController) {
          return SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Icon(Icons.close, color: Theme.of(context).disabledColor),
                  ),
                ),
                Text('filter'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                CustomButton(
                  onPressed: () {
                    searchController.resetFilter();
                  },
                  buttonText: 'reset'.tr, transparent: true, width: 65,
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text('sort_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              GridView.builder(
                itemCount: searchController.sortList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 3 : 2,
                  childAspectRatio: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      searchController.setSortIndex(index);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: searchController.sortIndex == index ? Colors.transparent
                            : Theme.of(context).disabledColor),
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: searchController.sortIndex == index ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor.withOpacity(0.1),
                      ),
                      child: Text(
                        searchController.sortList[index],
                        textAlign: TextAlign.center,
                        style: robotoMedium.copyWith(
                          color: searchController.sortIndex == index ? Colors.white : Theme.of(context).hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text('filter_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              (Get.find<SplashController>().configModel.toggleVegNonVeg
              && Get.find<SplashController>().configModel.moduleConfig.module.vegNonVeg) ? CustomCheckBox(
                title: 'veg'.tr,
                value: searchController.veg,
                onClick: () => searchController.toggleVeg(),
              ) : SizedBox(),
              (Get.find<SplashController>().configModel.toggleVegNonVeg
              && Get.find<SplashController>().configModel.moduleConfig.module.vegNonVeg) ? CustomCheckBox(
                title: 'non_veg'.tr,
                value: searchController.nonVeg,
                onClick: () => searchController.toggleNonVeg(),
              ) : SizedBox(),
              CustomCheckBox(
                title: isStore ? Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                    ? 'currently_opened_restaurants'.tr : 'currently_opened_stores'.tr : 'currently_available_items'.tr,
                value: searchController.isAvailableItems,
                onClick: () {
                  searchController.toggleAvailableItems();
                },
              ),
              CustomCheckBox(
                title: isStore ? Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                    ? 'discounted_restaurants'.tr : 'discounted_stores'.tr : 'discounted_items'.tr,
                value: searchController.isDiscountedItems,
                onClick: () {
                  searchController.toggleDiscountedItems();
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              isStore ? SizedBox() : Column(children: [
                Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                RangeSlider(
                  values: RangeValues(searchController.lowerValue, searchController.upperValue),
                  max: maxValue.toInt().toDouble(),
                  min: 0,
                  divisions: maxValue.toInt(),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  labels: RangeLabels(searchController.lowerValue.toString(), searchController.upperValue.toString()),
                  onChanged: (RangeValues rangeValues) {
                    searchController.setLowerAndUpperValue(rangeValues.start, rangeValues.end);
                  },
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              ]),

              Text('rating'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              Container(
                height: 30, alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => searchController.setRating(index + 1),
                      child: Icon(
                        searchController.rating < (index + 1) ? Icons.star_border : Icons.star,
                        size: 30,
                        color: searchController.rating < (index + 1) ? Theme.of(context).disabledColor
                            : Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),

              CustomButton(
                buttonText: 'apply_filters'.tr,
                onPressed: () {
                  if(isStore) {
                    searchController.sortStoreSearchList();
                  }else {
                    searchController.sortItemSearchList();
                  }
                  Get.back();
                },
              ),

            ]),
          );
        }),
      ),
    );
  }
}
