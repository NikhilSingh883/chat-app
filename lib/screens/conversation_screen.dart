import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsApp/helper/constraints.dart';
import 'package:whatsApp/screens/chats_screen.dart';
import 'package:whatsApp/widgets/chat/message_bubble.dart';
import 'package:emoji_picker/emoji_picker.dart';

class ConversationScreen extends StatefulWidget {
  final String friendName;
  final String chatRoomId;
  final String url;
  final String name;
  final String email;

  ConversationScreen(
      this.friendName, this.chatRoomId, this.url, this.name, this.email);
  static const String routeName = '/conversation';
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController message = new TextEditingController();
  String _enteredmsg = '';

  void _sendMessage(String chatRoomId) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add({
      'text': message.text,
      'createdAt': Timestamp.now(),
      'username': Constraints.myUsername,
      'userId': Constraints.userId,
    });

    message.clear();
  }

  Widget chatMessageList(String chatRoomId) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ChatRoom")
            .doc(chatRoomId)
            .collection("chats")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (_, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final chatDocs = chatSnapshot.data;
          return chatDocs == null
              ? Center(
                  child: Text('No messages'),
                )
              : ListView.builder(
                  itemCount: chatDocs.documents.length,
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (ctx, idx) {
                    return MessageBubble(
                      chatDocs.documents[idx]['text'],
                      chatDocs.documents[idx]['userId'] ==
                          FirebaseAuth.instance.currentUser.uid,
                      chatDocs.documents[idx]['username'],
                      key: ValueKey(
                        chatDocs.documents[idx].documentID,
                      ),
                    );
                  },
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     color: Colors.black,
        //     focusColor: Colors.grey,
        //     hoverColor: Colors.grey,
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
        body: GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          Navigator.of(context).pushReplacementNamed(ChatsScreen.routeName);
        }
      },
      child: SingleChildScrollView(
        child: Container(
          color: Color(0xff171719),
          child: Column(
            children: [
              Container(
                // height: double.infinity,
                height: MediaQuery.of(context).size.height * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: chatMessageList(widget.chatRoomId)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height * 1.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey[200]),
                          width: MediaQuery.of(context).size.width * 0.78,
                          child: TextFormField(
                            controller: message,
                            textCapitalization: TextCapitalization.sentences,
                            autocorrect: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black38),
                              hintText: 'Send a message',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            onChanged: (value) {
                              _enteredmsg = value;
                            },
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            _sendMessage(widget.chatRoomId);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.only(
                              right: 15,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.green[400]),
                            child: Image(
                              image: AssetImage('assets/images/send.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.url),
                      radius: 150,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.name.toUpperCase(),
                      style: TextStyle(fontSize: 60, color: Colors.white),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
