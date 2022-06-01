import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_flutter/Chat_Module/chat/user/userChat_list.dart';
import 'package:news_flutter/Chat_Module/services/fcm_services.dart';
import 'package:news_flutter/Chat_Module/services/firebase_helper.dart';
import 'package:news_flutter/Screens/DashboardScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:transition_pages_jr/transition_pages_jr.dart';
import 'package:uuid/uuid.dart';

import '../completeChat/chat_handler.dart';
import '../completeChat/chat_room.dart';
import '../completeChat/model/chat_room_model.dart';
import '../completeChat/model/user_model.dart';
import '../utils.dart';
import '../widgets/default_button.dart';
import 'chat_profile_screen.dart';

class ChatCounselorScreen extends StatefulWidget {
  String username;

  ChatCounselorScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ChatCounselorScreen> createState() => _ChatCounselorScreenState();
}

class _ChatCounselorScreenState extends State<ChatCounselorScreen> {
  @override
  void initState() {
    super.initState();
  }

  String number = '';

  get() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      number = preferences.getString('number').toString();
    });
  }

  ChatRoomModel? chatRoomModel;
  Future<ChatRoomModel?> checkChatRoom(targetID, userID) async {
    print('userID: $userID');
    print('targetID: $targetID');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
          "participants.${userID}",
          isEqualTo: "user",
        )
        .where(
          "participants.${targetID}",
          isEqualTo: "admin",
        )
        .get();

    if (snapshot.docs.length > 0) {
      print("ChatRoom Available_______________________________");

      var docData = snapshot.docs[0].data();

      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      print("Exiting chat Room : ${existingChatRoom.chatroomid}");
      print("Exiting chat participants : ${existingChatRoom.participants}");
      chatRoomModel = existingChatRoom;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => UserChatList()),
          (Route<dynamic> route) => false);
    } else {
      print("ChatRoom Not Available_______________________________");

      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: const Uuid().v1(),
        lastMessage: "",
        participants: {
          targetID.toString(): "admin",
          userID.toString(): "user",
        },
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());
      chatRoomModel = newChatRoom;

      //  go to in a chat
      var adminData =
          await FirebaseHelper.getadminModelById('co718RpeRmKCM2fvjhXx');
      var supportData = await FirebaseHelper.getSupportMAnModelById(
          FirebaseAuth.instance.currentUser!.uid);

      if (chatRoomModel != null) {
        RouteTransitions(
          context: context,
          child: ChatRoom(
            status: '',
            targetUser: MyUserModel(
              uid: "co718RpeRmKCM2fvjhXx",
              username: "Admin",
              phone: '+92',
              facebook: "",
              linkedIn: '',
              twitter: "",
              dribble: "",
              status: "",
              bio: '',
              deviceToken: adminData['deviceToken'],
            ),
            userModel: MyUserModel(
              uid: FirebaseAuth.instance.currentUser!.uid,
              username: widget.username,
              facebook: "",
              linkedIn: '',
              twitter: "",
              dribble: "",
              status: "",
              bio: '',
              phone: number.toString(),
              deviceToken: supportData['supportData'],
            ),
            chatRoom: chatRoomModel as ChatRoomModel,
          ),
          animation: AnimationType.fadeIn,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashboardScreen()),
            (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Welcome \n\"${widget.username}\"",
                    style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: 35.sp,
                        color: AppColors.blackColor),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "You can ask your questions, we will be glad to assist you in any as possible.\nOur Counselors are here to help.",
                    style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: AppColors.blackColor),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.4),
                    child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        maxLines: 5,
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: AppColors.blackColor),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                              left: 10),
                          labelStyle: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.blackColor),
                          hintStyle: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.blackColor),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: "Feel free to leave a voice note or text",
                          // labelText:"Your Name"
                        )),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  Center(
                    child: DefaultButton(
                        onTap: () async {
                          var uid = FirebaseAuth.instance.currentUser!.uid;

                          checkChatRoom("co718RpeRmKCM2fvjhXx", uid);

                          print('uid: $uid');
                          // ChatRoomModel? chatRoomModel =
                          //     await ChatHandler.getChatRoom(
                          //         "co718RpeRmKCM2fvjhXx", uid);

                          // if (chatRoomModel != null) {
                          //   RouteTransitions(
                          //     context: context,
                          //     child: ChatRoom(
                          //       targetUser: UserModel(
                          //         uid: "co718RpeRmKCM2fvjhXx",
                          //         fullname: "Admin",
                          //         email: 'admin@gmail.com',
                          //         profilepic: "",
                          //       ),
                          //       userModel: UserModel(
                          //         uid: FirebaseAuth.instance.currentUser!.uid,
                          //         fullname: widget.username,
                          //         email: number.toString(),
                          //         profilepic: "",
                          //       ),
                          //       chatRoom: chatRoomModel,
                          //     ),
                          //     animation: AnimationType.fadeIn,
                          //   );
                          // }
                        },
                        text: "ASK A COUNSELOR"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
