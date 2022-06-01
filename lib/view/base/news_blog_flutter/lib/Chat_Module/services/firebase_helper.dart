import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_flutter/Chat_Module/completeChat/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper {
  static Future getadminModelById(String uid) async {
    print('uid: $uid');
    var data;
    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("admin").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
      print('Userdata: $data');
    } else {
      print("users null");
    }

    return data;
  }

  static Future getUserModelById(String uid) async {
    print(' getUserModelById uid: $uid');
    var data;
    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
      print('Userdata: $data');
    } else {
      print("users null");
    }

    return data;
  }

   static Future getSupportMAnModelById(String uid) async {
    print(' getUserModelById uid: $uid');
    var data;
    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("support").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
      print('Userdata: $data');
    } else {
      print("users null");
    }

    return data;
  }

  static Future getSupportMan() async {
    print("get SupportMAn >>>>>>>>>>>>>>>>>>>>>>>>>>");
    List<MyUserModel> supportManList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("support").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      supportManList.add(MyUserModel(
          uid: querySnapshot.docs[i]['uid'],
          username: querySnapshot.docs[i]['username'],
          phone: querySnapshot.docs[i]['phone'],
          status: querySnapshot.docs[i]['status'],
          bio: querySnapshot.docs[i]['bio'],
        facebook: querySnapshot.docs[i]['facebook'],
        twitter: querySnapshot.docs[i]['twitter'],
        dribble: querySnapshot.docs[i]['dribble'],
        linkedIn: querySnapshot.docs[i]['linkedIn'], deviceToken: querySnapshot.docs[i]['deviceToken'],

      ));
      print('supportManList: $supportManList');
    }
    return supportManList;
  }

  static Future getFromAllDatabase(String uid) async {
    var data;
    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("admin").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
      print('Userdata: $data');
    } else {
      print("users null");
      DocumentSnapshot docSnap =
          await FirebaseFirestore.instance.collection("support").doc(uid).get();
      if (docSnap.data() != null) {
        data = docSnap.data();
        print('Userdata: $data');
      } else {
        print("users null from supportman also>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      }
    }

    return data;
  }

  static Future checkUserType() async {
    String userType = "";

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uid = await preferences.getString("uid");
    log('uid: $uid');

    FirebaseFirestore.instance.collection("admin").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['uid'].toString() == uid.toString()) {
          print(doc['uid'].toString());
          print("This is admin");

          userType = "admin";
        } else {
          // check supportMan
          FirebaseFirestore.instance
              .collection("support")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              if (doc['uid'].toString() == uid.toString()) {
                print(doc['uid'].toString());
                print("This is supportMan");

                userType = "supportMan";
              } else {
                print("This is user");

                userType = "user";
              }
            });
          });
        }
      });
    });
    return userType;
  }

  static void updateAdminStatus(uid, String status) async {
    print('status init_________________________: $status');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("admin").doc(uid).update({
      'status': status.toString(),
    }).then((value) {
      print("Status Update Done");
    });
  }

  static void updateSupportManStatus(uid, String status) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("support").doc(uid).update({
      'status': status.toString(),
    }).then((value) {
      print("Status Update Done");
    });
  }

  static void updateUserStatus(uid, String status) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("users").doc(uid).update({
      'status': status.toString(),
    }).then((value) {
      print("Status Update Done");
    });
  }
}
