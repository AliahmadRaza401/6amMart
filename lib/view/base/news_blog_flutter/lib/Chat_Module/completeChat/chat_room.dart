import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_keyboard_flutter/emoji_keyboard_flutter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Chat_Module/chat/chat_profile_screen.dart';
import 'package:news_flutter/Chat_Module/services/fcm_services.dart';
import 'package:news_flutter/Chat_Module/utils.dart';
import 'package:news_flutter/Chat_Module/widgets/customToast.dart';
import 'package:record/record.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:transition_pages_jr/transition_pages_jr.dart';
import 'package:uuid/uuid.dart';
import 'fullPagePhoto.dart';
import 'model/chat_room_model.dart';
import 'model/message_model.dart';
import 'model/user_model.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class ChatRoom extends StatefulWidget {
  final MyUserModel targetUser;
  final ChatRoomModel chatRoom;
  final MyUserModel userModel;
  final status;

  const ChatRoom({
    Key? key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
    required this.status,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;
  final controller = SiriWaveController();

  late AudioPlayer _audioPlayer;
  late String _filePath;

  final record = Record();
  int? selectedIndex;

  double progress = 0.0;

  TextEditingController masgContrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FocusNode focusNode = FocusNode();
  bool isShowSticker = false;

  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    BackButtonInterceptor.add(myInterceptor);
    selectedIndex = -1;
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  File? imageFile;
  String imageUrl = "";
  String videoUrl = "";

  PlatformFile? file;
  UploadTask? uploadTask;

  Future getCameraImage() async {
    Navigator.pop(context);
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage2();
      }
    });
  }

  File? imageFile2;

  Future getImage2() async {
    Navigator.pop(context);
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage2();
      }
    });
  }

  Future uploadImage2() async {
    String fileName = Uuid().v1();
    int status = 1;
    MessageModel newMessage = MessageModel(
      messageid: fileName,
      sender: widget.userModel.uid.toString(),
      text: "",
      seen: false,
      type: "image",
      createdon: DateTime.now(),
    );

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    final path = 'imageFiles/$fileName';
    final fle = File(imageFile!.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    if (status == 1) {
      if (mounted) {
        setState(() {
          uploadTask = ref.putFile(fle);
        });
      }
      try {
        final snap = await uploadTask!.whenComplete(() => {});
        imageUrl = await snap.ref.getDownloadURL();
        await _firestore
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .collection('messages')
            .doc(fileName)
            .update({"text": imageUrl});

        widget.chatRoom.lastMessage = "Image File";
        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .set(widget.chatRoom.toMap());

        FCMServices.sendFCM("user", widget.targetUser.uid.toString(),
            "New Message", "Image File");
        if (mounted) {
          setState(() {
            isLoading = false;
            uploadTask = null;
          });
        }
      } on FirebaseException catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
            status = 0;
            uploadTask = null;
          });
        }
        ToastUtils.showCustomToast(
            context, e.message ?? e.toString(), AppColors.darkBlueColor);
      }
    }
  }

  sendMsg(String mType, String mText) async {
    MessageModel newMessage = MessageModel(
      messageid: uuid.v1(),
      sender: widget.userModel.uid.toString(),
      text: mText,
      seen: false,
      type: mType,
      createdon: DateTime.now(),
    );

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    if (mType == "audio") {
      widget.chatRoom.lastMessage = "audioFile";
    } else {
      widget.chatRoom.lastMessage = masgContrl.text;
    }

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .set(widget.chatRoom.toMap());

    FCMServices.sendFCM(
        widget.targetUser.deviceToken.toString(),
        widget.targetUser.uid.toString(),
        "New Message",
        widget.chatRoom.lastMessage.toString());
    masgContrl.clear();
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    if (mounted) {
      setState(() {
        emojiShowing = !emojiShowing;
        //isShowSticker = !isShowSticker;
      });
    }
  }

  bool isRecording = false;

  Future<bool> onBackPress() {
    if (isShowSticker) {
      if (mounted) {
        setState(() {
          isShowSticker = false;
        });
      }
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  bool play = false;
  double _amplitude = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FeatherIcons.chevronLeft,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AppColors.darkBlueColor,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                RouteTransitions(
                  context: context,
                  child: ChatProfilePage(
                      chatRoom: true,
                      targetUser: widget.targetUser,
                      userid: widget.targetUser.uid.toString(),
                      name: widget.targetUser.username.toString()),
                  animation: AnimationType.fadeIn,
                );
              },
              child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: ExactAssetImage('Images/chat/userImage.jpeg'),
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.targetUser.username.toString(),
                  style: GoogleFonts.rubik(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                Row(children: [
                  Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.status.toString() == "online"
                            ? Colors.lightGreenAccent
                            : Colors.grey),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    widget.status.toString() == "online"
                        ? "Active Now"
                        : "offline",
                    style: GoogleFonts.rubik(
                      fontSize: 10.sp,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoom.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        if (dataSnapshot.docs.length > 0) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);
                              // Text
                              return currentMessage.type == "text"
                                  ? Row(
                                      mainAxisAlignment:
                                          (currentMessage.sender ==
                                                  widget.userModel.uid)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              (currentMessage.sender ==
                                                      widget.userModel.uid)
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                        text: currentMessage
                                                            .text))
                                                    .then((value) =>
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            backgroundColor:
                                                                AppColors
                                                                    .lgColor,
                                                            content: Text(
                                                              'Message Copied',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ));
                                              },
                                              child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 300.w,
                                                      minWidth: 50.w),
                                                  //width:MediaQuery.of(context).size.width * 0.7,
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 0,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20,
                                                  ),
                                                  decoration: currentMessage
                                                              .sender ==
                                                          widget.userModel.uid
                                                      ? BoxDecoration(
                                                          color: AppColors
                                                              .blueColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        )
                                                      : BoxDecoration(
                                                          color: AppColors
                                                              .lBlueColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                  child: Text(
                                                    currentMessage.text
                                                        .toString(),
                                                    style: GoogleFonts.rubik(
                                                      fontSize: 14.sp,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              DateFormat.jm().format(
                                                  currentMessage.createdon!),
                                              style: GoogleFonts.rubik(
                                                fontSize: 10.sp,
                                                color: AppColors.lgColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  // Image
                                  : currentMessage.type == "image"
                                      ? Row(
                                          mainAxisAlignment:
                                              (currentMessage.sender ==
                                                      widget.userModel.uid)
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  (currentMessage.sender ==
                                                          widget.userModel.uid)
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                              children: [
                                                Container(
                                                  child: OutlinedButton(
                                                    child: Material(
                                                      child:
                                                          currentMessage.text !=
                                                                  ""
                                                              ? Image.network(
                                                                  currentMessage
                                                                      .text!,
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              8.r),
                                                                        ),
                                                                      ),
                                                                      width:
                                                                          200.w,
                                                                      height:
                                                                          200.h,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              AppColors.darkBlueColor,
                                                                          value: loadingProgress.expectedTotalBytes != null
                                                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                              : null,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  errorBuilder:
                                                                      (context,
                                                                          object,
                                                                          stackTrace) {
                                                                    return Material(
                                                                      child: Image
                                                                          .asset(
                                                                        'Images/chat/img_not_available.jpeg',
                                                                        width:
                                                                            200.w,
                                                                        height:
                                                                            200.h,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            8.r),
                                                                      ),
                                                                      clipBehavior:
                                                                          Clip.hardEdge,
                                                                    );
                                                                  },
                                                                  width: 200.w,
                                                                  height: 200.h,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Center(
                                                                  child: StreamBuilder<
                                                                          TaskSnapshot>(
                                                                      stream: uploadTask
                                                                          ?.snapshotEvents,
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (snapshot
                                                                            .hasData) {
                                                                          final data =
                                                                              snapshot.data;
                                                                          double
                                                                              progress =
                                                                              (data!.bytesTransferred / data.totalBytes);
                                                                          return SizedBox(
                                                                            width:
                                                                                200.w,
                                                                            height:
                                                                                200.h,
                                                                            child:
                                                                                Stack(
                                                                              fit: StackFit.expand,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 60.w,
                                                                                  height: 60.h,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(70.0),
                                                                                    child: CircularProgressIndicator(value: progress, color: AppColors.darkBlueColor, backgroundColor: Colors.grey),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Text(
                                                                                    '${(100 * progress).roundToDouble()} %',
                                                                                    style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 15.sp),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return SizedBox();
                                                                        }
                                                                      }),
                                                                ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                    ),
                                                    onPressed: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FullPhotoPage(
                                                            url: currentMessage
                                                                .text!,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all<EdgeInsets>(
                                                                EdgeInsets.all(
                                                                    0))),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10, right: 10),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  DateFormat.jm().format(
                                                      currentMessage
                                                          .createdon!),
                                                  style: GoogleFonts.rubik(
                                                    fontSize: 10.sp,
                                                    color: AppColors.lgColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      // Audio
                                      : currentMessage.type == "audio"
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 10,
                                                  left: (currentMessage
                                                              .sender ==
                                                          widget.userModel.uid
                                                      ? 64
                                                      : 10),
                                                  right: (currentMessage
                                                              .sender ==
                                                          widget.userModel.uid
                                                      ? 10
                                                      : 64)),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: currentMessage
                                                              .sender ==
                                                          widget.userModel.uid
                                                      ? AppColors.blueColor
                                                      : AppColors.lBlueColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        play == false
                                                            ? Container(
                                                                width: 40.w,
                                                                height: 40.h,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 0,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .darkBlueColor2,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {
                                                                        play =
                                                                            true;
                                                                        selectedIndex =
                                                                            index;
                                                                      });
                                                                    }
                                                                    controller
                                                                        .setAmplitude(
                                                                            0.8);
                                                                    controller
                                                                        .setSpeed(
                                                                            0.1);
                                                                    controller.setColor(
                                                                        AppColors
                                                                            .darkBlueColor);
                                                                    controller
                                                                        .setFrequency(
                                                                            4);

                                                                    audioPlayer.play(
                                                                        currentMessage
                                                                            .text!,
                                                                        isLocal:
                                                                            false);

                                                                    audioPlayer
                                                                        .onPlayerCompletion
                                                                        .listen(
                                                                            (duration) {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          play =
                                                                              false;
                                                                          selectedIndex =
                                                                              -1;
                                                                        });
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                              )
                                                            : Container(
                                                                width: 40.w,
                                                                height: 40.h,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 0,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .darkBlueColor2,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons.pause,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {
                                                                        play =
                                                                            false;
                                                                      });
                                                                    }
                                                                    controller
                                                                        .setAmplitude(
                                                                            0.0);
                                                                    controller
                                                                        .setSpeed(
                                                                            0.0);
                                                                    controller.setColor(
                                                                        AppColors
                                                                            .darkBlueColor);
                                                                    controller
                                                                        .setFrequency(
                                                                            0);

                                                                    audioPlayer
                                                                        .pause();
                                                                  },
                                                                ),
                                                              ),
                                                        selectedIndex == index
                                                            ? SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.5,
                                                                child: SiriWave(
                                                                  style:
                                                                      SiriWaveStyle
                                                                          .ios_7,
                                                                  controller:
                                                                      controller,
                                                                  options:
                                                                      SiriWaveOptions(
                                                                    height:
                                                                        50.h,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                color:
                                                                    blackColor,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.5,
                                                                height: 2.h,
                                                              )
                                                      ],
                                                    ),
                                                    Text(
                                                      DateFormat.jm().format(
                                                          currentMessage
                                                              .createdon!),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink();
                            },
                          );
                        } else {
                          return Container(
                            height: double.infinity,
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'Images/chat/animation.json',
                                    ),
                                    Text("No Chats"),
                                  ]),
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "An error occurred! Please check your internet connection."),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Say hi to your new friend",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w600, fontSize: 20.sp),
                          ),
                        );
                      }
                    } else {
                      return Center();
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.lBlueColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _isRecorded
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40.h,
                            margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: isRecording
                                      ? Colors.white
                                      : Colors.black12,
                                  spreadRadius: 4.r)
                            ], color: Colors.pink, shape: BoxShape.circle),
                            child: IconButton(
                              icon: Icon(
                                Icons.replay,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              onPressed: _onRecordAgainButtonPressed,
                            ),
                          ),
                          Container(
                            height: 40.h,
                            margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: isRecording
                                          ? Colors.white
                                          : Colors.black12,
                                      spreadRadius: 4.r)
                                ],
                                color: AppColors.darkBlueColor,
                                shape: BoxShape.circle),
                            child: IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              onPressed: _onPlayButtonPressed,
                            ),
                          ),
                          Container(
                            height: 40.h,
                            margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: isRecording
                                      ? Colors.white
                                      : Colors.black12,
                                  spreadRadius: 4.r)
                            ], color: Colors.green, shape: BoxShape.circle),
                            child: IconButton(
                              icon: Icon(
                                Icons.upload_file,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              onPressed: _onFileUploadButtonPressed,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            height: 40.h,
                            margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: isRecording
                                          ? Colors.white
                                          : Colors.black12,
                                      spreadRadius: 4.r)
                                ],
                                color: AppColors.darkBlueColor,
                                shape: BoxShape.circle),
                            child: IconButton(
                              icon: _isRecording
                                  ? Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                      size: 20.sp,
                                    )
                                  : Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                              onPressed: _onRecordButtonPressed,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.face),
                            onPressed: getSticker,
                            color: AppColors.lgColor,
                          ),
                          Flexible(
                              child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lBlueColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              maxLines: 5,
                              minLines: 1,
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return "Message Required!";
                                }
                              },
                              controller: masgContrl,
                              decoration: InputDecoration.collapsed(
                                  border: InputBorder.none,
                                  hintText: "Write text here",
                                  hintStyle: GoogleFonts.rubik(
                                      fontSize: 15.sp,
                                      color: AppColors.lgColor)),
                            ),
                          )),
                          IconButton(
                            icon: Icon(Icons.attach_file),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (builder) => bottomSheet());
                            },
                          ),
                          Container(
                            width: 40.w,
                            height: 40.h,
                            margin: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                                color: AppColors.darkBlueColor2,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    sendMsg("text",
                                        masgContrl.text.trim().toString());
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
              ),
            ),
            Offstage(
              offstage: !emojiShowing,
              child: EmojiKeyboard(
                  emotionController: masgContrl,
                  emojiKeyboardHeight: 300,
                  showEmojiKeyboard: emojiShowing,
                  darkMode: true),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    if (mounted) {
      setState(() {
        _isUploading = true;
      });
    }
    try {
      Reference ref = storage.ref('audioRecords').child(
          _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length));
      UploadTask uploadTask = ref.putFile(File(_filePath));
      uploadTask.then((res) async {
        var audioURL = await res.ref.getDownloadURL();
        String strVal = audioURL.toString();
        await sendMsg("audio", strVal);
      });
      if (mounted) {
        setState(() {
          _isUploading = false;
          _isRecorded = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while uploading'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      record.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool? hasRecordingPermission = await record.hasPermission();

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      await record.start(
        path: filepath,
        bitRate: 128000, // by default
      );

      _filePath = filepath;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }
  }

  bool emojiShowing = false;

  void onTapEmojiField() {
    if (!emojiShowing) {
      if (mounted) {
        setState(() {
          emojiShowing = true;
        });
      }
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (emojiShowing) {
      if (mounted) {
        setState(() {
          emojiShowing = false;
        });
      }
      return true;
    } else {
      return false;
    }
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 180.h,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconCreation(
                  FeatherIcons.image, Colors.purple, "Image", getImage2),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(
                  FeatherIcons.camera, Colors.pink, "Camera", getCameraImage),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icons, Color color, String text, GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}
