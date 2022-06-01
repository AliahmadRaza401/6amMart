import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/SettingItem.dart';
import 'package:news_flutter/Network/AuthService.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/DashboardScreen.dart';
import 'package:news_flutter/Screens/ProfileFragment.dart';
import 'package:news_flutter/Screens/SettingScreen.dart';
import 'package:news_flutter/Screens/SignInScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BounceTapWidget.dart';
import 'package:news_flutter/components/OTPDialogBox.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../main.dart';

class ProfileWidget extends StatefulWidget {
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  int? _selectedIndex;

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    log("Image:${appStore.userProfileImage}");
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    List<SettingItem> settingItem = [
      SettingItem(settingName: appLocalization.translate('contact_us'), settingImage: ic_email),
      SettingItem(settingName: appLocalization.translate('share'), settingImage: ic_send),
      SettingItem(settingName: appLocalization.translate('settings'), settingImage: ic_Setting)
    ];

    return SingleChildScrollView(
      child: Container(
        height: context.height() * 0.50,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: context.cardColor,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
                ),
                if (!appStore.isLoggedIn)
                  Stack(
                    children: [
                      Row(
                        children: [
                          AppButton(
                            color: primaryColor,
                            elevation: 0,
                            text: appLocalization.translate('sign_In'),
                            textStyle: boldTextStyle(color: Colors.white),
                            onTap: () {
                              finish(context);
                              SignInScreen().launch(context);
                            },
                          ).expand(),
                          32.width,
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            child: GoogleLogoWidget(size: 20).paddingAll(8).onTap(() async {
                              appStore.setLoading(true);

                              await LogInWithGoogle().then((user) async {
                                appStore.setLoading(false);

                                DashboardScreen().launch(context, isNewTask: true);
                              }).catchError((e) {
                                appStore.setLoading(false);
                                throw errorSomethingWentWrong;
                              });
                            }),
                          ),
                          8.width,
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Image.asset(ic_CallRing, color: primaryColor, width: 30, height: 30),
                            ).onTap(() async {
                              await showInDialog(
                                context,
                                builder: (_) => OTPDialogBox(),
                                shape: dialogShape(),
                                backgroundColor: context.scaffoldBackgroundColor,
                                barrierDismissible: false,
                              ).catchError((e) {
                                toast(e.toString());
                              });
                            }),
                          ),
                          if (isIOS)
                            CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              child: Image.asset(ic_Apple, color: appStore.isDarkMode ? white : black, width: 30, height: 30).paddingAll(8),
                            ).paddingLeft(8).onTap(
                              () async {
                                appStore.setLoading(true);

                                await appleSignIn().then((value) {
                                  appStore.setLoading(false);

                                  DashboardScreen().launch(context, isNewTask: true);
                                }).catchError((e) {
                                  toast(e.toString());
                                  appStore.setLoading(false);
                                  setState(() {});
                                });
                              },
                            ),
                        ],
                      ).paddingTop(16),
                      //CircularProgressIndicator().center().visible(appStore.isLoading),
                    ],
                  ),
                if (appStore.isLoggedIn)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                         cachedImage(appStore.userProfileImage.toString(), height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),

                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${appStore.userFirstName.validate()} ${appStore.userLastName.validate()}", style: boldTextStyle(size: 20)),
                              4.height,
                              Text(appStore.userEmail.validate(), style: secondaryTextStyle(size: 16)),
                            ],
                          ),
                        ],
                      ).onTap(() {
                        finish(context);
                        ProfileFragment().launch(context);
                      }),
                      Image.asset(ic_Logout, width: 30, height: 30, color: Theme.of(context).textTheme.headline6!.color).onTap(() {
                        showConfirmDialogCustom(
                          context,
                          title: appLocalization.translate('logout_confirmation'),
                          primaryColor: primaryColor,
                          onAccept: (c) async {
                            finish(context);
                            logout(context);
                          },
                          dialogType: DialogType.CONFIRMATION,
                          negativeText: appLocalization.translate('no'),
                          positiveText: appLocalization.translate('yes'),
                        );
                      })
                    ],
                  ).paddingTop(16),
                Divider(thickness: 0.7),
                Wrap(
                  children: List.generate(
                    settingItem.length,
                    (index) => BounceTapWidget(
                      child: Container(
                        height: 100,
                        width: context.width() * 0.35 - 24,
                        decoration: BoxDecoration(
                          color: (_selectedIndex != null && _selectedIndex == index) ? (appStore.isDarkMode ? appBackGroundColor : gray.withOpacity(0.1)) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(settingItem[index].settingImage.validate(), width: 30, height: 30, color: primaryColor),
                            8.height,
                            Text(settingItem[index].settingName.validate(), style: boldTextStyle()),
                          ],
                        ),
                      ),
                      onTap: () async {
                        _onSelected(index);

                        if (index == 0) {
                          const uri = 'mailto:$mailto';
                          if (await url_launcher.canLaunch(uri)) {
                            await url_launcher.launch(uri);
                          } else {
                            throw 'Could not launch $uri';
                          }
                        } else if (index == 1) {
                          finish(context);
                          onShareTap(context);
                        } else if (index == 2) {
                          finish(context);
                          SettingScreen().launch(context);
                        }
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${appLocalization.translate("lbl_version")} ${packageInfo!.version}', style: primaryTextStyle(color: Colors.grey.shade500, size: 14)),
                      4.height,
                      Text(companyTagLine, style: primaryTextStyle(color: Colors.grey.shade500, size: 14)),
                    ],
                  ),
                )
              ],
            ),
            Observer(builder: (context) {
              return Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading);
            }),
          ],
        ),
      ),
    );
  }
}
