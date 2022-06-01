import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Screens/SearchFragment.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceSearchScreen extends StatefulWidget {
  final VoidCallback? onUpdate;
  final bool? isHome;

  VoiceSearchScreen({this.onUpdate, this.isHome});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  SpeechToText speech = SpeechToText();
  bool isListening = false;

  String text = "Listening";
  bool showButton = false;

  Future<void> listen() async {
    if (!isListening) {
      bool available = await speech.initialize();

      if (available) {
        showButton = false;
        isListening = true;

        speech.listen(onResult: (val) {
          text = val.recognizedWords;
          isListening = false;
          setState(() {});
        });

        await 5.seconds.delay;

        if (text == "Listening") {
          showButton = true;
        } else {
          finish(context, text);
          if (widget.isHome.validate()) SearchFragment(voiceText: text.validate()).launch(context);
        }
      }
    } else {
      isListening = false;
      speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      listen();
    });
    Future.delayed(10.seconds, () {
      setState(() {
        showButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: secondaryTextStyle(size: 24)).visible(!showButton),
          8.height,
          showButton
              ? Image.asset(ic_voice, height: 50, width: 50, color: primaryColor).onTap(() {
                  isListening = false;
                  setState(() {});
                  listen();
                  Future.delayed(10.seconds, () {
                    setState(() {
                      showButton = true;
                    });
                  });
                })
              : Image.asset(animation, height: 60, width: 60),
          16.height.visible(showButton),
          8.height,
          Text(
            "Tap To Speak",
            style: boldTextStyle(size: 20),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 40).visible(showButton)
        ],
      ).center(),
    );
  }
}
