// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

dynamic serverKey =
    "AAAA5q8lGVU:APA91bGb6_OypWlMu9OLcrVsyIVk7zvq5GOlFikx3lxBfqmBkN6uwCRp04ow0BpMGj6TyC43O7xYYXKzFwgfmeGTSSUnJwom1gKWfSgN07QDTYjBXRuAqQcCfMuPM-QfP53_kyWnvXDL";

class FCMServices {
  static fcmGetTokenandSubscribe(topic) {
    FirebaseMessaging.instance.getToken().then((value) {
      FirebaseMessaging.instance.subscribeToTopic("$topic");
    });
  }

  static Future<http.Response> sendFCM(
      topic, id, title, description) {
    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "key=$serverKey",
      },
      body: jsonEncode({
        "to": "$topic",
        "notification": {
          "title": title,
          "body": description,
        },
        "mutable_content": true,
        "content_available": true,
        "priority": "high",
        "data": {
          "android_channel_id": "News Blog",
          "id": id,
          "targetName": '',
        }
      }),
    );
  }
}
