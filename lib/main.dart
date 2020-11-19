import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsApp/helper/helper_functions.dart';
import 'package:whatsApp/screens/chats_screen.dart';
import 'package:whatsApp/screens/profile_screen.dart';
import 'package:whatsApp/screens/search_screen.dart';
import 'package:whatsApp/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsApp/screens/sign_up_screen.dart';
import 'package:whatsApp/screens/user_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _userNameEntered = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        _userNameEntered = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeHome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData)
            return _userNameEntered == true ? ChatsScreen() : UserDetails();
          return SignInScreen();
        },
      ),
      routes: {
        SignUpScreen.routeName: (context) => SignUpScreen(),
        ChatsScreen.routeName: (context) => ChatsScreen(),
        SignInScreen.routeName: (context) => SignInScreen(),
        UserDetails.routeName: (context) => UserDetails(),
        SearchScreen.routeName: (context) => SearchScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
      },
    );
  }
}
