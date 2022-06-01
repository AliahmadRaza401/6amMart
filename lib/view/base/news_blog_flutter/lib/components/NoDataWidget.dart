import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/constant.dart';

import '../main.dart';

class NoDataWidget extends StatelessWidget {
  final double height;
  final double width;

  NoDataWidget({this.height = 200, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(ic_noData, height: height, width: width),
        Text(appLocalization!.translate("noRecord"), style: primaryTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: textSizeLargeMedium)),
      ],
    );
  }
}
