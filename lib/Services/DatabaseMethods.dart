import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';

class DatabaseMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Stream<QuerySnapshot>> getUsers(username) async {
    final userinfo = _firestore.collection('users').snapshots();
    print(userinfo);
    return userinfo;
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    _firestore
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    _firestore
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Stream<QuerySnapshot> getConversationMessages(String chatRoomId) {
    return _firestore
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy(kSendTime)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRooms(String userName) {
    print(userName);
    return _firestore
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }

  uploadUserName(userMap) {
    _firestore.collection('users').add(userMap);
  }
}
