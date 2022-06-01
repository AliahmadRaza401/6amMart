import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:photo_view/photo_view.dart';

class OpenPhotoViewer extends StatefulWidget {
  final String? photoImage;

  OpenPhotoViewer({this.photoImage});

  @override
  State<OpenPhotoViewer> createState() => _OpenPhotoViewerState();
}

class _OpenPhotoViewerState extends State<OpenPhotoViewer> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent, delayInMilliSeconds: 700);
  }

  @override
  void dispose() {
    setStatusBarColor(context.cardColor, delayInMilliSeconds: 700, statusBarIconBrightness: Brightness.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: appBarWidget("", backWidget: BackWidget(color: Colors.white), color: Colors.black),
        body: PhotoView(
          imageProvider: NetworkImage(widget.photoImage.validate()),
          minScale: PhotoViewComputedScale.contained,
          maxScale: 1.0,
        ),
      ),
    );
  }
}
