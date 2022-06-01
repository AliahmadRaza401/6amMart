import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/CategoryModel.dart';
import 'package:news_flutter/Model/DashboardModel.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/CategoryFragment.dart';
import 'package:news_flutter/Screens/LatestNewslistScreen.dart';
import 'package:news_flutter/Screens/NewsListScreen.dart';
import 'package:news_flutter/Screens/NotificationListScreen.dart';
import 'package:news_flutter/Screens/SearchFragment.dart';
import 'package:news_flutter/Screens/VoiceSearchScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/FeaturedNewsHomeWidget.dart';
import 'package:news_flutter/components/NewsListViewWidget.dart';
import 'package:news_flutter/components/SeeAllButtonWidget.dart';
import 'package:news_flutter/components/WeatherWidget.dart';

import '../app_localizations.dart';
import '../main.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> with TickerProviderStateMixin {
  int page = 1;

  var mProfileImage = '';

  bool showNoData = false;
  bool isLoadingSwipeToRefresh = false;
  bool isDashboardDataLoaded = false;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    page = 1;
    await setDataFromDB();

    var g = appStore.userProfileImage.validate();
    if (g.isNotEmpty) {
      mProfileImage = g;
    } else {
      mProfileImage = getStringAsync(AVATAR);
    }
  }

  Future<void> setDataFromDB() async {
    if (allowPreFetched) {
      String dashboardPref = getStringAsync(dashboardData);

      await Future.delayed(Duration(milliseconds: 200));

      if (dashboardPref.isNotEmpty) {
        var res = jsonDecode(dashboardPref);
        await setDashboardRes(DashboardModel.fromJson(res));
      }
    }
  }

  Future<void> setDashboardRes(DashboardModel res) async {
    await setValue(dashboardData, jsonEncode(res));
    await setValue(featureData, jsonEncode(res.featurePost));
    if (page == 1) {
      if (res.socialLink != null) {
        await setValue(WHATSAPP, res.socialLink!.whatsapp.toString());
        await setValue(FACEBOOK, res.socialLink!.facebook.toString());
        await setValue(TWITTER, res.socialLink!.twitter.toString());
        await setValue(INSTAGRAM, res.socialLink!.instagram.toString());
        await setValue(CONTACT, res.socialLink!.contact.toString());
        await setValue(PRIVACY_POLICY, res.socialLink!.privacyPolicy.toString());
        await setValue(TERMS_AND_CONDITIONS, res.socialLink!.termCondition.toString());
        await setValue(COPYRIGHT_TEXT, res.socialLink!.copyrightText.toString());
      }

      /// if you want language set under the app so comment this two line other wise uncomment..
      if (!isLanguageEnable) {
        await setValue(LANGUAGE, res.appLang.toString());
        appStore.setLanguage(res.appLang.toString());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast('Press back again to exit app.');
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await 2.seconds.delay;
          setState(() {});
        },
        child: Scaffold(
          body: FutureBuilder<DashboardModel>(
            initialData: getStringAsync(dashboardData).isNotEmpty ? DashboardModel.fromJson(jsonDecode(getStringAsync(dashboardData))) : null,
            future: getDashboardApi(page),
            builder: (context, snap) {
              if (snap.hasData || snap.hasError) {
                DashboardModel model = snap.hasData ? snap.data! : DashboardModel.fromJson(jsonDecode(getStringAsync(dashboardData)));

                setDashboardRes(model);

                return Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: context.statusBarHeight + 8),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (snap.hasData) WeatherWidget(),
                            Spacer(),
                            IconButton(
                              icon: cachedImage(ic_notification, width: 22, height: 22, color: appStore.isDarkMode ? Colors.white : Colors.black),
                              onPressed: () {
                                NotificationListScreen().launch(context);
                              },
                            ),
                          ],
                        ),
                        Container(
                          width: context.width(),
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(28)),
                          child: Row(
                            children: [
                              cachedImage(ic_search, width: 22, color: Colors.grey.withOpacity(0.8)).paddingRight(8),
                              Text(appLocalization!.translate('lbl_search_news'), style: secondaryTextStyle(size: 16)).expand(),

                              Icon(Icons.mic,color: primaryColor).onTap(() {
                                VoiceSearchScreen(isHome: true).launch(context);

                              }),
                            ],
                          ),
                        ).onTap(() {
                          SearchFragment().launch(
                            context,
                            pageRouteAnimation: PageRouteAnimation.SlideBottomTop,
                            duration: Duration(milliseconds: 500),
                          );
                        }, highlightColor: Colors.transparent, splashColor: Colors.transparent, borderRadius: BorderRadius.circular(28)),
                        if (getStringAsync(featureData).isNotEmpty || model.featurePost.validate().isNotEmpty)
                          FeaturedNewsHomeWidget(
                            appLocalization: appLocalization,
                            recentNewsListing: model.featurePost ?? jsonDecode(getStringAsync(featureData)).map<PostModel>((e) => PostModel.fromJson(e)).toList(),
                            width: context.width(),
                          ),
                        16.height,
                        FutureBuilder<List<CategoryModel>>(
                          initialData: getStringAsync(categoryData).isNotEmpty ? jsonDecode(getStringAsync(categoryData)).map<CategoryModel>((e) => CategoryModel.fromJson(e)).toList() : null,
                          future: getCategories(page: page, perPage: 5),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              List<CategoryModel> categoryItems = snap.hasData ? snap.data! : jsonDecode(getStringAsync(categoryData)).map<CategoryModel>((e) => CategoryModel.fromJson(e)).toList();
                              if (categoryItems.validate().isNotEmpty) {
                                setValue(categoryData, jsonEncode(categoryItems));
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          appLocalization.translate('categories'),
                                          style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: 20),
                                        ).expand(),
                                        SeeAllButtonWidget(
                                          onTap: () {
                                            CategoryFragment(isTab: false).launch(context);
                                          },
                                          widget: Text(appLocalization.translate('see_All'), style: primaryTextStyle(color: primaryColor, size: textSizeSMedium)),
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 16),
                                    HorizontalList(
                                      itemCount: categoryItems.take(5).length,
                                      padding: EdgeInsets.all(16),
                                      itemBuilder: (context, index) {
                                        CategoryModel data = categoryItems[index];
                                        return GestureDetector(
                                          onTap: () {
                                            NewsListScreen(title: data.name, id: data.cat_ID, categoryModel: data).launch(
                                              context,
                                              pageRouteAnimation: PageRouteAnimation.Fade,

                                            );
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(defaultRadius),
                                              color: context.cardColor,
                                            ),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            child: Stack(
                                              children: [
                                                Hero(
                                                  tag: data,
                                                  child: cachedImage(data.image.validate(), height: 100, width: 160, fit: BoxFit.cover),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                                      stops: [0.0, 1.0],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 8,
                                                  left: 8,
                                                  right: 8,
                                                  child: Text(
                                                    parseHtmlString(data.name.validate()),
                                                    style: boldTextStyle(size: textSizeLargeMedium, color: Colors.white),
                                                  ).paddingAll(8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            }
                            return SizedBox();
                          },
                        ),
                        if (model.recentPost.validate().isNotEmpty)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    appLocalization.translate('latest_News'),
                                    style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: 20),
                                  ),
                                  SeeAllButtonWidget(
                                    onTap: () {
                                      LatestNewsListScreen(title: appLocalization.translate('latest_News')).launch(context);
                                    },
                                    widget: Text(
                                      appLocalization.translate('see_All'),
                                      style: primaryTextStyle(color: primaryColor, size: textSizeSMedium),
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 16),
                              NewsListViewWidget(latestNewsList: model.recentPost.validate())
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              }
              return Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center();
              // return DashboardNewsItemShimmer();
            },
          ),
        ),
      ),
    );
  }
}
