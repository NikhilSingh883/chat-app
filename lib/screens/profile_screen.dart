import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsApp/helper/constraints.dart';
import 'package:whatsApp/screens/chats_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

var colors = [
  Colors.red[100],
  Colors.blue[300],
  Colors.purple[300],
  Colors.green[200],
  Colors.amber[800],
  Colors.brown[400],
  Colors.deepOrange[600],
  Colors.pink[200],
  Colors.tealAccent,
];

Random random = new Random();
Color one = colors[random.nextInt(9)];
Color two = colors[random.nextInt(9)];
Color three = colors[random.nextInt(9)];
Color fourth = colors[random.nextInt(9)];
Color fourth2 = colors[random.nextInt(9)];

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          Navigator.of(context).pushReplacementNamed(ChatsScreen.routeName);
        }
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  one = colors[random.nextInt(9)];
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 40),
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: one,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Text(Constraints.myEmail),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  two = colors[random.nextInt(9)];
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 40),
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: two,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Text(Constraints.myUsername),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  three = colors[random.nextInt(9)];
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 40),
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: three,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Text(Constraints.myName),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  fourth = colors[random.nextInt(9)];
                  fourth2 = colors[random.nextInt(9)];
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [fourth, fourth2]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                    child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.3,
                  backgroundImage: NetworkImage(Constraints.myUrl),
                )),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
