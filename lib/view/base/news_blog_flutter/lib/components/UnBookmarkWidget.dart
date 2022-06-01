import 'package:flutter/material.dart';

class UnBookMarkIconWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? icon;

  UnBookMarkIconWidget({required this.icon, this.onTap, this.backgroundColor = Colors.white});

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
