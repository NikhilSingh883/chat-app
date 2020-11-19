import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String url;
  final String name;

  UserAvatar(this.name, this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(url),
            radius: 40,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            name.toUpperCase(),
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
