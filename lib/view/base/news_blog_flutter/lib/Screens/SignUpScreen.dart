import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/DashboardScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';

import '../main.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;

  SignUpScreen({this.phoneNumber});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool? isSelectedCheck;
  var isVisibility = true;
  bool confirmPasswordVisible = false;
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;

  var fNameCont = TextEditingController();
  var lNameCont = TextEditingController();
  var emailCont = TextEditingController();
  var usernameCont = TextEditingController();
  var passwordCont = TextEditingController();

  var lNameFocus = FocusNode();
  var emailFocus = FocusNode();
  var usernameFocus = FocusNode();
  var passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isSelectedCheck = false;
  }

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      signUpApi();
    } else {
      autoValidate = true;
    }
  }

  signUpApi() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        'first_name': fNameCont.text,
        'last_name': lNameCont.text,
        'user_login': widget.phoneNumber ?? usernameCont.text,
        'user_email': emailCont.text,
        'user_pass': widget.phoneNumber ?? passwordCont.text,
      };
      appStore.setLoading(true);

      createUser(request).then((res) async {
        if (!mounted) return;
        toast(AppLocalizations.of(context)!.translate('successFully_Register'));
        appStore.setLoading(false);
        Map req = {'username': widget.phoneNumber ?? emailCont.text, 'password': widget.phoneNumber ?? passwordCont.text};
        await login(req).then((value) async {
          appStore.setLoading(false);
          setState(() {});
          if (widget.phoneNumber != null) await setValue(LOGIN_TYPE, SignInTypeOTP);

          DashboardScreen().launch(context, isNewTask: true);
        }).catchError((e) {
          appStore.setLoading(false);

          setState(() {});
        });
      }).catchError((error) {
        appStore.setLoading(false);
        setState(() {});
        toast(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? card_color_dark : card_color_light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      finish(context);
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cachedImage(ic_logo, height: 100, width: 100).cornerRadiusWithClipRRect(defaultRadius),
                      8.height,
                      Text(AppName, style: boldTextStyle(size: 32)),
                    ],
                  ).center(),
                  Column(
                    children: [
                      16.height,
                      Text(appLocalization.translate('getting_Started'), style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: textSizeLargeMedium)),
                      8.height,
                      Text(appLocalization.translate('create_an_Account_continue'), style: secondaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeMedium)),
                      16.height,
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AppTextField(
                              controller: fNameCont,
                              textFieldType: TextFieldType.NAME,
                              decoration: inputDecoration(
                                context,
                                appLocalization.translate('first_Name'),
                                prefix: true,
                                prefixIcon: cachedImage(ic_profile, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: lNameFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            AppTextField(
                              controller: lNameCont,
                              focus: lNameFocus,
                              textFieldType: TextFieldType.NAME,
                              decoration: inputDecoration(
                                context,
                                appLocalization.translate('last_Name'),
                                prefix: true,
                                prefixIcon: cachedImage(ic_profile, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: widget.phoneNumber != null ? emailFocus : usernameFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            AppTextField(
                              controller: usernameCont,
                              focus: usernameFocus,
                              textFieldType: TextFieldType.NAME,
                              decoration: inputDecoration(
                                context,
                                appLocalization.translate('userName'),
                                prefix: true,
                                prefixIcon: cachedImage(ic_profile, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: emailFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ).visible(widget.phoneNumber == null),
                            16.height,
                            AppTextField(
                              controller: emailCont,
                              focus: emailFocus,
                              textFieldType: TextFieldType.EMAIL,
                              decoration: inputDecoration(
                                context,
                                appLocalization.translate('email_Address'),
                                prefix: true,
                                prefixIcon: cachedImage(ic_email, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              errorInvalidEmail: '${appLocalization.translate('EmailToast')} + ${appLocalization.translate('field_Required')}',
                              nextFocus: widget.phoneNumber != null ? null : passwordFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            TextFormField(
                              controller: passwordCont,
                              focusNode: passwordFocus,
                              decoration: inputDecoration(
                                context,
                                appLocalization.translate('password'),
                                suffix: true,
                                suffixIcon: cachedImage(isVisibility ? ic_hide : ic_show, height: 16, width: 16, color: Colors.grey.shade500),
                                onIconTap: () {
                                  setState(() {
                                    isVisibility = !isVisibility;
                                  });
                                },
                                prefix: true,
                                prefixIcon: cachedImage(ic_password, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                              textInputAction: TextInputAction.done,
                              validator: (s) {
                                if (s.validate().isEmpty) {
                                  return errorThisFieldRequired;
                                } else if (s.validate().length < 6) {
                                  return appLocalization.translate('PasswordToast');
                                }
                                return null;
                              },
                            ).visible(widget.phoneNumber == null),
                          ],
                        ),
                      ),
                      16.height,
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isSelectedCheck,
                              side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: Colors.grey.shade500)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              activeColor: primaryColor,
                              checkColor: Colors.white,
                              onChanged: (val) {
                                setState(() {
                                  isSelectedCheck = val;
                                });
                              },
                            ),
                          ),
                          8.width,
                          RichTextWidget(
                            list: [
                              TextSpan(
                                text: appLocalization.translate('termCondition') + ' ',
                                style: primaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeSmall),
                              ),
                              TextSpan(
                                text: appLocalization.translate('terms'),
                                style: primaryTextStyle(color: primaryColor, size: textSizeSmall),
                                recognizer: TapGestureRecognizer()..onTap = () => redirectUrl(getStringAsync(TERMS_AND_CONDITIONS)),
                              ),
                            ],
                          ).expand(),
                        ],
                      ),
                      16.height,
                      AppButton(
                          width: context.width(),
                          color: primaryColor,
                          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          text: appLocalization.translate('sign_Up'),
                          elevation: 0,
                          textStyle: primaryTextStyle(color: white_color, size: textSizeLargeMedium),
                          onTap: () {
                            if (!accessAllowed) {
                              toast(appLocalization.translate('sorry'));
                              return;
                            }
                            if (isSelectedCheck!) {
                              signUpApi();
                            } else {
                              toast(appLocalization.translate('Accept_Terms'));
                            }
                          }).paddingOnly(left: 16.0, right: 16.0),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(appLocalization.translate('have_an_Account') + '? ', style: secondaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeMedium)),
                          Container(
                            margin: EdgeInsets.only(left: 4),
                            child: GestureDetector(
                                child: Text(appLocalization.translate('sign_In'), style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: textSizeMedium.toDouble())),
                                onTap: () {
                                  finish(context);
                                }),
                          )
                        ],
                      ),
                      16.height,
                    ],
                  ).paddingAll(16.0),
                ],
              ),
            ),
          ),
        ),
        Observer(builder: (_) => Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading)),
      ],
    );
  }
}
