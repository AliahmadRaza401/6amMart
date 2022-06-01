import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Chat_Module/chat/admin/adminChatList.dart';
import 'package:news_flutter/Chat_Module/chat/chat_welcome_screen.dart';
import 'package:news_flutter/Chat_Module/chat/supportMan/supportMan_chatlist.dart';
import 'package:news_flutter/Chat_Module/services/fcm_services.dart';
import 'package:news_flutter/Chat_Module/services/local_notifications.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Screens/NewsDetailScreen.dart';
import 'package:news_flutter/Screens/SplashScreen.dart';
import 'package:news_flutter/Screens/WebViewScreen.dart';
import 'package:news_flutter/Utils/OverlayHandler.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/app_theme.dart';
import 'package:news_flutter/store/AppStore.dart';
import 'package:news_flutter/store/Bookmark/BookmarkStore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:transition_pages_jr/transition_pages_jr.dart';

import 'Model/LanguageModel.dart';

//region Global OverlayEntry
OverlayHandler globalOverlayHandler = OverlayHandler();
//endregion
PackageInfo? packageInfo;

AppStore appStore = AppStore();
BookmarkStore bookmarkStore = BookmarkStore();

int mInterstitialAdCount = 0;

AppLocalizations? appLocalization;

late Language language;
List<Language> languages = Language.getLanguages();

List<Language> ttsLanguage = Language.getLanguagesForTTS();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isMobile) {
    await Firebase.initializeApp();

    await OneSignal.shared.setAppId(mOneSignalAppId);
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      //
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    await LocalNotificationsService.instance.initialize();
    // FirebaseMessaging.onBackgroundMessage(messageHandler);
    FCMServices.fcmGetTokenandSubscribe('user');
  }

  await initialize();

  packageInfo = await PackageInfo.fromPlatform();

  defaultRadius = 12.0;

  appStore.setDarkMode(getBoolAsync(IS_DARK_THEME));
  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));
  appStore.setTTSLanguage(
      getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  String bookmarkString = getStringAsync(WISHLIST_ITEM_LIST);
  if (bookmarkString.isNotEmpty) {
    bookmarkStore.addAllBookmark(jsonDecode(bookmarkString)
        .map<PostModel>((e) => PostModel.fromJson(e))
        .toList());
  }

  runApp(MyApp());
}

Future<void> messageHandler(RemoteMessage event) async {
  print('RemoteMessage event: $event');
  await Firebase.initializeApp();
  LocalNotificationsService.instance.showNotification(
      title: '${event.notification?.title}',
      body: '${event.notification?.body}');

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('RemoteMessage onMessageOpenedApp: ');
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => SupportManChatList(),
    //     ),
    //     (route) => route.isFirst);
  });

  print("Handling a background message: ${event.messageId}");
}

fcmListen(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // var uid = preferences.getString("uid");
  // var userType = preferences.getString("userType");
  // print('userType: $userType');

  // var sfID = await AuthServices.getTraderID();
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print('onMessage event......: $event');
    print(event.notification?.title.toString());
    LocalNotificationsService.instance.showNotification(
        title: '${event.notification?.title}',
        body: '${event.notification?.body}');
    // if (event.data['id'] == FirebaseAuth.instance.currentUser?.uid ||
    //     event.data['id'] == uid) {
    //   LocalNotificationsService.instance.showNotification(
    //       title: '${event.notification?.title}',
    //       body: '${event.notification?.body}');

    //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //     print('onMessageOpenedApp message: $message');
    //     print('userType: $userType');
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(
    //           builder: (_) => SupportManChatList(),
    //         ),
    //         (route) => route.isFirst);
    //     // if (userType == "admin") {
    //     // } else if (userType == "supportMan") {
    //     // } else if (userType == "user") {
    //     // }
    //   });
    // } else {}
  });
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> mynavigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  void initState() {
    super.initState();
    setOrientationPortrait();

    afterBuildCreated(() {
      OneSignal.shared.setNotificationOpenedHandler(
          (OSNotificationOpenedResult notification) {
        try {
          var notId =
              notification.notification.additionalData!.containsKey('id')
                  ? notification.notification.additionalData!['id']
                  : 0;
          if (notId.toString().isNotEmpty) {
            push(NewsDetailScreen(newsId: notId.toString()));
          } else {
            if (notification.notification.additionalData!
                .containsKey('video_url')) {
              String? videoUrl =
                  notification.notification.additionalData!['video_url'];
              String? videoType =
                  notification.notification.additionalData!['video_type'];
              push(WebViewScreen(videoUrl: videoUrl, videoType: videoType));
            }
          }
        } catch (e) {
          throw errorSomethingWentWrong;
        }
      });
    });

    FirebaseMessaging.onBackgroundMessage(messageHandler);
    fcmListen(context);
  }

  Future<void> messageHandler(RemoteMessage event) async {
    print('RemoteMessage event: $event');
    await Firebase.initializeApp();

    LocalNotificationsService.instance.showNotification(
        title: '${event.notification?.title}',
        body: '${event.notification?.body}');
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('RemoteMessage onMessageOpenedApp: ');
      // mynavigatorKey.currentState!.push(MaterialPageRoute(
      //   builder: (_) => ChatWelcomeScreen(),
      // ));
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => SupportManChatList(),
      //     ),
      //     (route) => route.isFirst);
    });

    // if (event.data['id'] == FirebaseAuth.instance.currentUser?.uid ||
    //     event.data['id'] == uid) {
    //   LocalNotificationsService.instance.showNotification(
    //       title: '${event.notification?.title}',
    //       body: '${event.notification?.body}');

    //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //     print('RemoteMessage onMessageOpenedApp: ');
    //     mynavigatorKey.currentState!.push(MaterialPageRoute(
    //       builder: (_) => ChatWelcomeScreen(),
    //     ));
    //     // Navigator.pushAndRemoveUntil(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //       builder: (_) => SupportManChatList(),
    //     //     ),
    //     //     (route) => route.isFirst);
    //   });
    // }

    print("Handling a background message: ${event.messageId}");
  }

//  Future<void> bg() {

//     FirebaseMessaging.instance.configure(
//       onMessage: (Map<String, dynamic> message) {
//         String id = message['id'];
//         print("onMessage: $id");
//         getNewsDetail(int.parse(id)).then((news) {
//           print(news.information);
//         });
//       },
//       onLaunch: (Map<String, dynamic> message) {
//         String id = message['id'];
//         print("onLaunch: $id");
//         getNewsDetail(int.parse(id)).then((news) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               fullscreenDialog: true,
//               builder: (context) => NewsDetailScreen(news),
//             ),
//           );
//         });
//       },
//       onResume: (Map<String, dynamic> message) {
//         String id = message['id'];
//         print("onResume: $id");
//         getNewsDetail(int.parse(id)).then((news) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               fullscreenDialog: true,
//               builder: (context) => NewsDetailScreen(news),
//             ),
//           );
//         });
//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(345, 810),
        builder: (
          context,
          _,
        ) {
          return Observer(
            builder: (_) => MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: mynavigatorKey,
              scrollBehavior: ScrollBehavior(),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              supportedLocales: Language.languagesLocale(),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) => locale,
              locale: Locale(appStore.selectedLanguageCode),
              home: SplashScreen(),
            ),
          );
        });
  }
}
