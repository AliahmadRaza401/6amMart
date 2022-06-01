import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/DashboardScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';

import '../main.dart';

class ProfileFragment extends StatefulWidget {
  final bool? isTab;

  ProfileFragment({this.isTab});

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  var imageFile = '';
  File? mSelectedImage;
  String avatar = '';
  List? userDetail;

  var fNameCont = TextEditingController();
  var lNameCont = TextEditingController();
  var emailCont = TextEditingController();
  var usernameCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    log("Setting Image: ${appStore.userProfileImage.validate()}");

    fNameCont.text = appStore.userFirstName!;
    lNameCont.text = appStore.userLastName!;
    emailCont.text = appStore.userEmail!;
    usernameCont.text = appStore.userName!;

    setState(() {});
  }

  saveUser() async {
    appStore.setLoading(true);
    setState(() {});
    hideKeyboard(context);

    var request = {
      'user_email': emailCont.text,
      'first_name': fNameCont.text,
      'last_name': lNameCont.text,
      'ID': appStore.userId,
      'user_login': appStore.userLogin,
    };
    updateUser(request).then((res) async {
      if (!mounted) return;
      appStore.setLoading(false);
      setState(() {});

      await setValue(FIRST_NAME, res['data']['first_name']);
      await setValue(LAST_NAME, res['data']['last_name']);
      await setValue(USER_EMAIL, res['data']['user_email']);

      appStore.setFirstName(res['data']['first_name']);
      appStore.setLastName(res['data']['last_name']);
      appStore.setUserEmail(res['data']['user_email']);

      toast(res['message']);
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((error) {
      toast(error.toString());
      appStore.setLoading(false);
      setState(() {});
    });
  }

  pickImage(AppLocalizations? appLocalization) async {
    File image = File((await ImagePicker().pickImage(source: ImageSource.gallery))!.path);

    setState(() {
      mSelectedImage = image;
    });

    if (mSelectedImage != null) {
      showConfirmDialogCustom(
        context,
        primaryColor: primaryColor,
        title: appLocalization!.translate('conformation_upload_image'),
        onAccept: (context) async {
          var base64Image = base64Encode(mSelectedImage!.readAsBytesSync());
          var request = {'base64_img': base64Image};
          appStore.setLoading(true);
          setState(() {});
          await saveProfileImage(request).then((res) async {
            if (!mounted) return;
            appStore.setLoading(false);
            if (res['profile_image'] != null) {
              await setValue(PROFILE_IMAGE, res['profile_image']);
              appStore.setUserProfile(res['profile_image']);
            }
            toast(res['message']);
            setState(() {});
          }).catchError((error) {
            appStore.setLoading(false);
            setState(() {});
            toast(error.toString());
          });
        },
        dialogType: DialogType.CONFIRMATION,
        negativeText: appLocalization.translate('no'),
        positiveText: appLocalization.translate('yes'),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    Widget profileImage = ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: mSelectedImage == null
          ? appStore.userProfileImage!.isNotEmpty
              ? cachedImage(appStore.userProfileImage.validate(), height: 100, width: 100, fit: BoxFit.cover)
              : cachedImage(User_Profile, width: 100, height: 100, fit: BoxFit.cover)
          : cachedImage(mSelectedImage!.toString(), width: 120, height: 120, fit: BoxFit.cover),
    );

    return Stack(
      children: [
        appStore.isLoggedIn
            ? Scaffold(
                appBar: widget.isTab == false
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(50.0),
                        child: appBarWidget(
                          appLocalization!.translate('profile'),
                          center: true,
                        ),
                      )
                    : PreferredSize(preferredSize: Size.fromHeight(0.0), child: SizedBox()),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Observer(
                    builder: (_) => Column(
                      children: [
                        24.height,
                        Align(alignment: Alignment.centerLeft, child: BackWidget(color: context.iconColor)),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
// cachedImage(appStore.userProfileImage.validate(), width: 120, height: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(60).paddingAll(6),

                            Container(
                              height: 120,
                              width: 120,
                              decoration: boxDecoration(context, radius: 60, color: primaryColor, borderWidth: 4.0, bgColor: Colors.transparent),
                              child: profileImage.paddingAll(4.0),
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor, width: 2), color: white_color),
                              child: IconButton(
                                  icon: Icon(Icons.camera_alt, size: 20, color: primaryColor),
                                  onPressed: (() {
                                    pickImage(appLocalization);
                                  })),
                            ).visible(appStore.isLoggedIn && !getBoolAsync(IS_SOCIAL_LOGIN)).onTap(() {
                              pickImage(appLocalization);
                            })
                          ],
                        ),
                        24.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(appLocalization.translate('first_Name')!, style: secondaryTextStyle()),
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: fNameCont,
                              cursorColor: primaryColor,
                              decoration: inputDecoration(
                                context,
                                appLocalization!.translate('first_Name'),
                                prefixIcon: Icon(Icons.account_circle_outlined, color: Theme.of(context).textTheme.headline6!.color),
                                prefix: true,
                              ),
                            ),
                            16.height,
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: lNameCont,
                              cursorColor: primaryColor,
                              decoration: inputDecoration(context, appLocalization.translate('last_Name'),
                                  prefixIcon: Icon(Icons.account_circle_outlined, color: Theme.of(context).textTheme.headline6!.color), prefix: true),
                            ),
                            16.height,
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: usernameCont,
                              cursorColor: primaryColor,
                              decoration: inputDecoration(context, appLocalization.translate('userName'),
                                  prefixIcon: Icon(Icons.account_circle_outlined, color: Theme.of(context).textTheme.headline6!.color), prefix: true),
                            ),
                            16.height,
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: emailCont,
                              cursorColor: primaryColor,
                              readOnly: true,
                              decoration: inputDecoration(context, appLocalization.translate('email'),
                                  prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).textTheme.headline6!.color), prefix: true),
                            ),
                            16.height,
                            AppButton(
                              text: appLocalization.translate('save'),
                              textStyle: boldTextStyle(color: white_color),
                              width: context.width(),
                              color: primaryColor,
                              shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              onTap: () {
                                if (!accessAllowed) {
                                  toast(appLocalization.translate('sorry'));
                                  return;
                                }
                                if (fNameCont.text.isEmpty)
                                  toast(appLocalization.translate('first_Name') + appLocalization.translate('field_Required'));
                                else if (lNameCont.text.isEmpty)
                                  toast(appLocalization.translate('last_Name') + appLocalization.translate('field_Required'));
                                else if (emailCont.text.isEmpty)
                                  toast(appLocalization.translate('email_Address') + appLocalization.translate('field_Required'));
                                else {
                                  saveUser();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ).paddingAll(16.0),
                  ),
                ))
            : Container(
                width: context.width(),
                height: context.height(),
                color: Theme.of(context).cardTheme.color,
              ),
        Observer(builder: (_) => LoadingDotsWidget().center().visible(appStore.isLoading)),
      ],
    );
  }

  void openGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    File picture = File((await ImagePicker().getImage(source: ImageSource.gallery))!.path);
    this.setState(() {
      imageFile = picture as String;
    });
    finish(context);
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "From where do you want to take the photo?",
            style: primaryTextStyle(color: Theme.of(context).textTheme.headline6!.color),
          ),
          content: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListBody(
              children: <Widget>[
                Text(appLocalization!.translate('lbl_gallery')).onTap(() => openGallery(context)),
                Padding(padding: EdgeInsets.all(16.0)),
                GestureDetector(child: Text(appLocalization!.translate('lbl_camera')), onTap: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}
