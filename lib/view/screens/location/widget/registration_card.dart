import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationCard extends StatelessWidget {
  final bool isStore;
  const RegistrationCard({@required this.isStore});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [

      ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
        child: Opacity(opacity: 0.05, child: Image.asset(Images.landing_bg, height: 200, width: context.width, fit: BoxFit.fill)),
      ),

      Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
          color: Theme.of(context).primaryColor.withOpacity(0.05),
        ),
        child: Row(children: [
          Expanded(flex: 6, child: Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                isStore ? 'become_a_seller'.tr : 'join_as_a_delivery_man'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Text(
                isStore ? 'register_as_seller_and_open_shop_in'.tr + AppConstants.APP_NAME + 'to_start_your_business'.tr
                    : 'register_as_delivery_man_and_earn_money'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall), textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              CustomButton(
                buttonText: 'register'.tr, fontSize: Dimensions.fontSizeSmall,
                width: 100, height: 40,
                onPressed: () async {
                  String _url = isStore ? '${AppConstants.BASE_URL}/store/apply' : '${AppConstants.BASE_URL}/deliveryman/apply';
                  if(await canLaunch(_url)) {
                    launch(_url);
                  }
                },
              ),
            ]),
          )),
          Expanded(flex: 4, child: Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Image.asset(isStore ? Images.landing_store_open : Images.landing_delivery_man, height: 200, width: 200),
          )),
        ]),
      ),

    ]);
  }
}
