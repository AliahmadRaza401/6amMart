import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/ViewCommentWidget.dart';

class ViewCommentScreen extends StatefulWidget {
  final int? id;

  @override
  _ViewCommentScreenState createState() => _ViewCommentScreenState();

  ViewCommentScreen({this.id});
}

class _ViewCommentScreenState extends State<ViewCommentScreen> {
  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    myBanner = buildBannerAd()..load();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? bannerAdIdForAndroid : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(
          // testDevices: [testDeviceId],
          ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myBanner?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: context.width(),
          height: context.height(),
          child: ViewCommentWidget(id: widget.id.validate(), itemLength: -1).paddingTop(16),
        ),
      ).center(),
      bottomNavigationBar: !isAdsDisabled
          ? Container(
              height: AdSize.banner.height.toDouble(),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
            )
          : SizedBox(),
    );
  }
}
