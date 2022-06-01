import 'package:flutter/material.dart';
import 'package:news_flutter/Chat_Module/chat/admin/adminChatList.dart';
import 'package:news_flutter/Chat_Module/chat/supportMan/supportMan_chatlist.dart';
import 'package:news_flutter/Chat_Module/chat/user/userChat_list.dart';

class Routes {
  static const String splashScreen = '/user';
  static const String personalInformation = '/admin';
  static const String nationaIDCardScreen = '/support';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => UserChatList(),
        );
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) =>AdminChatList(),
        );
        case splashScreen:
        return MaterialPageRoute(
          builder: (context) => SupportManChatList(),
        );
      default:
        throw const FormatException('Route not found');
    }
  }
}
