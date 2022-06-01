import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/VideoListModel.dart';
import 'package:news_flutter/Screens/WebViewScreen.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';

import '../main.dart';

class VideoItemWidget extends StatefulWidget {
  static String tag = '/VideoItemWidget';

  final VideoListModel? videoData;

  VideoItemWidget({this.videoData});

  @override
  VideoItemWidgetState createState() => VideoItemWidgetState();
}

class VideoItemWidgetState extends State<VideoItemWidget> {
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
    var appLocalization = AppLocalizations.of(context);

    Widget imageWidget() {
      if (widget.videoData!.imageUrl.validate().isNotEmpty) {
        return cachedImage(widget.videoData!.imageUrl.validate(), width: context.width(), height: 280, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius);
      } else if (widget.videoData!.videoType.validate() == VideoTypeYouTube) {
        return cachedImage(widget.videoData!.videoUrl.validate().getYouTubeThumbnail(), width: context.width(), height: 280, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius);
      }
      return Container(decoration: BoxDecoration(color: Colors.grey));
    }

    return GestureDetector(
      onTap: () {
        if (widget.videoData!.videoUrl!.isNotEmpty) {
          hideKeyboard(context);
          WebViewScreen(videoType: widget.videoData!.videoType.validate(), videoUrl: widget.videoData!.videoUrl.validate()).launch(context);
        } else {
          toast(appLocalization!.translate('invalidURL'));
        }
      },
      child: Container(
        width: context.width(),
        height: 250,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageWidget(),
            Container(
              width: context.width(),
              height: context.height(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.white)),
                    child: Icon(Icons.play_arrow_rounded, color: whiteColor),
                  ),
                  16.height,
                  Text(widget.videoData!.title!, style: boldTextStyle(color: Colors.white), maxLines: 2),
                  8.height,
                  Text('${widget.videoData!.createdAt} ${appLocalization!.translate("lbl_ago")}', style: secondaryTextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).paddingAll(8);
  }
}
