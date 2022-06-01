import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_flutter/Chat_Module/chat/admin/adminChatList.dart';
import 'package:news_flutter/Chat_Module/chat/supportMan/supportMan_chatlist.dart';
import 'package:news_flutter/Chat_Module/widgets/default_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_pages_jr/transition_pages_jr.dart';

import '../utils.dart';
import 'chat_counselor_screen.dart';
import 'chat_verification_screen.dart';

class ChatWelcomeScreen extends StatefulWidget {
  const ChatWelcomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatWelcomeScreen> createState() => _ChatWelcomeScreenState();
}

class _ChatWelcomeScreenState extends State<ChatWelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkUserType();
  }

  bool loading = false;

  var logStatus, uname, uid;
  String userType = "user";
  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        logStatus = preferences.getString("logStatus");
        uname = preferences.getString("username");
        uid = preferences.getString("uid");
      });
    }
    log(logStatus.toString());
    log(uname.toString());

    if (logStatus.toString() == "true" && uid != null) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      if (userType == "admin") {
        RouteTransitions(
          context: context,
          child: AdminChatList(),
          animation: AnimationType.fadeIn,
        );
      }else if (userType == "supportMan") {
        RouteTransitions(
          context: context,
          child: SupportManChatList(),
          animation: AnimationType.fadeIn,
        );
      }
       else {
        RouteTransitions(
          context: context,
          child: ChatCounselorScreen(username: uname.toString()),
          animation: AnimationType.fadeIn,
        );
      }
    } else {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  checkUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uid = await preferences.getString("uid");
    log('uid: $uid');

    FirebaseFirestore.instance.collection("admin").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['uid'].toString() == uid.toString()) {
          print(doc['uid'].toString());
          print("This is admin");
          setState(() {
            userType = "admin";
          });
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
                setState(() {
                  userType = "supportMan";
                });
              } else {
                print("This is user");
                setState(() {
                  userType = "user";
                });
              }
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: // 1. Local image
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      // image: DecorationImage(
                      //     alignment: Alignment.center,
                      //     image: AssetImage("images/chat/welcomeImage.jpeg"),
                      //     fit: BoxFit.fitWidth),
                      ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 22, right: 22, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          "We are here",
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w600,
                              fontSize: 35.sp,
                              color: const Color(0xFF1E263C)),
                        ),
                        Text(
                          "to help",
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w600,
                              fontSize: 35.sp,
                              color: const Color(0xFF1E263C)),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Text(
                          "Get Godly Advise, Chat anonymously",
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
                              color: const Color(0xFF12558A)),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Image.asset("Images/chat/welcomeImage.jpeg",
                            fit: BoxFit.fitWidth),
                        const Spacer(
                          flex: 1,
                        ),
                        loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.darkBlueColor,
                                ),
                              )
                            : Center(
                                child: DefaultButton(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                      RouteTransitions(
                                        context: context,
                                        child: ChatVerificationScreen(),
                                        animation: AnimationType.fadeIn,
                                      );
                                    },
                                    text: "Start Chat"),
                              ),
                        const Spacer(),
                      ],
                    ),
                  ))),
    );
  }
}
