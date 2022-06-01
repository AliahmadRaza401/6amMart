import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tab;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../main.dart';
import 'Colors.dart';
import 'constant.dart';

String convertDate(date) {
  try {
    return date != null ? DateFormat(dateFormat).format(DateTime.parse(date)) : '';
  } catch (e) {
    print(e);
    return '';
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

void redirectUrl(url) async {
  await url_launcher.launch(url);
}

Future<void> launchUrl(String url) async {
  try {
    await custom_tab.launch(
      url,
      customTabsOption: custom_tab.CustomTabsOption(
        toolbarColor: primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: custom_tab.CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: custom_tab.SafariViewControllerOption(
        preferredBarTintColor: primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: custom_tab.SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

Future<void> setDynamicStatusBarColor() async {
  await Future.delayed(Duration(milliseconds: 200));
  setStatusBarColor(appStore.isDarkMode ? appBackGroundColor : white);
}

InputDecoration inputDecoration(
  BuildContext context,
  String? hint, {
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool prefix = false,
  bool suffix = false,
  VoidCallback? onIconTap,
  double? borderRadius,
}) {
  return InputDecoration(
    prefixIcon: prefix ? prefixIcon.paddingAll(12) : null,
    suffixIcon: suffix ? suffixIcon.onTap(() => onIconTap?.call()).paddingAll(12) : null,
    labelText: hint,
    labelStyle: secondaryTextStyle(),
    enabledBorder: OutlineInputBorder(
      gapPadding: 0,
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide(color: primaryColor, width: 1.0),
    ),
    fillColor: context.cardColor,
    filled: true,
  );
}

int findMiddleFactor(int n) {
  List<int?> num = [];
  for (int i = 1; i <= n; i++) {
    if (n % i == 0 && i > 1 && i < 20) {
      num.add(i);
    }
  }
  return num[num.length ~/ 2]!;
}

String getWishes() {
  if (DateTime.now().hour > 0 && DateTime.now().hour < 12) {
    return 'Good Morning';
  } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 16) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}
