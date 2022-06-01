import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/main.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

import 'Images.dart';

void onShareTap(BuildContext context) async {
  //final RenderBox box = context.findRenderObject() as RenderBox;
  //Share.share(App_Name, subject: 'Share $App_Name App', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  PackageInfo.fromPlatform().then((value) {
    Share.share('Share $AppName app https://play.google.com/store/apps/details?id=com.iqonic.newzflutter');
  });
}

BoxDecoration boxDecoration(BuildContext context,
    {double radius = 1.0, Color color = Colors.transparent, Color? bgColor = white_color, double borderWidth = 0.0, Color shadowColor = shadow_color, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor == white_color ? Theme.of(context).cardTheme.color : bgColor,
      boxShadow: showShadow ? [BoxShadow(color: Theme.of(context).hoverColor.withOpacity(0.2), blurRadius: 10, spreadRadius: 3)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color, width: borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

// ignore: must_be_immutable
class NewsButton extends StatefulWidget {
  static String tag = '/NewsButton';
  final Widget content;
  final VoidCallback? onPressed;
  final bool isStroked;
  final double? height;
  final double? width;
  final Color backGroundColor;
  final double? borderRadius;

  NewsButton({
    required this.content,
    required this.onPressed,
    this.isStroked = false,
    this.height,
    this.backGroundColor = primaryColor,
    this.borderRadius,
    this.width,
  });

  @override
  NewsButtonState createState() => NewsButtonState();
}

class NewsButtonState extends State<NewsButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        alignment: Alignment.center,
        child: FittedBox(
          child: widget.content,
        ),
        decoration: widget.isStroked
            ? boxDecoration(context, bgColor: Colors.transparent, color: widget.backGroundColor, radius: widget.borderRadius ?? defaultRadius)
            : boxDecoration(context, bgColor: widget.backGroundColor, radius: widget.borderRadius ?? defaultRadius),
      ),
    );
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset(greyImage, height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center, color: appStore.isDarkMode ? appBackGroundColor : null)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget cachedImage(String url, {Key? key, double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius, Color? color}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      key: key,
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url, key: key, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center, color: color).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget createNews({String? userImage}){
  return  Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.2)),
    child: Image.asset(userImage.validate(), width: 20, height: 20, color: Colors.white),
  );
}


