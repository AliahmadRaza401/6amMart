
import 'package:flutter/material.dart';

import '../../../model/chat_model.dart';
import 'chatInputField.dart';
import 'message.dart';
class ChatBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: demeChatMessages.length,
              itemBuilder: (context, index) =>
                  Message(message: demeChatMessages[index]),
            ),
          ),
        ),
      const ChatInputField(),
      ],
    );

  }
}