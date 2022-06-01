import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/WeatherModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/components/WeatherViewWidget.dart';

class WeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherModel>(
      future: AsyncMemoizer<WeatherModel>().runOnce(() => weatherApi()),
      builder: (context, snap) {
        if (snap.hasData) {
          WeatherModel model = snap.data!;
          return Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: context.cardColor,borderRadius: BorderRadius.circular(32)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                cachedImage('https:${model.current!.condition!.icon.validate()}', width: 36, height: 36),
                Text('${model.current!.feelslike_c.validate().round()}°C', style: boldTextStyle(size: 20)).paddingRight(8),

              ],
            ),
          ).onTap(() async {
            WeatherViewWidget(model).launch(context);
          });
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            cachedImage('Images/News/gif/ic_hand_wave.gif', width: 50, height: 50),
            Text(getWishes(), style: boldTextStyle(size: 20)),
          ],
        ).paddingAll(8);
      },
    );
  }
}
