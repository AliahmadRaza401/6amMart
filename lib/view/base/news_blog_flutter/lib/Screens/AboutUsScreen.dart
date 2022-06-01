import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:package_info/package_info.dart';

import '../app_localizations.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  SharedPreferences? pref;
  var darkMode = false;
  PackageInfo? package;
  var copyrightText = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (getStringAsync(COPYRIGHT_TEXT).isNotEmpty) {
      copyrightText = getStringAsync(COPYRIGHT_TEXT);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: appBarWidget(
        appLocalization.translate('about'),
        color: appStore.isDarkMode ? appBackGroundColor : white,
        center: true,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                ic_logo,
                width: 50,
                height: 50,
              ).cornerRadiusWithClipRRect(defaultRadius),
              8.height,
              Text(
                '$AppName',
                style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: 28),
              ),
              24.height,
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 15,
                    decoration: BoxDecoration(color: primaryColor),
                  ),
                  4.width,
                  Text(appLocalization.translate('about'), style: boldTextStyle(size: 18))
                ],
              ),
              8.height,
              Text(aboutApp, style: secondaryTextStyle(size: textSizeMedium)),
              16.height,
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
                onPressed: () {
                  launchUrl('https://codecanyon.net/item/newz-flutter-news-mobile-app-with-wordpress/27954531?s_rank=9');
                },
                child: Text(appLocalization.translate('lbl_purchase'), style: boldTextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: context.width(),
        height: context.height() * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              appLocalization.translate('follow_us'),
              style: boldTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeMedium),
            ).visible(getStringAsync(WHATSAPP).isNotEmpty),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () => redirectUrl(getStringAsync(INSTAGRAM)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_Inst, height: 35, width: 35),
                  ),
                ).visible(getStringAsync(INSTAGRAM).isNotEmpty),
                InkWell(
                  onTap: () => redirectUrl(getStringAsync(TWITTER)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_Twitter, height: 35, width: 35),
                  ),
                ).visible(getStringAsync(TWITTER).isNotEmpty),
                InkWell(
                  onTap: () => redirectUrl(getStringAsync(FACEBOOK)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_Fb, height: 35, width: 35),
                  ),
                ).visible(getStringAsync(FACEBOOK).isNotEmpty),
                if (getStringAsync(CONTACT).isNotEmpty)
                  InkWell(
                    onTap: () => redirectUrl('tel:${getStringAsync(CONTACT)}'),
                    child: Container(
                      margin: EdgeInsets.only(right: 16.toDouble()),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(ic_CallRing, height: 35, width: 35, color: primaryColor),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  String get aboutApp =>
      "Newz is easily the most user-friendly and lightweight app to quickly get the news you need. The app contains everything you expect from a news app — category based news to choose what you prefer, search features, and comment support. Not only this, but the unique design and animation makes this Flutter and Dart app a dream come true.";
}
