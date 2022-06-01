import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Network/AuthService.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/DashboardScreen.dart';
import 'package:news_flutter/Screens/SignUpScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/OTPDialogBox.dart';
import 'package:news_flutter/main.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool? isSelectedCheck = false;
  var isVisibility = true;
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;

  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();

  var passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (isIOS) {
      TheAppleSignIn.onCredentialRevoked!.listen((_) {
        log("Credentials revoked");
      });
    }

    if (!getBoolAsync(IS_SOCIAL_LOGIN) && getBoolAsync(IS_REMEMBERED)) {
      emailCont.text = getStringAsync(USER_EMAIL_USERNAME);
      passwordCont.text = getStringAsync(USER_PASSWORD);
    }
  }

  Future<void> signInApi(req) async {
    appStore.setLoading(true);
    await login(req).then((res) async {
      appStore.setLoading(false);

      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  Future<void> validate() async {
    hideKeyboard(context);
    if (!accessAllowed) {
      toast("Sorry");
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      var request = {
        "username": "${emailCont.text}",
        "password": "${passwordCont.text}",
      };

      if (emailCont.text.isEmpty)
        toast(Email_Address + Field_Required);
      else if (passwordCont.text.isEmpty)
        toast(Password + Field_Required);
      else {
        await setValue(USER_PASSWORD, passwordCont.text);
        await setValue(USER_EMAIL_USERNAME, emailCont.text);
        await signInApi(request);
      }
    } else {
      autoValidate = true;
    }

  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    Widget socialButtons = Column(
      children: [
        AppButton(
          width: context.width(),
          color: context.cardColor,
          elevation: 0,
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GoogleLogoWidget(size: 18),
              16.width,
              Text(appLocalization!.translate("lbl_google"), style: secondaryTextStyle(size: textSizeLargeMedium)),
            ],
          ),
          onTap: () async {
            appStore.setLoading(true);

            await LogInWithGoogle().then((user) async {
              appStore.setLoading(false);

              DashboardScreen().launch(context, isNewTask: true);
            }).catchError((e) {
              appStore.setLoading(false);
              log("Error : ${e.toString()}");
              throw errorSomethingWentWrong;
            });
          },
        ).paddingOnly(left: 16.0, right: 16.0),
        16.height,
        AppButton(
          width: context.width(),
          color: context.cardColor,
          elevation: 0,
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ic_CallRing, color: appStore.isDarkMode ? white : primaryColor, width: 22, height: 22),
              16.width,
              Text(appLocalization.translate("lbl_phone_number"), style: secondaryTextStyle(size: textSizeLargeMedium)),
            ],
          ),
          onTap: () async {
            await showInDialog(
              context,
              builder: (_) => OTPDialogBox(),
              shape: dialogShape(),
              backgroundColor: context.scaffoldBackgroundColor,
              barrierDismissible: false,
            ).catchError((e) {
              toast(e.toString());
            });
          },
        ).paddingOnly(left: 16.0, right: 16.0),
        if (isIOS)
          AppButton(
            width: context.width(),
            color: appStore.isDarkMode ? appBackGroundColor : Colors.grey.shade200,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ic_Apple, color: appStore.isDarkMode ? white : black, width: 24, height: 24),
                8.width,
                Text(appLocalization.translate("lbl_apple"), style: primaryTextStyle(size: textSizeLargeMedium)),
              ],
            ),
            onTap: () async {
              appStore.setLoading(true);

              await appleSignIn().then((value) {
                appStore.setLoading(false);

                DashboardScreen().launch(context, isNewTask: true);
              }).catchError((e) {
                toast(e.toString());
                appStore.setLoading(false);
                setState(() {});
              });
            },
          ).paddingAll(16),
      ],
    );

    return Scaffold(
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              SizedBox(
                width: context.width(),
                height: context.height(),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: context.statusBarHeight),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () {
                              finish(context);
                            },
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            cachedImage(ic_logo, height: 90, width: 90).cornerRadiusWithClipRRect(defaultRadius),
                            8.height,
                            Text(AppName, style: boldTextStyle(size: 32)),
                          ],
                        ),
                        16.height,
                        Text(appLocalization.translate('title_For_Sign_In'), style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: textSizeLarge)),
                        8.height,
                        Text(appLocalization.translate('welcome_Msg_for_SignIn'), style: secondaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeSMedium)),
                        24.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AppTextField(
                              controller: emailCont,
                              textFieldType: TextFieldType.NAME,
                              decoration: inputDecoration(
                                context,
                                '${appLocalization.translate('email') + " / " + appLocalization.translate('userName')}',
                                prefix: true,
                                prefixIcon: cachedImage(ic_email, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: passwordFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            TextFormField(
                              controller: passwordCont,
                              obscureText: isVisibility,
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
                              style: primaryTextStyle(),
                              focusNode: passwordFocus,
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
                              onFieldSubmitted: (s) {
                                validate();
                              },
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: getBoolAsync(IS_REMEMBERED, defaultValue: false),
                                    side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: Colors.grey.shade500)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    activeColor: primaryColor,
                                    checkColor: white,
                                    onChanged: (v) {
                                      isSelectedCheck = v;
                                      setValue(IS_REMEMBERED, v);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                4.width,
                                TextButton(
                                  onPressed: () {
                                    setValue(IS_REMEMBERED, !getBoolAsync(IS_REMEMBERED));
                                    isSelectedCheck = !isSelectedCheck!;
                                    setState(() {});
                                  },
                                  child: Text(
                                    appLocalization.translate('Remember'),
                                    style: primaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeSMedium),
                                  ),
                                ),
                              ],
                            ).expand(),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CustomDialog(),
                                );
                              },
                              child: Text(
                                appLocalization.translate('forgot_Password'),
                                style: primaryTextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        24.height,
                        AppButton(
                          width: context.width(),
                          color: primaryColor,
                          elevation: 0,
                          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          child: Text(appLocalization.translate('sign_In'), style: primaryTextStyle(color: white_color, size: textSizeLargeMedium)),
                          onTap: () {
                            validate();
                          },
                        ).paddingOnly(left: 16.0, right: 16.0),
                        24.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              appLocalization.translate('don_t_have_account'),
                              style: secondaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeMedium),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: GestureDetector(
                                child: Text(
                                  appLocalization.translate('sign_Up'),
                                  style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: textSizeMedium.toDouble()),
                                ),
                                onTap: () {
                                  SignUpScreen().launch(context);
                                },
                              ),
                            )
                          ],
                        ),
                        16.height,
                        Text(appLocalization.translate('lbl_OR'), style: secondaryTextStyle()),
                        16.height,
                        Text(appLocalization.translate('lbl_sign_in_with'), style: secondaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color, size: textSizeMedium)),
                        16.height,
                        socialButtons,
                        16.height,
                      ],
                    ),
                  ),
                ),
              ),
              Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading),
            ],
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
  var email = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    forgotPwdApi() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        hideKeyboard(context);

        var request = {
          'email': email.text,
        };

        appStore.setLoading(true);

        forgotPassword(request).then((res) {
          appStore.setLoading(false);

          toast('Successfully Send Email');
          finish(context);
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      }
    }

    var appLocalization = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: boxDecoration(context, color: white_color, radius: 10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Text(appLocalization.translate('forgot_Password'), style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: textSizeLargeMedium)),
                    24.height,
                    AppTextField(
                      controller: email,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(context, appLocalization.translate('email_Address')),
                      autoFocus: true,
                      validator: (s) {
                        if (s.validate().isEmpty) {
                          return errorThisFieldRequired;
                        }
                        return null;
                      },
                      cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ],
                ).paddingOnly(left: 16.0, right: 16.0, bottom: 16.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: AppButton(
                    child: Text(appLocalization.translate('send'), style: primaryTextStyle(color: white_color, size: textSizeLargeMedium)),
                    height: 50,
                    color: primaryColor,
                    elevation: 0,
                    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    onTap: () {
                      if (!accessAllowed) {
                        toast(appLocalization.translate('sorry'));
                        return;
                      } else
                        appStore.setLoading(true);
                      forgotPwdApi();
                    },
                  ),
                ).paddingAll(16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
