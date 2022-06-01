import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/NotificationModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/NewsDetailScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/main.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  NotificationListScreenState createState() => NotificationListScreenState();
}

class NotificationListScreenState extends State<NotificationListScreen> {
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

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: appBarWidget(
        appLocalization.translate('lbl_notification'),
        elevation: 0.2,
        center: true,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: SnapHelperWidget<NotificationModel>(
        future: getNotificationList(),
        onSuccess: (NotificationModel data) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: data.data!.length,
            itemBuilder: (context, index) {
              Data model = data.data![index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cachedImage(model.image.validate(), width: 70, height: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(parseHtmlString(model.title.validate()), style: primaryTextStyle()),
                      8.height,
                      Text(DateFormat('yyyy-MM-dd').parse(model.datetime.validate()).timeAgo, style: secondaryTextStyle()),
                    ],
                  ).expand(),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 8).onTap(() {
                NewsDetailScreen(newsId: model.post_id).launch(context);
              });
            },
            separatorBuilder: (_, i) => Divider(thickness: 0.1, color: Colors.grey.shade500),
          ).paddingSymmetric(vertical: 8);
        },
        loadingWidget: LoadingDotsWidget().center(),
      ),
    );
  }
}
