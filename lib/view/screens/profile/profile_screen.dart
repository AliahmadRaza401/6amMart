import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:sixam_mart/view/screens/profile/widget/profile_button.dart';
import 'package:sixam_mart/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      endDrawer: MenuDrawer(),
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null) ? Center(child: CircularProgressIndicator()) : ProfileBgWidget(
          backButton: true,
          circularImage: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).cardColor),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(child: CustomImage(
              image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                  '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
              height: 100, width: 100, fit: BoxFit.cover,
            )),
          ),
          mainWidget: SingleChildScrollView(physics: BouncingScrollPhysics(), child: FooterView(minHeight:_isLoggedIn ? 0.6 : 0.35,
            child: Center(child: Container(
              width: Dimensions.WEB_MAX_WIDTH, color: Theme.of(context).cardColor,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Column(children: [

                Text(
                  _isLoggedIn ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}' : 'guest'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                SizedBox(height: 30),

                _isLoggedIn ? Row(children: [
                  ProfileCard(title: 'since_joining'.tr, data: '${userController.userInfoModel.memberSinceDays} ${'days'.tr}'),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  ProfileCard(title: 'total_order'.tr, data: userController.userInfoModel.orderCount.toString()),
                ]) : SizedBox(),
                SizedBox(height: _isLoggedIn ? 30 : 0),

                ProfileButton(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                  Get.find<ThemeController>().toggleTheme();
                }),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                _isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
                  return ProfileButton(
                    icon: Icons.notifications, title: 'notification'.tr,
                    isButtonActive: authController.notification, onTap: () {
                    authController.setNotificationActive(!authController.notification);
                  },
                  );
                }) : SizedBox(),
                SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),

                _isLoggedIn ? ProfileButton(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                  Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
                }) : SizedBox(),
                SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),

                ProfileButton(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                  Get.toNamed(RouteHelper.getUpdateProfileRoute());
                }),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(AppConstants.APP_VERSION.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                ]),

              ]),
            )),
          )),
        );
      }),
    );
  }
}
