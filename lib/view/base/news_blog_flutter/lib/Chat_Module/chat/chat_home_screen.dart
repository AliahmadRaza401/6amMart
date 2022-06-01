import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transition_pages_jr/transition_pages_jr.dart';

import '../model/chat.dart';
import '../utils.dart';
import 'chatCard.dart';
import 'chatMessage/chat_room_screen.dart';
import 'chat_profile_screen.dart';
class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: (){

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
            Text("Chats",style: GoogleFonts.rubik(fontSize: 22.sp,color: Colors.white),),
          ],
        ),
        actions: [

         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: [
              const Icon(FeatherIcons.search,color: Colors.white,),
               SizedBox(width: 10.w,),
               Stack(
                 children: [
                   Container(
                       width: 40.w,
                       height: 40.h,
                       decoration: const BoxDecoration(
                         shape: BoxShape.circle,
                         image: DecorationImage(
                           image: ExactAssetImage(
                               'images/userImage.jpeg'),
                           fit: BoxFit.fitHeight,
                         ),
                       )),
                   Positioned(
                     right: 0,
                     bottom: 0,
                     child: Container(
                       height: 16,
                       width: 16,
                       decoration: BoxDecoration(
                         color: Colors.green,
                         shape: BoxShape.circle,
                         border: Border.all(
                             color: Theme.of(context).scaffoldBackgroundColor,
                             width: 3),
                       ),
                     ),
                   )
                 ],
               )

               ],
           ),
         )
        ],
        backgroundColor: AppColors.darkBlueColor,
      ),
      body: SafeArea(
        child:  ListView.builder(
          itemCount: chatsData.length,
          itemBuilder: (context, index) => ChatCard(
            chat: chatsData[index],
            press: () => RouteTransitions(
              context: context,
              child:  ChatMessagesScreen(),
              animation: AnimationType.slideIn,
            ),
          ),
        ),
      ),
    );
  }
}
