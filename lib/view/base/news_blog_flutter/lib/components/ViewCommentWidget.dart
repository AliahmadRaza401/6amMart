import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/ViewCommentModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/ViewAllCommentScreen.dart';
import 'package:news_flutter/Screens/WriteCommentScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/SeeAllButtonWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:readmore/readmore.dart';

class ViewCommentWidget extends StatefulWidget {
  final int? id;
  final int itemLength;

  ViewCommentWidget({required this.id, required this.itemLength});

  @override
  _ViewCommentWidgetState createState() => _ViewCommentWidgetState();
}

class _ViewCommentWidgetState extends State<ViewCommentWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    LiveStream().on("ChangeComment", (p0) {
      setState(() {});
    });
    LiveStream().on("deleteComment", (p0) {
      setState(() {});
    });
    LiveStream().on("AddComment", (p0) {
      setState(() {});
    });
  }

  Future<void> deleteComment({int? id}) async {
    Map req = {"id": id, "force_delete": false};

    appStore.setLoading(true);

    await deleteCommentList(req).then((value) {
      appStore.setLoading(false);
      toast("Comment has been deleted");
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return FutureBuilder<List<ViewCommentModel>>(
      future: getCommentList(widget.id.validate()),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!.length == 0) {
            return Text(appLocalization.translate('comment') + ' (0)', style: boldTextStyle(size: 18)).paddingSymmetric(vertical: 8, horizontal: 16);
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(appLocalization.translate('comment') + ' (${snap.data.validate().length})', style: boldTextStyle(size: 24)).expand(),
                    if (snap.data!.length > 3)
                      SeeAllButtonWidget(
                        onTap: () {
                          ViewAllCommentScreen(id: widget.id.validate()).launch(context);
                          // ViewAllCommentScreen(data: snap.data.validate()).launch(context);
                        },
                        widget: Text(appLocalization.translate('see_All'), style: primaryTextStyle(color: primaryColor)),
                      )
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 8),
                ListView.separated(
                  separatorBuilder: (_, index) => Divider(color: Colors.grey.shade500, thickness: 0.1),
                  itemCount: snap.data!.take(3).length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    ViewCommentModel data = snap.data![i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: boxDecoration(context, bgColor: Colors.grey, radius: 23.0),
                              // child: cachedImage(data.author == appStore.userId ? appStore.userProfileImage.validate() : User_Profile, fit: BoxFit.cover).cornerRadiusWithClipRRect(20),
                              child: cachedImage(
                                data.author == appStore.userId ? appStore.userProfileImage.validate() : data.author_avatar_urls!.img.toString(),
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(24),
                            ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.authorName.validate().capitalizeFirstLetter(),
                                  style: boldTextStyle(size: textSizeMedium),
                                  maxLines: 2,
                                ),
                                4.height,
                                Text(data.date != null ? convertDate(data.date) : '', style: secondaryTextStyle(size: 10)),
                              ],
                            ),
                            Spacer(),
                            if (data.author == appStore.userId)
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                                            child: WriteCommentScreen(
                                              id: widget.id.validate(),
                                              hideTitle: true,
                                              commentId: data.id,
                                              isUpdate: true,
                                              editCommentText: parseHtmlString(data.content!.rendered),
                                            ),
                                          );
                                        },
                                      );
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showConfirmDialogCustom(
                                        context,
                                        title: "Do you want to delete this comment?",
                                        primaryColor: primaryColor,
                                        onAccept: (c) async {
                                          deleteComment(id: data.id);
                                        },
                                        dialogType: DialogType.DELETE,
                                        negativeText: appLocalization.translate('no'),
                                        positiveText: appLocalization.translate('yes'),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  )
                                ],
                              )
                          ],
                        ),
                        4.height,
                        ReadMoreText(
                          parseHtmlString(data.content!.rendered != null ? data.content!.rendered : ''),
                          trimLines: 2,
                          style: secondaryTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: textSizeSMedium),
                          colorClickableText: primaryColor,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...${appLocalization.translate('Read more')}',
                          trimExpandedText: appLocalization.translate('read_less'),
                        ),
                        if (data.content!.rendered.validate().isNotEmpty && data.content!.rendered.validate().length > 40) 16.height,
                      ],
                    );
                  },
                ),
              ],
            );
          }
        }
        return LoadingDotsWidget().center();
      },
    );
  }
}
