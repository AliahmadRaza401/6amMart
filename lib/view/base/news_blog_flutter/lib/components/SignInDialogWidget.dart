import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BottomsheetAnimation.dart';
import 'package:news_flutter/main.dart';

class SignInDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);
    return BottomSheetAnimation(
      beginOffset: Offset(0.0, -1.0),
      endOffset: Offset(0.0, 0.3),
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade500),
        ),
        margin: EdgeInsets.only(left: 8, top: 32, right: 8, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                globalOverlayHandler.removeOverlay(context);
              },
              icon: Icon(Icons.close),
            ).paddingOnly(top: 8, left: 4),
            Text(appLocalization!.translate('title_For_Sign_In'), style: boldTextStyle(color: Theme.of(context).textTheme.headline6!.color, size: textSizeLarge)).center(),
            16.height,
            Column(
              children: [
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(context, '${appLocalization.translate('email') + " / " + appLocalization.translate('userName')}'),
                  cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.PASSWORD,
                  decoration: inputDecoration(context, appLocalization.translate('password')),
                  cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                  textInputAction: TextInputAction.done,
                  errorMinimumPasswordLength: '${appLocalization.translate('PasswordToast')}',
                  onFieldSubmitted: (s) {
                    //
                  },
                ),
                16.height,
                NewsButton(
                  content: Text(appLocalization.translate('sign_In'), style: primaryTextStyle()),
                  onPressed: () {
                    //
                  },
                ),
              ],
            ).paddingAll(16),
          ],
        ),
      ),
    );
  }
}
