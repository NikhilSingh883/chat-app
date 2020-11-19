import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final Key key;
  MessageBubble(this.message, this.isMe, this.username, {@required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.green[400],
            borderRadius: BorderRadius.only(
              topLeft: !isMe ? Radius.circular(0) : Radius.circular(15),
              topRight: isMe ? Radius.circular(0) : Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          width: 200,
          padding: EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 19,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                    fontSize: 25, color: isMe ? Colors.black : Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
