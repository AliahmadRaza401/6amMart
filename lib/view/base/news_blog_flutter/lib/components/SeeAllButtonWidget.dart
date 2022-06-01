import 'package:flutter/material.dart';

class SeeAllButtonWidget extends StatelessWidget {
  final Widget widget;
  final VoidCallback? onTap;

  SeeAllButtonWidget({required this.widget, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTap?.call(),
      child: widget,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
