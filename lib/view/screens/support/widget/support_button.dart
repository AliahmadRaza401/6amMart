import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final Color color;
  final Function onTap;
  SupportButton({@required this.icon, @required this.title, @required this.info, @required this.color, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Container(
            height: 40, width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: color)),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(info, style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),

        ]),
      ),
    );
  }
}
