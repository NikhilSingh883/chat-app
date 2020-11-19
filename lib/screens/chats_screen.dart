import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsApp/helper/constraints.dart';
import 'package:whatsApp/helper/helper_functions.dart';
import 'package:whatsApp/models/inbox.dart';
import 'package:whatsApp/screens/camera_screen.dart';
import 'package:whatsApp/screens/profile_screen.dart';
import 'package:whatsApp/screens/search_screen.dart';
import 'package:whatsApp/screens/sign_in_screen.dart';
import 'package:whatsApp/screens/status_screen.dart';
import 'package:whatsApp/services/database.dart';
import 'package:whatsApp/widgets/chat/userAvatar.dart';
import 'package:whatsApp/widgets/chat/user_bubble.dart';

class ChatsScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  PageController _pageController = PageController(
    initialPage: 1,
  );
  int currentIndex = 1;

  Widget childWidget = ChildWidget(
    number: AvailableNumber.First,
  );

  List<Inbox> inbox;
  Stream chatRooms;
  Stream<List<Inbox>> chatRooms2;

  getUserInfo() async {
    Constraints.myName = await HelperFunctions.getNameSharedPreference();
    Constraints.isLogIn =
        await HelperFunctions.getUserLoggedInSharedPreference();
    Constraints.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    Constraints.myUsername =
        await HelperFunctions.getUserNameSharedPreference();
    Constraints.userId = await HelperFunctions.getUserIdSharedPreference();
    Constraints.myUrl = await HelperFunctions.getImageUrlSharedPreference();

    DataBaseMethods().getUserChats(Constraints.userId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });

    DataBaseMethods().getUserChats2(Constraints.userId).then((snapshots) {
      setState(() {
        chatRooms2 = snapshots;
      });
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    HelperFunctions.saveUserLoggedInSharedPreference(false);
    Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
  }

  double _width = 0;
  double _height = 0;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff171719),
      body: Stack(
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
                          'Messages',
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()));
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    height: 150,
                    child: storyList(chatRooms),
                  ),
                  Container(
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
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(
                            children: [
                              Text(
                                'Recent',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: chatRoomsList(chatRooms),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
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
                  height: _height,
                  width: _width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Log Out'),
                          SizedBox(width: 5),
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.black,
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              HelperFunctions.saveUserLoggedInSharedPreference(
                                  false);
                              Navigator.of(context)
                                  .pushReplacementNamed(SignInScreen.routeName);
                            },
                            child: Icon(FontAwesomeIcons.signOutAlt,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Search'),
                          SizedBox(
                            width: 5,
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.black,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SearchScreen.routeName);
                            },
                            child: Icon(FontAwesomeIcons.search,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Profile'),
                          SizedBox(
                            width: 5,
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.black,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ProfileScreen.routeName);
                            },
                            child: Icon(FontAwesomeIcons.star,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main',
        child: isOpen
            ? Icon(FontAwesomeIcons.atom, color: Colors.black)
            : Icon(FontAwesomeIcons.battleNet),
        backgroundColor: isOpen ? Colors.white : Colors.black,
        onPressed: () {
          if (isOpen == true) {
            setState(() {
              _height = 0;
              _width = 0;
            });
            isOpen = false;
          } else {
            isOpen = true;
            setState(() {
              _height = 300;
              _width = 200;
            });
          }
        },
      ),
    );
  }
}

Widget storyList(Stream chatRooms) {
  return StreamBuilder(
    stream: chatRooms,
    builder: (_, snapshot) {
      return snapshot.hasData
          ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              scrollDirection: Axis.horizontal,
              // shrinkWrap: true,
              itemBuilder: (__, index) {
                final userID = snapshot.data.documents[index]['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constraints.userId, "");
                return UserAvatar(
                  snapshot.data.documents[index][userID]['name'],
                  snapshot.data.documents[index][userID]['url'],
                );
              })
          : Container();
    },
  );
}

Widget chatRoomsList(Stream chatRooms) {
  return StreamBuilder(
    stream: chatRooms,
    builder: (_, snapshot) {
      return snapshot.hasData
          ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (__, index) {
                final userID = snapshot.data.documents[index]['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constraints.userId, "");
                return UserBubble(
                  roomId: snapshot.data.documents[index]["chatRoomId"],
                  email: snapshot.data.documents[index][userID]['email'],
                  name: snapshot.data.documents[index][userID]['name'],
                  url: snapshot.data.documents[index][userID]['url'],
                  username: snapshot.data.documents[index][userID]['username'],
                );
              })
          : Container();
    },
  );
}

class ChildWidget extends StatelessWidget {
  final AvailableNumber number;
  final Stream chatRoom;

  const ChildWidget({Key key, this.number, this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    if (number == AvailableNumber.First) {
      return CameraScreen();
    } else if (number == AvailableNumber.Second) {
      return chatRoomsList(chatRoom);
    } else if (number == AvailableNumber.Third) {
      return StatusScreen();
    } else {
      return ProfileScreen();
    }
  }
}

enum AvailableNumber {
  First,
  Second,
  Third,
  Fourth,
}
