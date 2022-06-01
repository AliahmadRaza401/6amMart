import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImageScreen extends StatefulWidget {
  final mProductImage;

  ZoomImageScreen({Key? key, this.mProductImage}) : super(key: key);

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBarWidget("", center: true,backWidget: BackWidget(color: context.iconColor),showBack: true),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.mProductImage),
        ),
      ),
    );
  }
}
