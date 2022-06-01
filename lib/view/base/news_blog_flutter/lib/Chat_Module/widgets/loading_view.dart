import 'package:flutter/material.dart';
import 'package:news_flutter/Chat_Module/utils.dart';


class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.darkBlueColor,
        ),
      ),
      color: AppColors.lBlueColor.withOpacity(0.25),
    );
  }
}