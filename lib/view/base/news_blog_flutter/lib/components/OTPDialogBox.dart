import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Network/AuthService.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/DashboardScreen.dart';
import 'package:news_flutter/Screens/SignUpScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/main.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPDialogBox extends StatefulWidget {
  static String tag = '/OTPDialog';
  final String? verificationId;
  final String? phoneNumber;
  final bool? isCodeSent;
  final PhoneAuthCredential? credential;

  OTPDialogBox({this.verificationId, this.isCodeSent, this.phoneNumber, this.credential});

  @override
  OTPDialogBoxState createState() => OTPDialogBoxState();
}

class OTPDialogBoxState extends State<OTPDialogBox> {
  TextEditingController numberController = TextEditingController();

  String? countryCode = '';

  String otpCode = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> submit(AppLocalizations? appLocale) async {
    appStore.setLoading(true);
    setState(() {});

    AuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: otpCode.validate());

    await FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
      Map req = {
        'username': widget.phoneNumber!.replaceAll('+', ''),
        'password': widget.phoneNumber!.replaceAll('+', ''),
      };

      appStore.setLoading(true);
      await login(req).then((value) async {
        appStore.setLoading(false);

        await setValue(IS_SOCIAL_LOGIN, true);
        await setValue(LOGIN_TYPE, SignInTypeOTP);
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        appStore.setLoading(false);
        if (e.toString().contains('invalid_username')) {
          finish(context);
          finish(context);
          SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', '')).launch(context);

          toast(appLocale!.translate('sign_up_to_continue'));
        } else {
          toast(e.toString());
        }
      });
    }).catchError((e) {
      toast(errorSomethingWentWrong);
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> sendOTP(AppLocalizations? appLocale) async {
    if (numberController.text.trim().isEmpty) {
      return toast(errorThisFieldRequired);
    }
    appStore.setLoading(true);
    setState(() {});
    String number = '+$countryCode${numberController.text.trim()}';
    if (!number.startsWith('+')) {
      number = '+$countryCode${numberController.text.trim()}';
    }

    await signInWithOTP(context, number).then((value) {
      //
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return Container(
      width: context.width(),
      child: !widget.isCodeSent.validate()
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appLocalization!.translate('enter_your_no'), style: boldTextStyle()),
                24.height,
                Container(
                  height: 90,
                  child: Row(
                    children: [
                      CountryCodePicker(
                        initialSelection: 'IN',
                        showCountryOnly: false,
                        showFlag: true,
                        showFlagDialog: true,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        textStyle: primaryTextStyle(),
                        onInit: (c) {
                          countryCode = c!.dialCode;
                        },
                        onChanged: (c) {
                          countryCode = c.dialCode;
                        },
                      ),
                      8.width,
                      AppTextField(
                        controller: numberController,
                        textFieldType: TextFieldType.PHONE,
                        decoration: inputDecoration(context, appLocalization.translate('phone_no')),
                        autoFocus: true,
                        cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                        onFieldSubmitted: (s) {
                          sendOTP(appLocalization);
                        },
                      ).expand(),
                    ],
                  ),
                ),
                30.height,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AppButton(
                      onTap: () {
                        sendOTP(appLocalization);
                        hideKeyboard(context);
                      },
                      text: appLocalization.translate('send_otp'),
                      width: context.width(),
                      color: primaryColor,
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      textStyle: primaryTextStyle(color: white_color, size: textSizeLargeMedium),
                    ),
                    Positioned(
                      //right: 16,
                      child: Observer(builder: (_) => Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).visible(appStore.isLoading)),
                    ),
                  ],
                )
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(appLocalization!.translate('enter_otp_received'), style: boldTextStyle()),
                30.height,
                OTPTextField(
                  length: 6,
                  width: context.width(),
                  fieldWidth: 35,
                  style: primaryTextStyle(),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onChanged: (s) {
                    otpCode = s;
                  },
                  onCompleted: (pin) {
                    otpCode = pin;
                    submit(appLocalization);
                  },
                ).fit(),
                30.height,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AppButton(
                      onTap: () {
                        submit(appLocalization);
                      },
                      child: Text(appLocalization.translate('confirm'),style: boldTextStyle(color: white)),
                      color: primaryColor,
                      width: context.width(),
                    ),
                    Positioned(
                      child: Observer(builder: (_) => Loader().visible(appStore.isLoading)),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
