import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/components/HtmlWidget.dart';

import '../main.dart';

class QuickNewsPostDialogWidget extends StatefulWidget {
  final PostModel postModel;

  QuickNewsPostDialogWidget({required this.postModel});

  @override
  State<QuickNewsPostDialogWidget> createState() => _QuickNewsPostDialogWidgetState();
}

class _QuickNewsPostDialogWidgetState extends State<QuickNewsPostDialogWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String postContent = '';

  @override
  void initState() {
    super.initState();
    postContent = widget.postModel.postContent
        .validate()
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('[embed]', '<embed>')
        .replaceAll('[/embed]', '</embed>')
        .replaceAll('[caption]', '<caption>')
        .replaceAll('[/caption]', '</caption>')
        .replaceAll('[blockquote]', '<blockquote>')
        .replaceAll('[/blockquote]', '</blockquote>');

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 700));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AbsorbPointer(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: ScaleTransition(
            scale: _animation,
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.transparent)),
              backgroundColor: context.cardColor,
              insetPadding: EdgeInsets.only(left: 12, top: 24, right: 12, bottom: 24),
              child: SizedBox(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.postModel.postTitle.validate(), style: boldTextStyle(size: 22)),
                      Divider(thickness: 0.1),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: cachedImage(
                          widget.postModel.image.validate(),
                          height: 180.0,
                          width: context.width(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Divider(thickness: 0.1, color: Colors.grey),
                      8.height,
                      HtmlWidget(postContent: postContent),
                    ],
                  ).flexible(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
