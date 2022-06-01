import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/main.dart';

class CommentButtonWidget extends StatefulWidget {
  final ScrollController? controller;

  CommentButtonWidget(this.controller);

  @override
  CommentButtonWidgetState createState() => CommentButtonWidgetState();
}

class CommentButtonWidgetState extends State<CommentButtonWidget> {
  bool isScrollPositionedBottom = false;
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    widget.controller!.addListener(() {
      if (widget.controller!.position.pixels == widget.controller!.position.maxScrollExtent) {
        setState(() {
          isScrollPositionedBottom = true;
        });
      } else if (widget.controller!.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          isScrollPositionedBottom = false;
          isScrolling = false;
        });
      } else if (widget.controller!.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          isScrolling = true;
        });
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 750),
      opacity: isScrollPositionedBottom ? 0 : 1,
      child: Offstage(
        offstage: isScrollPositionedBottom,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () {
            widget.controller!.animToBottom(milliseconds: 250);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: primaryColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isScrolling) Text(appLocalization!.translate('comment'), style: boldTextStyle(color: Colors.white)).paddingRight(8),
                Icon(Icons.edit, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
