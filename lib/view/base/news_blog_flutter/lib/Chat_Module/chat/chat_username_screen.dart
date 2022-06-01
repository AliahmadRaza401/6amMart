import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:transition_pages_jr/transition_pages_jr.dart';

import '../utils.dart';
import '../widgets/customToast.dart';
import '../widgets/default_button.dart';
import 'chat_counselor_screen.dart';

class ChatUsernameScreen extends StatefulWidget {
  const ChatUsernameScreen({Key? key}) : super(key: key);

  @override
  State<ChatUsernameScreen> createState() => _ChatUsernameScreenState();
}

class _ChatUsernameScreenState extends State<ChatUsernameScreen> {
  TextEditingController username = TextEditingController();
  bool loading = false;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future updateUName() async{
    SharedPreferences preferences =await SharedPreferences.getInstance();
    preferences.setString("username", username.text.toString());

    firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({
      "username":username.text.toString(),
    }).then((data) async {
        if(mounted) {
          setState(() {
          loading = false;
        });
        }
        ToastUtils.showCustomToast(context, "Username Added", AppColors.darkBlueColor);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatCounselorScreen(username:username.text.toString()))
          );
        });

      }).catchError((err) {
      if(mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(context, err.toString(), Colors.red);
      });

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
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Add Your \nUsername ",
                  style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 35.sp,
                      color: AppColors.blackColor),
                  textAlign: TextAlign.start,
                ),
                 SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Enter your preferred username. \nKindly note that you cannot change it again.",
                  style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: AppColors.blackColor),
                ),
                 SizedBox(
                  height: 50.h,
                ),
                Container(
                  width: 290.w,
                  decoration: BoxDecoration(color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(5.r)),
                  child: TextFormField(
                      controller: username,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style:  GoogleFonts.rubik(fontSize: 16.sp,color: AppColors.blackColor),
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.rubik(fontSize: 16.sp,color: AppColors.blackColor),
                        contentPadding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: 10),
                        labelStyle: const TextStyle(),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter username here",
                        // labelText:"Your Name"
                      )),
                ),
                 SizedBox(
                  height: 80.h,
                ),
                loading ? Center(
                  child: CircularProgressIndicator(color: AppColors.darkBlueColor,),
                ):Center(
                  child: DefaultButton(
                      onTap: () {
                        if(username.text.isEmpty){
                          ToastUtils.showCustomToast(context, "Please Enter Username", AppColors.darkBlueColor);
                        }
                        else{

                          if(mounted){
                            setState(() {
                              loading = true;
                            });
                          }
                       updateUName();
                        }


                      },
                      text: "CONFIRM"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
