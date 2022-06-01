import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/constant.dart';
import 'package:news_flutter/components/OTPDialogBox.dart';
import 'package:news_flutter/main.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

// ignore: non_constant_identifier_names
Future<User> LogInWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user!;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != '');

    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);

    String firstName = '';
    String lastName = '';

    if (currentUser.displayName.validate().split(' ').length >= 1) firstName = currentUser.displayName.splitBefore(' ');
    if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

    await setValue(PROFILE_IMAGE, currentUser.photoURL);


    appStore.setUserProfile(currentUser.photoURL);
    log("User Image ${appStore.userProfileImage.validate()}");

    Map req = {
      "email": currentUser.email,
      "firstName": firstName,
      "lastName": lastName,
      "photoURL": currentUser.photoURL,
      "accessToken": googleSignInAuthentication.accessToken,
      "loginType": SignInTypeGoogle,
    };

    await googleSignIn.signOut();

    return await login(req, isSocialLogin: true).then((value) {
      appStore.setLoading(false);
      return currentUser;
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<void> signInWithOTP(BuildContext context, String phoneNumber) async {
  return await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      //
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        toast('The provided phone number is not valid.');
        throw 'The provided phone number is not valid.';
      } else {
        toast(e.toString());
        throw e.toString();
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      finish(context);
      await showInDialog(context, builder: (_) => OTPDialogBox(verificationId: verificationId, isCodeSent: true, phoneNumber: phoneNumber), shape: dialogShape(), barrierDismissible: false);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      //
    },
  );
}

Future<void> appleSignIn() async {
  if (await TheAppleSignIn.isAvailable()) {
    AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        if (result.credential!.email == null) {
          appStore.setLoading(true);
          return await saveAppleDataWithoutEmail().then((value) {
            appStore.setLoading(false);
          }).catchError((e) {
            appStore.setLoading(false);
            throw e;
          });
        } else {
          appStore.setLoading(true);
          return await saveAppleData(result).then((value) {
            appStore.setLoading(false); //
          }).catchError((e) {
            appStore.setLoading(false);
            throw e;
          });
        }
      case AuthorizationStatus.error:
        throw ("Sign in failed: ${result.error!.localizedDescription}");
      case AuthorizationStatus.cancelled:
        throw ('User cancelled');
    }
  } else {
    throw ('Apple SignIn is not available for your device');
  }
}

Future<void> saveAppleDataWithoutEmail() async {
  var req = {
    'email': getStringAsync('appleEmail'),
    'firstName': getStringAsync('appleGivenName'),
    'lastName': getStringAsync('appleFamilyName'),
    'photoURL': '',
    'accessToken': '12345678',
    'loginType': SignInTypeApple,
  };

  return await login(req, isSocialLogin: true).then((value) {}).catchError((e) {
    throw e;
  });
}

Future<void> saveAppleData(AuthorizationResult result) async {
  await setValue('appleEmail', result.credential!.email);
  await setValue('appleGivenName', result.credential!.fullName!.givenName);
  await setValue('appleFamilyName', result.credential!.fullName!.familyName);

  log('Email:- ${getStringAsync('appleEmail')}');
  log('appleGivenName:- ${getStringAsync('appleGivenName')}');
  log('appleFamilyName:- ${getStringAsync('appleFamilyName')}');

  var req = {
    'email': result.credential!.email,
    'firstName': result.credential!.fullName!.givenName,
    'lastName': result.credential!.fullName!.familyName,
    'photoURL': '',
    'accessToken': '12345678',
    'loginType': SignInTypeApple,
  };
  return await login(req, isSocialLogin: true).then((value) {
    log(value);
  }).catchError((e) {
    throw e;
  });
}
