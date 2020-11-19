import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsApp/models/inbox.dart';

class DataBaseMethods {
  getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String userId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('bond', arrayContains: userId)
        .snapshots();
  }

  Future<Inbox> generateMemoMaterial(String id, String roomId) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    return Inbox(
      roomId: roomId,
      email: userData['email'],
      name: userData['name'],
      url: userData['imageUrl'],
      username: userData['username'],
    );
  }

  Future<Stream<List<Inbox>>> getUserChats2(String userId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('bond', arrayContains: userId)
        .snapshots()
        .asyncMap((event) {
      return Future.wait([
        for (var det in event.docs)
          generateMemoMaterial(
              det['chatRoomId']
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll(userId, ""),
              det['chatRoomId'])
      ]);
    });
  }

  getUserDetails(String userId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }
}
