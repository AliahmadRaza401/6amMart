import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/LanguageModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/AboutUsScreen.dart';
import 'package:news_flutter/Screens/ChangePasswordScreen.dart';
import 'package:news_flutter/Screens/ChooseDetailPageVariantScreen.dart';
import 'package:news_flutter/Screens/ProfileFragment.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BackWidget.dart';

import '../main.dart';

class SettingScreen extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  List<int> fontSizeList = [8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34];
  int? fontSize = 18;
  bool isAdsLoading = false;
  int selectedLanguage = 0;
  int selectedTTsLang = 0;
  String? language;
  String? ttsLang;

  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    myBanner = buildBannerAd()..load();
    fontSize = getIntAsync(FONT_SIZE, defaultValue: 18);
    selectedLanguage = getIntAsync(SELECTED_LANGUAGE_INDEX);
    selectedTTsLang = getIntAsync(TTS_SELECTED_LANGUAGE_INDEX);
    language = Language.getLanguages()[selectedLanguage].name;
    ttsLang = Language.getLanguagesForTTS()[selectedTTsLang].name;
    setState(() {});
    if (await isNetworkAvailable()) {
      setState(
        () {
          isAdsLoading = isAdsLoading;
        },
      );
    }
    setState(() {});
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? bannerAdIdForAndroid : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          //
        },
      ),
      request: AdRequest(),
    );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  void handlePreFetching(bool v) async {
    allowPreFetched = v;

    await setValue(allowPreFetchedPref, allowPreFetched);

    if (!allowPreFetched) {
      await removeKey(dashboardData);
      await removeKey(categoryData);
      await removeKey(videoListData);
      await removeKey(bookmarkData);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      //backgroundColor: context.cardColor,
      appBar: appBarWidget(appLocalization.translate('settings'), center: true, color: appStore.isDarkMode ? card_color_dark : white, elevation: 0.2, backWidget: BackWidget(color: context.iconColor)),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: context.height(),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    SettingSection(
                      title: Text(appLocalization.translate('account_setting'), style: boldTextStyle(size: 22)),
                      headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                      divider: Divider(color: Colors.transparent, height: 0.0),
                      items: [
                        SettingItemWidget(
                          title: appLocalization.translate('edit_profile'),
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: Theme.of(context).textTheme.subtitle2!.color),
                          onTap: () {
                            ProfileFragment().launch(context);
                          },
                        ),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        SettingItemWidget(
                          title: '${appLocalization.translate('change_Password')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: Theme.of(context).textTheme.subtitle2!.color),
                          onTap: () {
                            ChangePasswordScreen().launch(context);
                          },
                        ),
                      ],
                    ).visible(appStore.isLoggedIn),
                    SettingSection(
                      title: Text(appLocalization.translate('notification_setting'), style: boldTextStyle(size: 22)),
                      headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                      divider: Divider(color: Colors.transparent, height: 0.0),
                      items: [
                        Observer(
                          builder: (_) => SettingItemWidget(
                            title: '${appStore.isNotificationOn ? appLocalization.translate('disable') : appLocalization.translate('enable')} ${appLocalization.translate('push_notification')}',
                            titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                            trailing: Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                activeColor: primaryColor,
                                value: appStore.isNotificationOn,
                                onChanged: (v) async {
                                  appStore.setNotification(v);
                                },
                              ),
                            ),
                            onTap: () async {
                              appStore.setNotification(
                                !getBoolAsync(IS_NOTIFICATION_ON, defaultValue: false),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SettingSection(
                      title: Text(appLocalization.translate('app_setting'), style: boldTextStyle(size: 22)),
                      headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                      divider: Divider(color: Colors.transparent, height: 0.0),
                      items: [
                        SettingItemWidget(
                          title: appStore.isDarkMode ? appLocalization.translate('night_Mode') : appLocalization.translate('light_Mode'),
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: primaryColor,
                              value: appStore.isDarkMode,
                              onChanged: (v) async {
                                appStore.setDarkMode(!appStore.isDarkMode);
                              },
                            ),
                          ),
                          onTap: () async {
                            appStore.setDarkMode(!appStore.isDarkMode);
                          },
                        ),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        SettingItemWidget(
                          title: '${appLocalization.translate('pre_fetching')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: primaryColor,
                              value: allowPreFetched,
                              onChanged: (v) async {
                                handlePreFetching(v);
                              },
                            ),
                          ),
                          onTap: () async {
                            handlePreFetching(!allowPreFetched);
                          },
                        ),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        SettingItemWidget(
                          title: '${appLocalization.translate('font_size')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Container(
                            decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: context.cardColor),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isDense: true,
                                value: fontSize,
                                underline: 0.height,
                                dropdownColor: appStore.isDarkMode ? card_background_black : white_color,
                                icon: Icon(Icons.keyboard_arrow_down_sharp, color: Theme.of(context).textTheme.subtitle2!.color).paddingLeft(10),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    fontSize = newValue;
                                    setValue(FONT_SIZE, fontSize);
                                  });
                                },
                                items: fontSizeList.map(
                                  (font) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        font.toString() + appLocalization.translate('lbl_px'),
                                        style: primaryTextStyle(),
                                      ).paddingOnly(left: 8),
                                      value: font,
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        SettingItemWidget(
                          title: '${appLocalization.translate('text_to_speech')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Container(
                            decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: context.cardColor),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isDense: true,
                                icon: Icon(Icons.keyboard_arrow_down_sharp, color: Theme.of(context).textTheme.subtitle2!.color).paddingLeft(10),
                                value: Language.getLanguagesForTTS()[selectedTTsLang].name,
                                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                onChanged: (dynamic newValue) async {
                                  for (var i = 0; i < Language.getLanguagesForTTS().length; i++) {
                                    if (newValue == Language.getLanguagesForTTS()[i].name) {
                                      selectedTTsLang = i;
                                      setState(() {});
                                    }
                                  }
                                  // await setValue(TTS_SELECTED_LANGUAGE_CODE, Language.getLanguagesForTTS()[selectedTTsLang].languageCode);
                                  await setValue(TTS_SELECTED_LANGUAGE_INDEX, selectedTTsLang);
                                  await setValue(TEXT_TO_SPEECH_LANG, selectedTTsLang.toString());

                                  setState(() {});
                                  toast("${Language.getLanguagesForTTS()[selectedTTsLang].name} is Default language for Text to Speech");
                                },
                                items: Language.getLanguagesForTTS().map(
                                  (ttsLanguage) {
                                    return DropdownMenuItem(
                                      child: Row(
                                        children: <Widget>[
                                          8.width,
                                          Text(ttsLanguage.name, style: primaryTextStyle()),
                                        ],
                                      ),
                                      value: ttsLanguage.name,
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        SettingItemWidget(
                          title: '${appLocalization.translate('language')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Container(
                            decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: context.cardColor),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isDense: true,
                                icon: Icon(Icons.keyboard_arrow_down_sharp, color: Theme.of(context).textTheme.subtitle2!.color).paddingLeft(10),
                                value: Language.getLanguages()[selectedLanguage].name,
                                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                onChanged: (dynamic newValue) async {
                                  for (var i = 0; i < Language.getLanguages().length; i++) {
                                    if (newValue == Language.getLanguages()[i].name) {
                                      selectedLanguage = i;
                                      setState(() {});
                                    }
                                  }

                                  await setValue(SELECTED_LANGUAGE_CODE, Language.getLanguages()[selectedLanguage].languageCode);
                                  await setValue(SELECTED_LANGUAGE_INDEX, selectedLanguage);

                                  await setValue(LANGUAGE, selectedLanguage.toString());
                                  appStore.setLanguage(Language.getLanguages()[selectedLanguage].languageCode.toString().validate());
                                  setState(() {});
                                },
                                items: Language.getLanguages().map(
                                  (language) {
                                    return DropdownMenuItem(
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(language.flag, width: 24, height: 24),
                                          SizedBox(width: 10),
                                          Text(language.name, style: primaryTextStyle()),
                                        ],
                                      ),
                                      value: language.name,
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ).visible(isLanguageEnable),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        SettingItemWidget(
                          title: '${appLocalization.translate('choose_detail_page_variant')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Row(
                            children: [
                              Icon(Icons.check_circle, color: context.iconColor, size: 16),
                              2.width,
                              Text(appLocalization.translate('lbl_variant') + ' ${getIntAsync(DETAIL_PAGE_VARIANT) == 0 ? '1' : getIntAsync(DETAIL_PAGE_VARIANT)}', style: boldTextStyle()),
                            ],
                          ),
                          onTap: () async {
                            bool? res = await ChooseDetailPageVariantScreen().launch(context);
                            if (res ?? false) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    SettingSection(
                      //TODO Translate
                      title: Text(appLocalization.translate("lbl_setting_about"), style: boldTextStyle(size: 22)),
                      headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                      divider: Divider(color: Colors.transparent, height: 0.0),
                      items: [
                        SettingItemWidget(
                          title: '${appLocalization.translate('about')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: Theme.of(context).textTheme.subtitle2!.color),
                          onTap: () async {
                            AboutUsScreen().launch(context);
                          },
                        ),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        SettingItemWidget(
                          title: '${appLocalization.translate('lbl_website')}',
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                          trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: Theme.of(context).textTheme.subtitle2!.color),
                          onTap: () async {
                            launchUrl('https://wordpress.iqonic.design/product/mobile/news-blog/');
                          },
                        ),
                        Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                        if (appStore.isLoggedIn)
                          SettingItemWidget(
                            title: appLocalization.translate('logout'),
                            titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                            trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: Theme.of(context).textTheme.subtitle2!.color),
                            onTap: () {
                              showConfirmDialogCustom(
                                context,
                                title: appLocalization.translate('logout_confirmation'),
                                primaryColor: primaryColor,
                                onAccept: (c) async {
                                  logout(context);
                                },
                                dialogType: DialogType.CONFIRMATION,
                                negativeText: appLocalization.translate('no'),
                                positiveText: appLocalization.translate('yes'),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: isAdsLoading
                  ? Container(
                      width: context.width(),
                      height: AdSize.banner.height.toDouble(),
                      child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
