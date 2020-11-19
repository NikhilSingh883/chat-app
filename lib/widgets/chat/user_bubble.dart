import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsApp/screens/conversation_screen.dart';
import 'package:whatsApp/widgets/search_tile.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserBubble extends StatefulWidget {
  final String username;
  final String roomId;
  final String name;
  final String url;
  final String email;
  UserBubble({
    @required this.username,
    @required this.roomId,
    @required this.name,
    @required this.url,
    @required this.email,
  });

  @override
  _UserBubbleState createState() => _UserBubbleState();
}

class _UserBubbleState extends State<UserBubble> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        openPokemonshortDetail(context, widget.url, Colors.purple, widget.name,
            widget.username, widget.email);
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ConversationScreen(widget.username, widget.roomId, widget.url,
              widget.name, widget.email);
        }));
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(widget.url),
            ),
            SizedBox(width: 20),
            Text(
              widget.username,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
