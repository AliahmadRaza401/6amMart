import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class YouTubeEmbedWidget extends StatelessWidget {
  final String videoId;
  final bool? fullIFrame;

  YouTubeEmbedWidget(this.videoId, {this.fullIFrame});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: IgnorePointer(
        child: Html(
          data: fullIFrame.validate()
              ? '<html><iframe style="width:100%" height="260" src="$videoId"></iframe></html>'
              : '<html><iframe style="width:100%" height="260" frameborder="0" src="https://www.youtube.com/embed/$videoId" allow="autoplay; fullscreen" allowfullscreen="allowfullscreen"></iframe></html>',
        ),
      ).center(),
    ).onTap(() {
      url_launcher.launch('https://www.youtube.com/embed/$videoId', forceWebView: true);
    });
  }
}
