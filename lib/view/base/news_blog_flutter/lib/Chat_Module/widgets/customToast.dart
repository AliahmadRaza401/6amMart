import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToastUtils {
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;

  static void showCustomToast(BuildContext context,
      String message,Color color) {

    if (toastTimer == null || !toastTimer!.isActive) {
      _overlayEntry = createOverlayEntry(context, message,color);
      Overlay.of(context)!.insert(_overlayEntry!);
      toastTimer = Timer(const Duration(seconds: 2), () {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
        }
      });
    }

  }

  static OverlayEntry createOverlayEntry(BuildContext context,
      String message, Color color) {

    return OverlayEntry(
        builder: (context) => Positioned(
            top: 50.0,
            width: MediaQuery.of(context).size.width - 20.w,
            left: 10,
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding:
                const EdgeInsets.only(left: 10, right: 10,
                    top: 13, bottom: 10),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style:  GoogleFonts.rubik(
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ));
  }
}