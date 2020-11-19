import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsApp/screens/search_screen.dart';

class SearchTile extends StatelessWidget {
  final String username;
  final String name;
  final String email;
  final int idx;
  final String url;
  final String userId;

  SearchTile({
    @required this.name,
    @required this.username,
    @required this.email,
    @required this.idx,
    @required this.url,
    @required this.userId,
  });
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;

    return uid == userId
        ? Container()
        : InkWell(
            onLongPress: () {
              openPokemonshortDetail(
                  context,
                  url,
                  idx % 2 == 0 ? Colors.red[100] : Colors.orange[200],
                  name,
                  username,
                  email);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(url),
                    radius: 50,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      createChatRoomWithUser(
                          username, context, userId, email, url, name);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepOrange[900], width: 2),
                          color: Color(0xff171719),
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        'Message',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

void openPokemonshortDetail(BuildContext context, String url, Color color,
    String name, String username, String email) async {
  var _panelHeight = 500;
  await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 500,
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(bottom: 10, left: 40, right: 20, top: 30),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Username  : ' + username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Email  : ' + email,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 420,
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(url),
              radius: 100,
            ),
          ),
        ),
      ],
    ),
  );
}
