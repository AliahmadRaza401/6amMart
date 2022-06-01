import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_flutter/Chat_Module/utils.dart';
import 'package:transition_pages_jr/transition_pages_jr.dart';

import '../../completeChat/chat_room.dart';
import '../../completeChat/model/chat_room_model.dart';
import '../../completeChat/model/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/firebase_helper.dart';

class AdminSearch extends StatefulWidget {
  const AdminSearch();

  @override
  _AdminSearchState createState() => _AdminSearchState();
}

class _AdminSearchState extends State<AdminSearch> {
  TextEditingController searchController = TextEditingController();
  var uid = 'co718RpeRmKCM2fvjhXx';

  @override
  void initState() {
    super.initState();
    getDeviceToekn();
  }

  var deviceToken = '';
  getDeviceToekn() async {
    var userData = await FirebaseHelper.getadminModelById(uid);
    setState(() {
      deviceToken = userData['deviceToken'];
    });
  }

  Future<ChatRoomModel?> getChatroomModel(MyUserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${'co718RpeRmKCM2fvjhXx'}")
        .where("participants.${targetUser.uid}")
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      var uuid = Uuid();
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          'co718RpeRmKCM2fvjhXx': "admin",
          targetUser.uid.toString(): "user",
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
  }

  Future<void> share(
    String subject,
    String text,
  ) async {
    print('text: $text');
    await Share.share(
      text,
      subject: subject,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Search",
          style: GoogleFonts.rubik(fontSize: 18.sp, color: Colors.white),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
        backgroundColor: AppColors.darkBlueColor,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(labelText: "Email Username"),
                // onChanged: (val) {
                //   setState(() {});
                // },
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Search"),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("username", isEqualTo: searchController.text)
                      .where("username", isNotEqualTo: "admin")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        log('dataSnapshot: $dataSnapshot');
                        if (dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;

                          MyUserModel searchedUser =
                              MyUserModel.fromMap(userMap);
                          log('searchedUser: ${searchedUser.username}');

                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatroomModel =
                                  await getChatroomModel(searchedUser);

                              if (chatroomModel != null) {
                                RouteTransitions(
                                  context: context,
                                  child: ChatRoom(
                                    status: searchedUser.status.toString(),
                                    targetUser: MyUserModel(
                                        uid: searchedUser.uid.toString(),
                                        username:
                                            searchedUser.username.toString(),
                                        phone: searchedUser.phone.toString(),
                                        facebook:
                                            searchedUser.facebook.toString(),
                                        linkedIn:
                                            searchedUser.linkedIn.toString(),
                                        twitter:
                                            searchedUser.twitter.toString(),
                                        dribble:
                                            searchedUser.dribble.toString(),
                                        status: searchedUser.status.toString(),
                                        bio: searchedUser.bio.toString(), deviceToken: searchedUser.deviceToken.toString()),
                                    userModel: MyUserModel(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        username: "Admin",
                                        phone: "+923034657515",
                                        facebook: "",
                                        linkedIn: '',
                                        twitter: "",
                                        dribble: "",
                                        status: "",
                                        bio: '', deviceToken: deviceToken),
                                    chatRoom: chatroomModel,
                                  ),
                                  animation: AnimationType.fadeIn,
                                );
                              }

                              // if (chatroomModel != null) {
                              //   Navigator.pop(context);
                              //   Navigator.push(context,
                              //       MaterialPageRoute(builder: (context) {
                              //     return ChatRoomPage(
                              //       targetUser: searchedUser,
                              //       userModel: widget.userModel,
                              //       firebaseUser: widget.firebaseUser,
                              //       chatroom: chatroomModel,
                              //     );
                              //   }));
                              // }
                            },
                            leading: Badge(
                              shape: BadgeShape.circle,
                              badgeColor:
                                  searchedUser.status.toString() == "online"
                                      ? Colors.green
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                              position: BadgePosition.bottomEnd(
                                bottom: 0,
                                end: 0,
                              ),
                              padding: const EdgeInsets.all(2),
                              badgeContent: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: searchedUser.status.toString() ==
                                            "online"
                                        ? Colors.green
                                        : Colors.grey,
                                  )),
                              child: CircleAvatar(
                                maxRadius: 30,
                                backgroundImage:
                                    AssetImage("Images/chat/userImage.jpeg"),
                              ),
                            ),
                            title: Text(searchedUser.username!),
                            subtitle: Text(searchedUser.phone!),
                          );
                        } else {
                          return Text("No results found!");
                        }
                      } else if (snapshot.hasError) {
                        return Text("An error occured!");
                      } else {
                        return Text("No results found!");
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
