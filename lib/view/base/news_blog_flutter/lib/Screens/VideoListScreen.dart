import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/VideoListModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/VideoItemWidget.dart';
import 'package:news_flutter/main.dart';

class VideoListScreen extends StatefulWidget {
  @override
  VideoListScreenState createState() => VideoListScreenState();
}

class VideoListScreenState extends State<VideoListScreen> {
  List<VideoListModel> videoListing = [];
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextCont = TextEditingController();

  int page = 1;
  int numPages = 0;

  int? timer;

  bool mIsLastPage = false;
  bool mIsVideoLoaded = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    scrollController.addListener(() {
      if (mIsVideoLoaded && (scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;
          appStore.setLoading(true);
          setState(() {});
          getVideoListData();
        }
      }
    });
    if (allowPreFetched) {
      String data = getStringAsync(videoListData);
      if (data.isNotEmpty) {
        afterBuildCreated(() {
          setData(jsonDecode(data));
        });
      }
    }
    getVideoListData();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void getVideoListData({String? search}) async {
    appStore.setLoading(videoListing.isEmpty);

    setState(() {});
    Map req = {
      'search': search.validate(),
    };
    getVideoList(req, page).then((res) async {
      if (!mounted) return;
      mIsVideoLoaded = true;
      hideKeyboard(context);

      if (page == 1) {
        await setValue(videoListData, jsonEncode(res));

        videoListing.clear();
      }

      setData(res);
      timer = null;
      appStore.setLoading(false);
    }).catchError((error) {
      appStore.setLoading(false);
      if (!mounted) return;
      toast(error.toString());
    });
  }

  void setData(res) {
    appStore.setLoading(false);
    Iterable listVideo = res['data'];

    mIsLastPage = listVideo.length != 5;

    videoListing.addAll(listVideo.map((model) => VideoListModel.fromJson(model)).toList());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
     // backgroundColor: context.cardColor,
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                padding: EdgeInsets.only(top: context.statusBarHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalization.translate('Videos'), style: boldTextStyle(size: 24)).paddingAll(16),

                    /*TextField(
                      cursorColor: Theme.of(context).textTheme.headline6!.color,
                      controller: searchTextCont,
                      style: primaryTextStyle(color: Theme.of(context).textTheme.headline6!.color),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : app_Background,
                        border: InputBorder.none,
                        hintStyle: primaryTextStyle(color: appStore.isDarkMode ? grey : Theme.of(context).textTheme.subtitle1!.color, size: textSizeMedium),
                        hintText: appLocalization.translate('lbl_search_video'),
                        suffixIcon: Icon(Icons.clear, color: primaryColor).onTap(() {
                          if (searchTextCont.text.isEmpty) {
                            hideKeyboard(context);
                          } else {
                            searchTextCont.text = '';

                            page = 1;
                            videoListing.clear();
                            getVideoListData();
                          }
                        }),
                      ),
                      maxLines: 1,
                      onChanged: (s) async {
                        page = 1;
                        if (timer == null) {
                          timer = 1500;
                          await 1500.milliseconds.delay;
                          videoListing.clear();
                          getVideoListData(search: searchTextCont.text);
                        }
                      },
                    ).cornerRadiusWithClipRRect(defaultRadius).paddingAll(16),*/
                    ListView.builder(
                      itemCount: videoListing.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(bottom: 16, right: 8, left: 8),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        VideoListModel video = videoListing[i];

                        return VideoItemWidget(videoData: video);
                      },
                    ),
                  ],
                ),
              ),
              //VideoShimmer().paddingTop(70).visible(appStore.isLoading && page == 1),
              Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading && page != 1),
              Text(appLocalization.translate('lbl_no_data_found'), style: secondaryTextStyle()).center().visible(!appStore.isLoading && videoListing.isEmpty),
            ],
          );
        },
      ),
    );
  }
}
