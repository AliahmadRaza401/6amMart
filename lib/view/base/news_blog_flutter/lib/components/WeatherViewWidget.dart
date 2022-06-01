import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/WeatherModel.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/components/BackWidget.dart';

import '../main.dart';

class WeatherViewWidget extends StatefulWidget {
  final WeatherModel weatherModel;

  WeatherViewWidget(this.weatherModel);

  @override
  WeatherViewWidgetState createState() => WeatherViewWidgetState();
}

class WeatherViewWidgetState extends State<WeatherViewWidget> {
  int dayWeather = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Color getColor(int count) {
    if (count >= 0 && count <= 50) {
      return Color(0xFF34A12B);
    } else if (count > 50 && count <= 100) {
      return Color(0xFFD4CC0F);
    } else if (count > 100 && count <= 200) {
      return Color(0xFFE9572A);
    } else if (count > 200 && count <= 300) {
      return Color(0xFFEC4D9F);
    } else if (count > 300 && count <= 400) {
      return Color(0xFF9858A2);
    } else {
      return Color(0xFFC11E2F);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: context.statusBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackWidget(color: context.iconColor),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: appStore.isDarkMode ? context.cardColor : Colors.grey.shade100, borderRadius: BorderRadius.circular(defaultRadius)),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cachedImage('https:${widget.weatherModel.current!.condition!.icon.validate().replaceAll('64x64', '128x128')}', width: 100, height: 100),
                        16.width,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.weatherModel.current!.feelslike_c.validate().round()}°C', style: boldTextStyle(size: 42)).paddingLeft(8),
                            Text('${widget.weatherModel.location!.name.validate()}', style: secondaryTextStyle(size: 16)).paddingLeft(8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  Divider(thickness: 0.1, color: Colors.grey.shade400),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: appStore.isDarkMode ? appBackGroundColor : white),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            cachedImage(wind_fan, width: 80),
                            8.height,
                            Text('${widget.weatherModel.current!.wind_kph.validate()}km/h', style: boldTextStyle()),
                            Text(appLocalization!.translate('wind_speed'), style: secondaryTextStyle()),
                          ],
                        ),
                      ),
                      16.width,
                      Column(
                        children: [
                          cachedImage(ic_sun_rise_set, width: 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${widget.weatherModel.forecast!.forecastday![0].astro!.sunrise.validate()}', style: boldTextStyle()),
                                  Text(appLocalization!.translate('sunrise'), style: secondaryTextStyle()),
                                ],
                              ).paddingLeft(8),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${widget.weatherModel.forecast!.forecastday![0].astro!.sunset.validate()}', style: boldTextStyle()),
                                  Text(appLocalization!.translate('sunset'), style: secondaryTextStyle()),
                                ],
                              ).paddingRight(8),
                            ],
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                ],
              ),
            ).paddingAll(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appLocalization!.translate('this_week'), style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16, vertical: 8),
                HorizontalList(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: widget.weatherModel.forecast!.forecastday.validate().length,
                  itemBuilder: (context, index) {
                    Day day = widget.weatherModel.forecast!.forecastday.validate()[index].day!;
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: dayWeather == index
                              ? context.cardColor
                              : appStore.isDarkMode
                                  ? card_color_dark
                                  : white,
                          borderRadius: BorderRadius.circular(defaultRadius)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${DateFormat.MMMd().format(DateFormat('yyyy-MM-dd').parse(widget.weatherModel.forecast!.forecastday.validate()[index].date.validate()))}',
                            style: secondaryTextStyle(size: 16),
                          ),
                          cachedImage('https:${day.condition!.icon.validate()}'),
                          Text('${day.maxtemp_c}° ${day.mintemp_c}°', style: boldTextStyle(size: 14)),
                        ],
                      ),
                    ).onTap(() {
                      dayWeather = index;
                      setState(() {});
                    },hoverColor: Colors.transparent,splashColor: Colors.transparent,highlightColor: Colors.transparent).paddingRight(8);
                  },
                ),
              ],
            ),
            16.height,
            Container(
              color: primaryColor.withOpacity(0.05),
              child: Stack(
                children: [
                  Positioned(bottom: 0, child: cachedImage(ic_wave, width: context.width())),
                  Container(
                    color: context.cardColor,
                    child: Column(
                      children: [
                        Align(alignment: Alignment.center, child: Text(appLocalization!.translate('major_air_pollutant'), style: boldTextStyle(size: 20))).paddingOnly(top: 8, bottom: 8),
                        Wrap(
                          children: [
                            airQualityData(ic_pm2, widget.weatherModel.current!.air_quality!.pm2_5!.round()),
                            airQualityData(ic_pm10, widget.weatherModel.current!.air_quality!.pm10!.round()),
                            airQualityData(ic_so2, widget.weatherModel.current!.air_quality!.so2!.round()),
                            airQualityData(ic_co, widget.weatherModel.current!.air_quality!.co!.round()),
                            airQualityData(ic_o3, widget.weatherModel.current!.air_quality!.o3!.round(), width: 40),
                            airQualityData(ic_no2, widget.weatherModel.current!.air_quality!.no2!.round(), width: 40),
                          ],
                        ).paddingAll(8),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget airQualityData(String image, int data, {double width = 35, double height = 35}) {
    return SizedBox(
      width: context.width() / 3 - 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          cachedImage(image, height: height, width: width, color: context.iconColor),
          8.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$data', style: boldTextStyle()),
              4.width,
              Text('μg/m3', style: secondaryTextStyle(size: 14, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    ).paddingAll(8);
  }
}
