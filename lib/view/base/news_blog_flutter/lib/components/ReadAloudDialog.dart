import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/Images.dart';
import 'package:news_flutter/main.dart';

enum TtsState { playing, stopped, paused, continued }

class ReadAloudDialog extends StatefulWidget {
  final String text;
  static String tag = '/ReadAloudDialog';

  ReadAloudDialog(this.text);

  @override
  ReadAloudDialogState createState() => ReadAloudDialogState();
}

class ReadAloudDialogState extends State<ReadAloudDialog> with TickerProviderStateMixin {
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;
  late AnimationController animationController;
  int currentWordPosition = 0;
  int progress = 0;

  bool isError = false;

  bool isLongText = false;
  bool isLongtextComplete = false;
  int temp = 0;
  int count = 0;
  int? charLength;
  List<String> textList = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    init();
  }

  Future<void> init() async {
    isLongText = widget.text.length > 2000;

    if (isLongText) {
      charLength = (widget.text.length ~/ findMiddleFactor(widget.text.length));

      for (int i = 0; i < widget.text.length; i = i + charLength!) {
        textList.insert(temp, widget.text.substring(i, i + charLength!));
        temp = temp + 1;
      }
    }

    bool isLanguageFound = false;
    flutterTts.getLanguages.then((value) {
      Iterable it = value;
      it.forEach((element) {
        if (element.toString().contains(appStore.languageForTTS)) {
          flutterTts.setLanguage(element);
          initTTS();
          isLanguageFound = true;
        }
      });
    });
    if (!isLanguageFound) initTTS();
  }

  void checkText() async {
    if (isLongText) {
      if (!isLongtextComplete && count != textList.length) {
        speak(textList[count]);
      }
    } else {
      speak(widget.text);
    }
  }

  Future<void> initTTS() async {
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      if (isLongText) {
        count = count + 1;
        checkText();
        if (count == textList.length) {
          isLongText = false;
          isLongtextComplete = true;
        }
      } else {
        stop();
      }
    });
    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      currentWordPosition++;

      if (progress < 100) {
        progress = (currentWordPosition * 110) ~/ text.split(' ').length;

        setState(() {});
      }
    });

    flutterTts.setErrorHandler((msg) async {
      await Future.delayed(Duration(milliseconds: 500));

      if (!isError && mounted) {
        isError = true;
        ttsState = TtsState.stopped;

        finish(context);
        toast(errorSomethingWentWrong);
      }
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = TtsState.continued;
      });
    });

    await Future.delayed(Duration(milliseconds: 300));
    checkText();
  }

  Future<void> speak(String text) async {
    currentWordPosition = 0;
    progress = 0;
    animationController.forward();

    var result = await flutterTts.speak(text);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future<void> stop() async {
    currentWordPosition = 0;
    progress = 0;
    animationController.reverse();
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            nTTsImage,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(defaultRadius).opacity(opacity: 0.7),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                      onPressed: () {
                        ttsState == TtsState.playing ? stop() : checkText();
                      },
                      icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: animationController, color: Colors.black),
                    ),
                  ),
                  16.width,
                  Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: radius(defaultRadius)),
                        alignment: Alignment.centerLeft,
                        width: 200,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 800),
                        height: 10,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: radius(defaultRadius)),
                        alignment: Alignment.centerLeft,
                        width: (progress * 2).toDouble(),
                      ),
                    ],
                  ),
                ],
              ),
              30.height,
            ],
          ),
          Positioned(child: CloseButton(), top: 16, right: 16),
        ],
      ),
    );
  }
}
