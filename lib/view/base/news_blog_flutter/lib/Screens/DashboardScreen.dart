import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Chat_Module/chat/admin/adminChatList.dart';
import 'package:news_flutter/Chat_Module/chat/chat_counselor_screen.dart';
import 'package:news_flutter/Chat_Module/chat/chat_welcome_screen.dart';
import 'package:news_flutter/Chat_Module/chat/supportMan/supportMan_chatlist.dart';
import 'package:news_flutter/Chat_Module/chat/user/userChat_list.dart';
import 'package:news_flutter/Screens/BookmarkFragment.dart';
import 'package:news_flutter/Screens/HomeFragment.dart';
import 'package:news_flutter/Screens/SignInScreen.dart';
import 'package:news_flutter/Screens/VideoListScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/ProfileWidget.dart';
import 'package:transition_pages_jr/transition_pages_jr.dart';

import '../main.dart';

class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int selectedIndex = 0;

  List<Widget> pages = [
    HomeFragment(),
    BookmarkFragment(isTab: true),
    VideoListScreen(),
  ];

  @override
  void initState() {
    super.initState();

    getUser();
    afterBuildCreated(() {
      init();
    });
  }

  bool chatloading = true;

  var logStatus, uname, uid;
  var userType;
  getUser() async {
    // await checkUserType();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        logStatus = preferences.getString("logStatus");
        uname = preferences.getString("username");
        uid = preferences.getString("uid");
        userType = preferences.getString("userType");
      });
    }
    print(logStatus.toString());
    print(userType.toString());
    print('userType Dashboard>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: $userType');
    setState(() {
      chatloading = false;
    });

  }


  init() async {
    bookmarkStore.getBookMarkList();
  }

  //region User Info sheet
  profileInfoSheet(BuildContext context, AppLocalizations appLocal) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // transitionAnimationController: _controller,
      builder: (_) {
        return ProfileWidget();
      },
    );
  }

  //endregion

  @override
  void dispose() {
    super.dispose();
  }

  gotoPage() {
    print('userType_____________________________________: $userType');

    if (logStatus.toString() == "true" && uid != null) {
      if (userType == "admin") {
        return AdminChatList();
      } else if (userType == "supportMan") {
        return SupportManChatList();
      } else {
        return UserChatList();
      }
    } else {
      return ChatWelcomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Observer(
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: selectedIndex == 2
              ? gotoPage()
              : IndexedStack(
                  children: pages,
                  index: selectedIndex,
                ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index == 3) {
                profileInfoSheet(context, appLocalization);
              } else {
                if (index == 1 && !appStore.isLoggedIn) {
                  SignInScreen().launch(context);
                } else {
                  selectedIndex = index;
                  print('selectedIndex: $selectedIndex');
                  setState(() {});
                }
              }
            },
            backgroundColor: appStore.isDarkMode ? card_color_dark : white,
            currentIndex: selectedIndex,
            type: BottomNavigationBarType.fixed,
            unselectedFontSize: 14,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 14,
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset(ic_home,
                    width: 22,
                    height: 22,
                    color: Theme.of(context).textTheme.headline6!.color,
                    filterQuality: FilterQuality.high),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(ic_home_bold,
                            width: 22, height: 22, color: primaryColor)
                        .paddingBottom(4),
                    Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset(ic_bookmark,
                    width: 22,
                    height: 22,
                    color: Theme.of(context).textTheme.headline6!.color),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(ic_bookmark_bold,
                            width: 22, height: 22, color: primaryColor)
                        .paddingBottom(4),
                    Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset(ic_email,
                    width: 22,
                    height: 22,
                    color: Theme.of(context).textTheme.headline6!.color),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(ic_email,
                            width: 22, height: 22, color: primaryColor)
                        .paddingBottom(4),
                    Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset(ic_video,
                    width: 22,
                    height: 22,
                    color: Theme.of(context).textTheme.headline6!.color),
                activeIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(ic_video_bold,
                            width: 22, height: 22, color: primaryColor)
                        .paddingBottom(4),
                    Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: appStore.isLoggedIn &&
                        appStore.userProfileImage.validate().isNotEmpty
                    ? cachedImage(appStore.userProfileImage.validate(),
                            fit: BoxFit.cover, width: 28, height: 28)
                        .cornerRadiusWithClipRRect(100)
                    : Image.asset(ic_profile,
                        width: 22,
                        height: 22,
                        color: Theme.of(context).textTheme.headline6!.color),
                activeIcon: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.2)),
                  child: appStore.isLoggedIn &&
                          appStore.userProfileImage.validate().isNotEmpty
                      ? cachedImage(appStore.userProfileImage.validate(),
                          fit: BoxFit.cover, width: 28, height: 28)
                      : Image.asset(ic_profile_bold,
                          width: 22, height: 22, color: primaryColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
