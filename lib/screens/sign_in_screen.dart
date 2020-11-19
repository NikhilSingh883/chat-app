import 'package:flutter/material.dart';
import 'package:whatsApp/widgets/auth/auth_form.dart';
import 'package:whatsApp/widgets/bounce.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = 'sign-in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Bounce('assets/images/signIn.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign in to continue',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            AuthForm(true),
          ],
        ),
      ),
    );
  }
}
