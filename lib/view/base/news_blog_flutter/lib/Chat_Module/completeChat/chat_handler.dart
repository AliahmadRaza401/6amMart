import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'model/chat_room_model.dart';

class ChatHandler {
  static ChatRoomModel? chatRoom;

  static Future<ChatRoomModel?> getChatRoom(targetID, userID) async {
    print('userID: $userID');
    print('targetID: $targetID');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
          "participants.${userID}",
          isEqualTo: "user",
        )
        .where(
          "participants.${targetID}",
          isEqualTo: "admin",
        )
        .get();

    if (snapshot.docs.length > 0) {
      print("ChatRoom Available");

      var docData = snapshot.docs[0].data();

      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      print("Exiting chat Room : ${existingChatRoom.chatroomid}");
      print("Exiting chat participants : ${existingChatRoom.participants}");
      chatRoom = existingChatRoom;
    } else {
      print("ChatRoom Not Available");

      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: const Uuid().v1(),
        lastMessage: "",
        participants: {
          targetID.toString(): "admin",
          userID.toString(): "user",
        },
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;
    }

    return chatRoom;
  }
}
