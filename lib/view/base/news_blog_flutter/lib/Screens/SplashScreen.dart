import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/main.dart';

import 'DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );

    _animationController.forward();

    _animationController.addStatusListener((status) async {
      if (_animationController.isCompleted) {
        setState(() {
          opacity = 1.0;
        });
        await Future.delayed(const Duration(seconds: 1));
        appLocalization = AppLocalizations.of(context);

        if (!getBoolAsync(IS_REMEMBERED, defaultValue: true)) {
          logout(context);
        } else {
          if (appStore.isLoggedIn) {
            appStore.setUserProfile(getStringAsync(PROFILE_IMAGE));
            appStore.setUserId(getIntAsync(USER_ID));
            appStore.setUserEmail(getStringAsync(USER_EMAIL));
            appStore.setFirstName(getStringAsync(FIRST_NAME));
            appStore.setLastName(getStringAsync(LAST_NAME));
            appStore.setUserLogin(getStringAsync(USER_LOGIN));
          }
          DashboardScreen().launch(context, isNewTask: true);
        }
      }
    });

    setStatusBarColor(primaryColor, statusBarBrightness: Brightness.light);
    /*allowPreFetched = getBoolAsync(allowPreFetchedPref, defaultValue: true);

    await Future.delayed(Duration(seconds: 5));
    appLocalization = AppLocalizations.of(context);

    if (!getBoolAsync(IS_REMEMBERED, defaultValue: true)) {
      logout(context);
    } else {
      if (appStore.isLoggedIn) {
        appStore.setUserProfile(getStringAsync(PROFILE_IMAGE));
        appStore.setUserId(getIntAsync(USER_ID));
        appStore.setUserEmail(getStringAsync(USER_EMAIL));
        appStore.setFirstName(getStringAsync(FIRST_NAME));
        appStore.setLastName(getStringAsync(LAST_NAME));
        appStore.setUserLogin(getStringAsync(USER_LOGIN));
      }
      DashboardScreen().launch(context, isNewTask: true);
    }*/
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? appBackGroundColor : Colors.white, statusBarBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        height: context.height(),
        width: context.width(),
        color: primaryColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _animation,
              child: Image.asset(ic_logo_rb, width: 120, height: 120),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: opacity,
                  duration:  Duration(milliseconds: 700),
                  child: Text(AppName, style: boldTextStyle(size: 32, color: Colors.white)),
                ),
                4.height,
                AnimatedOpacity(
                  opacity: opacity,
                  duration:  Duration(milliseconds: 700),
                  child: Text(appLocalization!.translate("lbl_splash_subtitle"), style: boldTextStyle(size: 18, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
