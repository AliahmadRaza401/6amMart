import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatelessWidget {
  GestureTapCallback onTap;
  String text;
  DefaultButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 288.w,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color(0xFF12558A),
            borderRadius: BorderRadius.circular(5.r)),
        child: Text(
          text,
          style: GoogleFonts.rubik(
              fontWeight: FontWeight.w400, color: Colors.white, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
