import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Screens/VoiceSearchScreen.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/app_localizations.dart';
import 'package:news_flutter/components/BackWidget.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/NewsItemWidget.dart';
import 'package:news_flutter/components/NoDataWidget.dart';
import 'package:news_flutter/main.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchFragment extends StatefulWidget {
  final bool? isVoiceSearch;
  final String? voiceText;

  SearchFragment({this.isVoiceSearch, this.voiceText});

  @override
  _SearchFragmentState createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  List<PostModel> searchList = [];
  TextEditingController searchCont = TextEditingController();
  FocusNode searchNode = FocusNode();
  ScrollController scrollController = ScrollController();
  int page = 1;
  int numPages = 0;

  int? timer;

  //Add Code
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    if (widget.voiceText.validate().isNotEmpty) {
      searchCont.text = widget.voiceText.toString();
      getSearchListing();
    }

    afterBuildCreated(() {
      _initSpeech();
      if (widget.isVoiceSearch.validate()) {
        startListening(context);
      }
    });

    scrollController.addListener(
      () {
        if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
          if (numPages > page) {
            page++;

            setState(() {});

            getSearchListing();
          }
        }
      },
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening(BuildContext context) async {
    hideKeyboard(context);
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// listen method.
  Future<void> stopListening(BuildContext context) async {
    hideKeyboard(context);
    await _speechToText.stop();
    setState(() {});
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    _lastWords = result.recognizedWords;
    searchCont.text = _lastWords;
    if (_lastWords.isNotEmpty) {
      stopListening(context);
      await getSearchListing();
    }
  }

  Future<void> getSearchListing() async {
    Map req = {
      "text": searchCont.text,
    };
    appStore.setLoading(true);
    await getSearchBlogList(req, page).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      searchList.clear();
      searchList.addAll(res.posts.validate());

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log("Error: ${error.toString()}");
      setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchNode.dispose();
    if (_speechToText.isListening) {
      stopListening(context);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () async {
        await 2.seconds.delay;
        setState(() {});
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: context.scaffoldBackgroundColor,
          titleSpacing: 0,
          leading: BackWidget(color: context.iconColor),
          title: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: searchCont,
            focusNode: searchNode,

            // autofocus: true,
            textInputAction: TextInputAction.done,
            cursorColor: primaryColor,
            style: primaryTextStyle(),
            onChanged: (String searchTxt) async {
              setState(() async {
                page = 1;
                if (searchTxt.length > 0) {
                  if (timer == null) {
                    timer = 1500;
                    await timer.milliseconds.delay;
                    searchList.clear();
                    appStore.setLoading(true);
                    await getSearchListing();
                    timer = null;
                  }
                } else {
                  searchList.clear();
                  toast('Please enter text');
                }
              });
            },
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: context.scaffoldBackgroundColor,
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: primaryTextStyle(),
              hintText: appLocalization.translate('search'),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.mic, color: primaryColor),
              // icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              color: primaryColor,
              onPressed: () async {
                String? val = await VoiceSearchScreen().launch(context);
                if(val is String && val.validate().isNotEmpty){
                  searchCont.text = val.validate();
                  getSearchListing();
                }
                // _speechToText.isNotListening ? startListening(context) : stopListening(context);
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            IconButton(
              icon: Icon(Icons.close),
              color: primaryColor,
              onPressed: () {
                searchCont.clear();
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appLocalization.translate('lbl_found'), style: boldTextStyle(size: 18)).paddingAll(16),
                ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: searchList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    PostModel post = searchList[i];

                    return NewsItemWidget(post, data: searchList, index: i);
                  },
                ).expand(),
              ],
            ),
            if (searchList.isEmpty && !appStore.isLoading) Positioned(left: 0, top: 0, right: 0, bottom: 0, child: NoDataWidget()),
            Observer(builder: (context) {
              return LoadingDotsWidget().center().visible(appStore.isLoading);
            }),
          ],
        ),
      ),
    );
  }
}
