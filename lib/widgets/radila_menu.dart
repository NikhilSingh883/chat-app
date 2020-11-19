import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_radial_menu/fl_radial_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsApp/helper/helper_functions.dart';
import 'package:whatsApp/screens/search_screen.dart';
import 'package:whatsApp/screens/sign_in_screen.dart';

class Radialmenu extends StatefulWidget {
  @override
  _RadialmenuState createState() => _RadialmenuState();
}

class _RadialmenuState extends State<Radialmenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      child: RadialMenu(
        [
          RadialMenuItem(
            Icon(
              FontAwesomeIcons.ethereum,
              color: Colors.white,
            ),
            Colors.black,
            () {},
          ),
          RadialMenuItem(
            Icon(
              FontAwesomeIcons.search,
              color: Colors.white,
            ),
            Colors.black,
            () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),
          RadialMenuItem(
            Icon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.white,
            ),
            Colors.black,
            () {
              FirebaseAuth.instance.signOut();
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.of(context)
                  .pushReplacementNamed(SignInScreen.routeName);
            },
          ),
        ],
        childDistance: 80.0,
        fanout: Fanout.topLeft,
        curve: Curves.easeInBack,
        itemButtonRadius: 25,
        mainButtonRadius: 30,
      ),
    );
  }
}
