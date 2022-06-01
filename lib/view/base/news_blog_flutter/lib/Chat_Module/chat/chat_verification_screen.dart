import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_flutter/Chat_Module/chat/chat_otp_screen.dart';
import 'package:news_flutter/Chat_Module/utils.dart';

import 'package:transition_pages_jr/transition_pages_jr.dart';

import '../widgets/customToast.dart';
import '../widgets/default_button.dart';

class ChatVerificationScreen extends StatefulWidget {
  const ChatVerificationScreen({Key? key}) : super(key: key);

  @override
  State<ChatVerificationScreen> createState() => _ChatVerificationScreenState();
}

class _ChatVerificationScreenState extends State<ChatVerificationScreen> {
  CountryCode countryCode = CountryCode.fromDialCode('+233');
  bool loading = false;
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            color: AppColors.darkBlueColor,
            size: 30.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text("Verify Your \nPhone Number",
                    style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: 35.sp,
                        color: AppColors.blackColor)),
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  "Add your phone number. We'll send you a verification code.",
                  style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: AppColors.blackColor),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(5.r)),
                      width: 100.w,
                      child: CountryCodePicker(
                        textStyle: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.blackColor),
                        padding: const EdgeInsets.all(0),
                        onChanged: (code) {
                          if (mounted) {
                            setState(() {
                              countryCode = code;
                            });
                          }
                        },
                        showCountryOnly: true,
                        showOnlyCountryWhenClosed: false,
                        initialSelection: countryCode.dialCode,
                      ),
                    ),
                    Container(
                      width: 190.w,
                      decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextFormField(
                          controller: phone,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: GoogleFonts.rubik(
                              fontSize: 16.sp, color: AppColors.blackColor),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01,
                                left: 20),
                            labelStyle: GoogleFonts.rubik(
                                fontSize: 16.sp, color: AppColors.blackColor),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: "XXX-XXX-XXXX",
                            hintStyle: GoogleFonts.rubik(
                                fontSize: 16.sp, color: AppColors.blackColor),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100.h,
                ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkBlueColor,
                        ),
                      )
                    : Center(
                        child: DefaultButton(
                            onTap: () async {
                              if (mounted) {
                                setState(() {
                                  loading = true;
                                });
                              }
                              if (phone.text.isEmpty) {
                                ToastUtils.showCustomToast(
                                    context,
                                    "Please enter number",
                                    AppColors.darkBlueColor);
                                if (mounted) {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              } else {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: countryCode.toString() +
                                      phone.text
                                          .toString()
                                          .replaceAll(RegExp(r'^0+(?=.)'), ''),
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    /*    if(mounted){
                           setState(() {
                             loading = false;
                           });
                         }
                         ToastUtils.showCustomToast(context, "Verification Done", AppColors.darkBlueColor);*/
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    if (mounted) {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                    ToastUtils.showCustomToast(
                                        context, e.code.toString(), Colors.red);
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    ToastUtils.showCustomToast(context,
                                        "Code Sent", AppColors.darkBlueColor);
                                    if (mounted) {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                    RouteTransitions(
                                      context: context,
                                      child: ChatOtpScreen(
                                          isTimeOut2: false,
                                          phone: countryCode.toString() +
                                              phone.text
                                                  .toString()
                                                  .replaceAll(
                                                      RegExp(r'^0+(?=.)'), '')
                                                  .toString(),
                                          verifyId: verificationId),
                                      animation: AnimationType.fadeIn,
                                    );
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    if (mounted) {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  },
                                );
                              }
                            },
                            text: "SEND CODE"),
                      ),
                SizedBox(
                  height: 50.h,
                ),
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'By providing my phone number, I hereby agree and accept the ',
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.blackColor),
                        ),
                        TextSpan(
                          text: ' Terms of Services',
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.darkBlueColor),
                        ),
                        TextSpan(
                          text: ' and',
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.blackColor),
                        ),
                        TextSpan(
                          text: ' Privacy Policy',
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.darkBlueColor),
                        ),
                        TextSpan(
                          text: ' of this app',
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.blackColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
