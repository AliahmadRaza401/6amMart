import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as html_widget;
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/videoPlayer/chewie_player.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String? title;
  final String? videoUrl;
  final String? videoType;

  @override
  _WebViewScreenState createState() => _WebViewScreenState();

  WebViewScreen({this.title, this.videoUrl, this.videoType});
}

class _WebViewScreenState extends State<WebViewScreen> {
  VideoPlayerController? videoPlayerController;

  //YoutubePlayerController youtubeVideoController;
  VideoPlayerController? customController;
  ChewieController? _chewieController;
  double height = 300;
  bool onclickBack = false;

  bool mShowingAppBar = true;
  String url = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(seconds: 2));
    mShowingAppBar = false;
    setState(() {});
  }

  void afterFirstLayout(BuildContext context) async {
    if (context.width() >= desktopBreakpointGlobal) {
      height = 400;
    }

    setState(() {});
    await Future.delayed(Duration(seconds: 2));
    mShowingAppBar = false;
    setState(() {});

    if (widget.videoType.validate() == VideoTypeYouTube) {
      url = widget.videoUrl.validate().convertYouTubeUrlToId();
    } else if (widget.videoType.validate() == VideoTypeIFrame) {
      url = widget.videoUrl.validate();

      videoPlayerController = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
      videoPlayerController!.play();
    } else if (widget.videoType.validate() == VideoCustomUrl) {
      url = widget.videoUrl.validate();

      customController = VideoPlayerController.network(url);
      customController!.play();
    } else {
      mShowingAppBar = true;

      url = widget.videoUrl.validate();
    }

    appStore.setLoading(false);
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    customController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget player() {
      if (appStore.isLoading) {
        return Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white));
      } else if (widget.videoType.validate() == VideoTypeYouTube) {
        return WebView(initialUrl: 'https://www.youtube.com/embed/${widget.videoUrl.convertYouTubeUrlToId()}', javascriptMode: JavascriptMode.unrestricted);
      } else if (widget.videoType.validate() == VideoTypeIFrame) {
        return SizedBox(
          width: context.width(),
          child: html_widget.HtmlWidget(
            '<html>${widget.videoUrl.validate()}</html>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        );
      } else if (customController != null && widget.videoType.validate() == VideoCustomUrl) {
        _chewieController = ChewieController(
          videoPlayerController: customController!,
          aspectRatio: 3 / 2,
          autoPlay: true,
          looping: false,
          placeholder: Container(color: Colors.grey),
        );
        return Center(child: Chewie(controller: _chewieController!));
      } else {
        return WebView(initialUrl: widget.videoUrl.validate(), javascriptMode: JavascriptMode.unrestricted);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).cardTheme.color,
          appBar: appBarWidget(
            "",
            elevation: 0,
            showBack: true,
            backWidget: BackWidget(color: context.iconColor),
            color: appStore.isDarkMode ? appBackGroundColor : white,
          ),
          body: player().center(),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends html_widget.WidgetFactory {
  // optional: override getter to configure how WebViews are built
  bool get webView => true;
}
