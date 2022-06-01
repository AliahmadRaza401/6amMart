

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../completeChat/model/user_model.dart';
import '../utils.dart';
import '../widgets/default_button.dart';
class ChatProfilePage extends StatefulWidget {
  String userid;
  final MyUserModel targetUser;
  bool chatRoom;
  String name;
  ChatProfilePage({Key? key,required this.chatRoom,required this.targetUser,required this.userid,required this.name}) : super(key: key);

  @override
  State<ChatProfilePage> createState() => _ChatProfilePageState();
}

class _ChatProfilePageState extends State<ChatProfilePage> {

  @override
  void initState() {
    super.initState();

  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String facebook= "", dribble="", twitter="", linkedIn ="",bio = "";

  List link = [];
  void getUserLinks() async{
  if(widget.name == "admin"){
    await FirebaseFirestore.instance
        .collection('admin')
        .doc(widget.userid)
        .get().then((value) => {
     if(mounted){
       setState((){
         bio = value.data()!["bio"];
         facebook = value.data()!["facebook"];
         dribble = value.data()!["dribble"];
         linkedIn = value.data()!["linkedIn"];
         twitter = value.data()!["twitter"];
       })
     }
    });

  }
  else{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userid)
        .get().then((value) => {
      bio = value.data()!["bio"],
      facebook = value.data()!["facebook"],
      dribble = value.data()!["dribble"],
      linkedIn = value.data()!["linkedIn"],
      twitter = value.data()!["twitter"],
    });

  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:  Icon(
            Icons.chevron_left,
            color: AppColors.darkBlueColor,
            size: 30.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Image.asset("Images/chat/userImage.jpeg",width: 100.w,height: 100.h,),
                  SizedBox(width: 20.w,),
                 widget.chatRoom ==false? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Hey ',
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 35.sp,
                              color: AppColors.blackColor),),
                        TextSpan(
                          text: ' \n${widget.name.toString()}',
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 35.sp,
                              color: AppColors.blackColor),
                        ),

                      ],
                    ),
                  ):
                 Text(' \n${widget.targetUser.username.toString()}', style: GoogleFonts.rubik(
                     fontWeight: FontWeight.w500,
                     fontSize: 35.sp,
                     color: AppColors.blackColor),
                 ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(widget.targetUser.bio.toString().isNotEmpty ?widget.targetUser.bio.toString():
                        "NO BIO ADDED YET", style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.sp,
                        color: AppColors.blackColor)),
                    SizedBox(height: 50.h,),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                       Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF1976D2),
                              borderRadius: BorderRadius.circular(5.r)
                          ),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () async{
                              if(widget.targetUser.facebook!.isNotEmpty){
                                await launchUrl(Uri.parse(widget.targetUser.facebook!));
                              }
                              else{
                                Fluttertoast.showToast(msg: "Link not attached");
                              }

                            }, icon: Icon(FeatherIcons.facebook),
                          ),
                        ),
                         Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF0077B5),
                              borderRadius: BorderRadius.circular(5.r)
                          ),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () async{
                              if(widget.targetUser.linkedIn!.isNotEmpty){
                                await launchUrl(Uri.parse(widget.targetUser.linkedIn!));
                              }
                              else{
                                Fluttertoast.showToast(msg: "Link not attached");
                              }


                            }, icon: Icon(FeatherIcons.linkedin),
                          ),
                        ),
                          Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF50ABF1),
                              borderRadius: BorderRadius.circular(5.r)
                          ),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () async{
                              if(widget.targetUser.twitter!.isNotEmpty){
                                await launchUrl(Uri.parse(widget.targetUser.twitter!));
                              }
                              else{
                                Fluttertoast.showToast(msg: "Link not attached");
                              }

                            }, icon: Icon(FeatherIcons.twitter),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF0077B5),
                              borderRadius: BorderRadius.circular(5.r)
                          ),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () async{
                              if(widget.targetUser.dribble!.isNotEmpty){
                                await launchUrl(Uri.parse(widget.targetUser.dribble!));
                              }
                              else{
                                Fluttertoast.showToast(msg: "Link not attached");
                              }

                            }, icon: Icon(FeatherIcons.aperture),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 50.h,),
            ],
          ),
        ),
      ),
    );
  }

}

