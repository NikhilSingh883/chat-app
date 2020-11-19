import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsApp/helper/constraints.dart';
import 'package:whatsApp/models/filter.dart';
import 'package:whatsApp/screens/chats_screen.dart';
import 'package:whatsApp/screens/conversation_screen.dart';
import 'package:whatsApp/services/database.dart';
import 'package:whatsApp/widgets/search_tile.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_transform/stream_transform.dart' show combineLatest;

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool noUser = false;
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  var filter = Filter.name;

  getData() {
    Stream stream1 = FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: searchTextEditingController.text.trim())
        .snapshots();
    Stream stream2 = FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: searchTextEditingController.text.trim())
        .snapshots();
    Stream stream3 = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: searchTextEditingController.text.trim())
        .snapshots();

    if (filter == Filter.username)
      return stream1;
    else if (filter == Filter.name)
      return stream2;
    else
      return stream3;
  }

  double _width = 0;
  double _height = 0;

  Widget searchList() {
    return StreamBuilder(
      stream: getData(),
      builder: (ctx, userSnapshot) {
        final userDocs = userSnapshot.data;
        return userDocs == null
            ? Center()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: userDocs.documents.length,
                reverse: true,
                itemBuilder: (ctx, idx) {
                  return SearchTile(
                    name: userDocs.documents[idx]['name'],
                    username: userDocs.documents[idx]['username'],
                    email: userDocs.documents[idx]['email'],
                    url: userDocs.documents[idx]['imageUrl'],
                    userId: userDocs.documents[idx]['userId'],
                    idx: idx,
                  );
                },
              );
      },
    );
  }

  double __width = 0;
  double __height = 0;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff171719),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            Navigator.of(context).pushReplacementNamed(ChatsScreen.routeName);
          }
        },
        child: Stack(
          overflow: Overflow.clip,
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Text(
                            'Search',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xff444446),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _height = 50;
                                  _width = MediaQuery.of(context).size.width;
                                });
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      curve: Curves.ease,
                      duration: Duration(seconds: 1),
                      vsync: this,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 5,
                          right: 5,
                        ),
                        child: Container(
                          height: _height,
                          width: _width,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: searchTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter details....',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white70),
                                ),
                              ),
                              // InkWell(
                              //   child: Container(
                              //     alignment: Alignment.center,
                              //     height: 50,
                              //     width: 50,
                              //     padding: EdgeInsets.all(5),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(25),
                              //       gradient: LinearGradient(
                              //         colors: [
                              //           const Color(0x36FFFFFF),
                              //           const Color(0x0FFFFFFF),
                              //         ],
                              //       ),
                              //     ),
                              //     child: Image.asset(
                              //       'assets/images/search.png',
                              //       height: 25,
                              //       width: 25,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // height: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: searchList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onPanUpdate: (_) {},
              child: Align(
                alignment: Alignment.bottomRight,
                child: AnimatedSize(
                  curve: Curves.easeInOutExpo,
                  duration: Duration(seconds: 1),
                  vsync: this,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      left: 5,
                      right: 5,
                    ),
                    child: Container(
                      height: __height,
                      width: __width,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Name'),
                              SizedBox(width: 5),
                              FloatingActionButton(
                                heroTag: null,
                                backgroundColor: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    filter = Filter.name;
                                    print('name');
                                  });
                                },
                                child: Icon(FontAwesomeIcons.peopleArrows,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Email'),
                              SizedBox(
                                width: 5,
                              ),
                              FloatingActionButton(
                                heroTag: null,
                                backgroundColor: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    filter = Filter.email;
                                    print('email');
                                  });
                                },
                                child: Icon(FontAwesomeIcons.mailBulk,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Username'),
                              SizedBox(
                                width: 5,
                              ),
                              FloatingActionButton(
                                heroTag: null,
                                backgroundColor: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    filter = Filter.username;
                                    print('username');
                                  });
                                },
                                child: Icon(FontAwesomeIcons.male,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main',
        child: isOpen
            ? Icon(FontAwesomeIcons.canadianMapleLeaf, color: Colors.black)
            : Icon(FontAwesomeIcons.cannabis),
        backgroundColor: isOpen ? Colors.white : Colors.black,
        onPressed: () {
          if (isOpen == true) {
            setState(() {
              __height = 0;
              __width = 0;
            });
            isOpen = false;
          } else {
            isOpen = true;
            setState(() {
              __height = 300;
              __width = 200;
            });
          }
        },
      ),
    );
  }
}

Future<void> createChatRoomWithUser(String username, BuildContext context,
    String userId, String email, String imageUrl, String name) async {
  String chatRoomId = getChatRoomId(Constraints.userId, userId);

  Map<String, dynamic> user1 = {
    'name': name,
    'username': username,
    'url': imageUrl,
    'email': email,
  };

  Map<String, dynamic> user2 = {
    'name': Constraints.myName,
    'username': Constraints.myUsername,
    'url': Constraints.myUrl,
    'email': Constraints.myEmail,
  };
  List<String> bond = [userId, Constraints.userId];

  Map<String, dynamic> chatRoomMap = {
    userId: user1,
    Constraints.userId: user2,
    'chatRoomId': chatRoomId,
    'bond': bond,
  };

  await FirebaseFirestore.instance
      .collection('ChatRoom')
      .doc(chatRoomId)
      .set(chatRoomMap);

  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return ConversationScreen(username, chatRoomId, imageUrl, name, email);
  }));
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
