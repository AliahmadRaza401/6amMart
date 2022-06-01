import 'package:flutter/material.dart';
import 'package:news_flutter/Utils/Colors.dart';

class IconWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? icon;

  IconWidget({required this.icon, this.onTap, this.backgroundColor = primaryColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        alignment: Alignment.topRight,
        child: icon,
      ),
    );
  }
}
