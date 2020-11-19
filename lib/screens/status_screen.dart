import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Status screen",
              style: TextStyle(fontSize: 36.0),
            ),
            // Flexible(child: Image.asset("assets/undraw/$file.png"))
          ],
        ),
      ),
    );
  }
}
