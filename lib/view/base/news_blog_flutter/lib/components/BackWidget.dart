import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BackWidget extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final double? iconSize;


  BackWidget({this.color, this.onPressed, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed?.call();
        } else {
          pop();
        }
      },
      alignment: Alignment.center,
      icon: Icon(Icons.arrow_back_ios, color: color ?? Colors.white, size: iconSize ?? 20),
    );
  }
}
